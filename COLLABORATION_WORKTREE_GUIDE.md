# 多机 Multi-Agent Git / Worktree 与 SQL Log 协作指南

> 目标：解决 **“多台电脑、多个 Agent 同时干活时，彼此看得到改了什么、不互相覆盖 `.accdb`/`.sqlite3`、且后续用 SQL 秒查历史问题”**。

---

## 日常操作

在 [AGENTS.md](AGENTS.md) 查本人编号对应的固定分支和工作目录。以下以成员 5 为例，其他成员替换分支名与目录名。每位成员只向自己的 GitHub 分支上传。

```bash
git fetch origin
git switch role/M5-queries
git branch -vv
git pull --ff-only origin role/M5-queries
python -X utf8 handoff_logs/query_logs.py --check --summary
```

新克隆的仓库会在首次切换时跟踪对应的远端分支。已有未提交工作的同学先检查 `git status`，保留原有改动。多角色共用一台电脑时可为每个固定分支开独立 worktree，例如从仓库根目录运行 `git worktree add ../CW2-M5 role/M5-queries`（本地已有该分支且尚未检出时）。

从派工方给出的提交读取输入，把待编辑的数据库复制到本人角色目录。只暂存本轮具体交付文件和新增 SQL 日志，检查 `git diff --cached --stat`，经成员确认后提交，并执行例如 `git push origin HEAD:role/M5-queries`。向接收方返回结果文件的固定提交链接。集成者核对交付物后按任务选取文件；Access 对象由成员 3 在集成副本中导入。

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
