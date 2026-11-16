# 多机 Multi-Agent Git / Worktree 与 SQL Log 协作指南

> 目标：解决 **“多台电脑、多个 Agent 同时干活时，彼此看得到改了什么、不互相覆盖 `.accdb`/`.sqlite3`、且后续用 SQL 秒查历史问题”**。

---

## 一、核心架构图（文本/SQL 走 Git，二进制按角色分目录，SQL Log 只追加）

```text
           [ GitHub / Gitee 私有远程仓库 (origin/main) ]
                  ▲                       ▲
         push/pull (纯文本+角色物)   push/pull (纯文本+角色物)
                  │                       │
      ┌───────────┴──────────┐ ┌──────────┴───────────┐
      │   组员 A 电脑 (Win)    │ │   组员 B 电脑 (Mac)    │
      │   D:\AIS CW_2\       │ │   ~/Projects/CW2/    │
      │  (如本机开多Agent:    │ │                      │
      │   可用 git worktree) │ │  分支: role/M1-rea   │
      └──────────────────────┘ └──────────────────────┘
                  │                       │
      只编辑 workspaces/R5_Queries/     只编辑 workspaces/R1_REA/
      只新增 handoff_logs/entries/      只新增 handoff_logs/entries/
             *.sql                            *.sql
```

### ⚠️ 两条绝对不能犯的网盘与二进制忌讳
1. **不要把 `.git/` 仓库放在 OneDrive / 百度网盘同步目录里**：网盘会在两台机器同时操作时把 `.git/index` 和对象文件撞出冲突副本导致整个仓库损坏。本方案已把本地 Git 建在纯本地磁盘目录。
2. **不要多人直接修改同一个 `.accdb` 或 `.sqlite3`**：Git 无法合并二进制文件。因此：
   - `.accdb` 必须放在各自角色的 `workspaces/R{N}_*/` 里编辑（成员 3 最后在 `workspaces/R3_CoreAndMerge/` 通过 Access 原生 `External Data -> Import` 合并对象）；
   - AI 协作日志不直接写入单份 `.sqlite3`，而是每次**只新建一条 `.sql` 插入脚本**放入 `handoff_logs/entries/`，靠 Python 随时零冲突重建 `handoff_cache.sqlite3`！

---

## 二、常见三种日常场景怎么用

### 场景 1：在一台电脑上开多个 Agent 并行干不同活（用 `git worktree`）
假设你在自己电脑上既想让 Agent A 审 `02` 蓝图，又想让 Agent B 在隔离目录里改成员 5 的 SQL 查询，互不污染工作目录：

```powershell
# 在主仓库 D:\AIS CW_2 执行（前提：主仓库已有至少 1 次 commit）
git worktree add D:\AIS_CW2_wt_M5 -b role/M5-queries
git worktree add D:\AIS_CW2_wt_M7 -b role/M7-forms
```
- Agent A 在 `D:\AIS CW_2` 干活；Agent B 在 `D:\AIS_CW2_wt_M5` 干活；
- 各自结束前都会在各自的 `handoff_logs/entries/` 下生成一个**文件名绝不重复的 `.sql`**；
- 做完后回到主仓库合并分支：`git merge role/M5-queries` → 删除临时 worktree：`git worktree remove D:\AIS_CW2_wt_M5`；
- 因为所有 `.sql` 日志都是独立新文件，**合并永远零冲突**！

### 场景 2：多台不同电脑上的组员 & 各自 Agent 协作
1. **建私有远程仓库**：组长在 GitHub 或 Gitee 建一个**私有仓库（Private）**，把 `D:\AIS CW_2` 推到 `origin main`：
   ```powershell
   git remote add origin <你的私有仓库URL>
   git push -u origin main
   ```
2. **每位组员在自己电脑克隆仓库**（如 Mac 同学放 `~/Desktop/CW2_Repo`，**不在 iCloud/OneDrive 里建**）：
   ```bash
   git clone <私有仓库URL>
   cd <仓库目录>
   git config user.name "你的英文名或学号"
   git config user.email "你的邮箱"
   git checkout -b role/M1-rea   # 按自己角色编号建分支
   ```
3. **每次开工前先拉最新汇总，看看前面人/AI 干了什么**：
   ```bash
   git pull origin main
   python -X utf8 handoff_logs/query_logs.py --check --summary
   ```
   然后查看刚生成的 `handoff_logs/LOG_SUMMARY.md` 或用 SQL 查特定问题（见下节）。
4. **每次改完交给你的 Agent 写完 `.sql` Log 后提交推送**：
   ```bash
   git status
   git add .
   git commit -m "M1: complete REA diagram and add handoff sql log"
   git push origin role/M1-rea
   ```
5. **如有成员不会用 Git 命令行怎么办？**  
   没关系！不会 Git 的同学把最终产物按要求起好名发群文件或共享盘对应角色文件夹；由组长或成员 8 收齐放进对应 `workspaces/R*_*/` 并让本地 Agent 补一条对应交接 `.sql` 日志即可追踪。

---

## 三、如何用 SQL 秒查历史问题与 AI 协作记录

任何时候运行（支持 Windows 与 Mac，仅依赖 Python 内置 `sqlite3`）：

```bash
# 1. 校验所有 entries/*.sql 语法与必填字段是否完整，并输出摘要到 LOG_SUMMARY.md
python -X utf8 handoff_logs/query_logs.py --check --summary

# 2. 查看每个角色最新动态
python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_latest_by_role;"

# 3. 专门追踪所有 FAIL / BLOCKED / KNOWN_LIMITATION / 未解决事项
python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_open_blockers_and_untested;"

# 4. 检索曾经提及某字段或 Bug 的修改原因与依据（例：查 CollectedByVetID 或 Null）
python -X utf8 handoff_logs/query_logs.py --sql "SELECT created_at, member_role, task_summary, decision_rationale, evidence_refs FROM agent_handoff_logs WHERE files_changed LIKE '%02%' OR decision_rationale LIKE '%Null%' ORDER BY created_at;"

# 5. 提交前一键导出全组诚实的 AI 使用台账（辅助填 Moodle Coversheet）
python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_ai_coversheet_ledger;"
```
