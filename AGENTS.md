# AGENTS.md｜UNNC Animal Hospital (CW2) 多机 Multi-Agent 协作硬规则

> 本文件适用于所有打开 `D:\AIS CW_2`（或其任何 `git clone` / `git worktree` / 共享副本）的 AI Agent。

---

## 一、每次开工前必读（按顺序）

1. 必读 [00_先读我_总览与待核实清单.md](00_先读我_总览与待核实清单.md)（确认 D1–D5 门槛状态与分工）。
2. 必读 [05_AI思考约束边界_课程对齐Prompt.md](05_AI思考约束边界_课程对齐Prompt.md)（证据边界、复杂度边界、内控与验证边界）。
3. 必读 [02_最终版数据库架构蓝图与技术规范.md](02_最终版数据库架构蓝图与技术规范.md)（10 表、46 字段、12 条外键的唯一标准）。
4. 检查历史变更与前任 Agent 留下的证据：
   - 运行 `python -X utf8 handoff_logs/query_logs.py --check --summary`（或在只读环境读取 `handoff_logs/entries/*.sql`），查看最近 5 条记录及开放 blocker，避免推翻已确认决定或重复已定位 Bug。

---

## 每位成员使用固定角色分支

| 成员 | GitHub 分支 | 工作目录 |
| --- | --- | --- |
| 1 | `role/M1-rea` | `workspaces/R1_REA/` |
| 2 | `role/M2-review` | `workspaces/R2_Dictionary/` |
| 3 | `role/M3-review` | `workspaces/R3_CoreAndMerge/` |
| 4 | `role/M4-review` | `workspaces/R4_SampleData/` |
| 5 | `role/M5-queries` | `workspaces/R5_Queries/` |
| 6 | `role/M6-controls` | `workspaces/R6_ControlTestLog/` |
| 7 | `role/M7-audit` | `workspaces/R7_Forms/` |
| 8 | `role/M8-reports` | `workspaces/R8_Reports_UAT/` |

成员及其 AI 开工前先 fetch，确认当前分支和上游均为本人对应角色。个人交付物、测试和回执写入本人目录，SQL 交接日志按下文追加。需要改共享规范时，在本人分支提出，获团队授权后单独集成到 main。main 用于共享规则及已接收成果。日常提交和推送只发往本人的角色分支，由成员确认后执行。

跨角色交接使用来源提交和文件的 GitHub 永久链接。接收方从指定提交读取输入，将需要编辑的副本放入本人目录。交付时回传本人分支、提交及结果链接。角色分支长期保留。

## 二、禁止跨过的 5 条硬红线

1. **禁止篡改官方源文件**：不得修改 `Group Project Assignment 2 - MS ACCESS.pdf` 与 `assignment2_source.md`；不得把组内假设写成指南原文要求，不得擅自将 `two` 改成 `at least two`。
2. **禁止私改冻结标识与未实测虚报 PASS**：未按团队决定流程同步全部下游文件前，不得私自更改 `02` 中的表名、字段名或主键粒度；**代码/SQL/窗体/文档若未在真实 Access 中运行验证，状态只能填 `DOCS_ONLY` / `NOT_RUN` / `PARTIAL` / `KNOWN_LIMITATION`，严禁写 `PASS`**。
3. **禁止污染与冲突（多机 & Worktree 规则）**：
   - 不得把 `.git/` 放入 OneDrive/网盘做实时目录同步；多机文本/SQL/日志通过 Git 远程分支合并，本机多 Agent 并行可使用 `git worktree`（见 [COLLABORATION_WORKTREE_GUIDE.md](COLLABORATION_WORKTREE_GUIDE.md)）。
   - 二进制交付文件（`.accdb`、`.xlsx`、`.drawio`、`.png`）**只能保存在当前角色对应的 `workspaces/R*_*/` 目录**，禁止两人/两机直接覆盖同一个工作中的 `.accdb`。
   - **禁止直接向任何共用的 `.sqlite3` 二进制文件写入记录**；`handoff_logs/handoff_cache.sqlite3` 仅由脚本从文本 `.sql` 重建且被 `.gitignore` 忽略。
4. **禁止修改/删除他人历史 Log**：`handoff_logs/entries/*.sql` 为 **Append-Only（只追加）** 不可变账本；发现前人错漏只能新增一条新的纠偏 `.sql` 文件并在 `decision_rationale` 中引用原 `entry_file`。
5. **禁止堆砌冗长思维独白（对齐 `05`）**：日志不记录模型内部流水账独白，只记录**改了什么、依据、假设、实测结果/未测边界、交接重点**。

---

## 三、每次做完实质变更后的强制动作（必须写出 SQL Log）

只要你在本工作区修改了文档、数据字典、SQL、VBA、Python、测试记录或提交了新的 `.accdb` 版本，**结束本轮工作前必须执行以下 4 步**：

1. **在 `handoff_logs/entries/` 新建 1 个唯一命名的 `.sql` 文件**  
   文件命名：`YYYYMMDD_HHMM_<MEMBER_ROLE>_<short_slug>.sql`（例：`20261117_1430_M5_add_queries_run_check.sql`，若同分钟重名可在分钟后加两位序号如 `_01`）。
2. **按 [handoff_logs/schema.sql](handoff_logs/schema.sql) 精确写入 1 条 `INSERT INTO agent_handoff_logs` 语句**：
   - 单引号必须转义为两个单引号 `''`；
   - `verification_status` 仅允许取值：`PASS` | `FAIL` | `KNOWN_LIMITATION` | `PARTIAL` | `NOT_RUN` | `DOCS_ONLY`；
   - `ai_tool` 与 `ai_usage_scope` 必须如实填写（方便团队后期核对课程 AI 申报封面）。
3. **运行校验命令，确认 SQL 可无错导入并刷新本地摘要**：
   ```bash
   python -X utf8 handoff_logs/query_logs.py --check --summary
   ```
   若团队有可执行的 `revision_manifest.json` 校验或对应角色验收，须在同一轮一并说明实测与未测项。
4. **明确询问组员是否立即提交并推送到 GitHub（禁止静默推送或未推误报“已更新”）**：
   - 结束前须向组员列出本轮全部本地修改与新增文件/截图，主动询问：**“是否现在执行 `commit` 并 `push` 到 GitHub 共享？”**
   - 只有组员确认后才执行 `git commit` 与 `git push`；未执行推送前，绝不能汇报“GitHub 已更新”。
