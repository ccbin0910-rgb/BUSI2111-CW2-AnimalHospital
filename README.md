# BUSI2111 CW2 — UNNC Animal Hospital (MS Access) 协作总入口与使用教程

> **仓库地址**：`https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital.git`  
> **当前版本**：2026-11-16 R4（已对齐官方 **4×25 Grading Rubrics** 与 **Computer Lab 2** 14 页指南）  
> **截止时间**：2026 年 11 月 27 日（周五）15:00（提交文件名：`GroupNo_animalhospital.accdb`）

本页是打开 GitHub 仓库的第一入口，分为 **【一、给 8 位组员的使用教程】**、**【二、给每位组员 AI Agent 的使用教程】** 和 **【三、核心文档导航】**。

---

## 一、给 8 位组员的傻瓜式使用教程（人怎么用这套系统）

### 第 1 步：把仓库拉到自己电脑（不要放进 OneDrive / iCloud 同步目录！）
打开终端（Windows 用 PowerShell / Git Bash，Mac 用 Terminal），切到纯本地目录（如 `D:\` 或 `~/Desktop`）执行：

```bash
git clone https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital.git
cd BUSI2111-CW2-AnimalHospital
```

*(如果不会用命令行 Git：直接在 GitHub 页面右上角点绿色的 **`<> Code` → `Download ZIP`** 解压到本地桌面，做完自己那部分后把产物发群里，由组长或成员 8 放入对应 `workspaces/R*_*/` 目录代为提交。)*

### 第 2 步：按编号认领自己的任务（只看这 3 份文件就够了）
1. 先花 3 分钟看 [00_先读我_总览与待核实清单.md](00_先读我_总览与待核实清单.md)：看清全组时间轴与你属于 **成员 1～8** 哪一号。
2. 打开 [03_八人傻瓜式分工SOP与AI_Prompt手册.md](03_八人傻瓜式分工SOP与AI_Prompt手册.md)，直接翻到**你自己的成员章节**：
   - 里面有**精确到中英文菜单按钮的一步步点击步骤**；
   - 有**可以直接复制粘贴给 AI 的专属 Prompt**；
   - 有**交接前自检的 3 个小问题与答案要点**。
3. 查表名、字段名、验证规则或 SQL 时，以 [02_最终版数据库架构蓝图与技术规范.md](02_最终版数据库架构蓝图与技术规范.md) 为**唯一标准**，任何人禁止私自改名。

### 第 3 步：你的文件存去哪？（防二进制 `.accdb` 冲突铁律）
- **绝对不要**两个人同时改同一个 `.accdb` 文件！
- 你做出来的 `.accdb`、`.xlsx`、`.drawio`、`.png`、`.md` 测试记录，**一律放进你自己的专属子文件夹**：
  - 成员 1 → `workspaces/R1_REA/`
  - 成员 2 → `workspaces/R2_Dictionary/`
  - 成员 3 → `workspaces/R3_CoreAndMerge/`
  - 成员 4 → `workspaces/R4_SampleData/`
  - 成员 5 → `workspaces/R5_Queries/`
  - 成员 6 → `workspaces/R6_ControlTestLog/`（注意：破坏性测试脏副本留在本地，只交测试日志！）
  - 成员 7 → `workspaces/R7_Forms/`（存放【P0】第 3 轮 46 字段盲测与 12 关系方向审计报告，及【P1 可选】轻量窗体库）
  - 成员 8 → `workspaces/R8_Reports_UAT/`

### 第 4 步：日常开工前 & 完工后跑哪两条命令？
```bash
# 每天开工前：拉取全组最新进度 + 查看前人/AI 干了什么
git pull origin main
python -X utf8 handoff_logs/query_logs.py --check --summary
```
查看生成的本地 `handoff_logs/LOG_SUMMARY.md` 即可看到最近所有人的进度与未解问题。

---

## 二、给每位组员 AI Agent 的使用教程（AI 怎么接入这套系统）

无论你用的是 **Antigravity、Cursor、Claude Code、Windsurf 还是网页版 ChatGPT / DeepSeek**：

### 方式 A：使用本地 AI 编程助手（Antigravity / Cursor / Claude Code 等）
直接让你的 Agent 打开本仓库根目录，对它发这一句启动指令即可：

```text
请先按顺序阅读根目录下的 AGENTS.md、00_先读我_总览与待核实清单.md、05_AI思考约束边界_课程对齐Prompt.md，并运行 `python -X utf8 handoff_logs/query_logs.py --check --summary` 查看历史变更。
我是【成员 X（填你的编号 1~8）】，请对照 03_八人傻瓜式分工SOP与AI_Prompt手册.md 和 02_最终版数据库架构蓝图与技术规范.md 协助我完成我的任务。
注意遵守 AGENTS.md 的全部红线：每次做完实质修改必须在 handoff_logs/entries/ 新增一条 .sql 日志并校验，最后列出变更清单询问我是否 commit & push 到 GitHub。
```

### 方式 B：使用网页版 AI（ChatGPT / DeepSeek / Claude 网页端）
网页版 AI 读不到你电脑里的本地文件，请按以下两步复制粘贴：
1. 打开 [05_AI思考约束边界_课程对齐Prompt.md](05_AI思考约束边界_课程对齐Prompt.md) **第三节**，把那段主约束 Prompt 复制进对话框；
2. 打开 [03_八人傻瓜式分工SOP与AI_Prompt手册.md](03_八人傻瓜式分工SOP与AI_Prompt手册.md) 找到你对应角色的 **“AI Prompt”** 框，连同 [02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 里的相关章节一起贴给它。

### Agent 必须遵守的 4 条自动化规矩（详见 [AGENTS.md](AGENTS.md)）
1. **开工先查账本**：运行 `python -X utf8 handoff_logs/query_logs.py --check --summary`，不推翻已定口径，不把未跑过的 Access 测试标为 `PASS`。
2. **只追加 `.sql` 日志**：每次实质变更后，在 `handoff_logs/entries/` 新建唯一命名的 `YYYYMMDD_HHMM_<ROLE>_<slug>.sql`，严禁修改他人旧日志或直写 `.sqlite3`。
3. **用 SQL 检索历史问题**：Agent 可随时执行：
   ```bash
   # 查所有未关闭阻塞项与待测项
   python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_open_blockers_and_untested;"
   # 导出全组 AI 使用台账（用于最终提交 Coversheet 核对）
   python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_ai_coversheet_ledger;"
   ```
4. **先问再推 GitHub**：每轮结束前列出改动文件清单，主动询问组员**“是否现在执行 `commit` 并 `push` 到 GitHub 共享？”**，确认后再推送。

---

## 三、仓库完整文件导航

| 文件 / 目录 | 给谁看 | 作用说明 |
|---|---|---|
| [README.md](README.md)（本文件） | 全员 + 全体 Agent | GitHub 首页总入口：组员与 Agent 快速上手教程 |
| [AGENTS.md](AGENTS.md) | 全体 AI Agent | 多机 Multi-Agent 协作硬规则、5 条红线与每轮强制 4 步动作 |
| [COLLABORATION_WORKTREE_GUIDE.md](COLLABORATION_WORKTREE_GUIDE.md) | 组长 + 进阶组员 / Agent | 多机 Git 分支、单机多 Agent `git worktree` 隔离与 SQL 日志查询进阶手册 |
| [00_先读我_总览与待核实清单.md](00_先读我_总览与待核实清单.md) | 全组 8 人 | 任务全景、Rubric 4×25 对标、11-16→11-27 推进时间表、D1/D3 拍板清单 |
| [01_指南深度解析与批判性对比报告.md](01_指南深度解析与批判性对比报告.md) | 组长 + 成员 1/2/8 | 业务六要素、官方指南与 4×25 Rubric/Lab 2 拆解、设计取舍对比 |
| [02_最终版数据库架构蓝图与技术规范.md](02_最终版数据库架构蓝图与技术规范.md) | 全员唯一技术标准 | 10 表、46 字段、12 条外键关系、11 个 Access SQL 查询与样本手算期望 |
| [03_八人傻瓜式分工SOP与AI_Prompt手册.md](03_八人傻瓜式分工SOP与AI_Prompt手册.md) | 全组 8 人按号认领 | 每人一步步傻瓜式点击 SOP、专属 AI Prompt、交接前 3 题自检、三轮压测清单 |
| [04_本次修订与验证记录.md](04_本次修订与验证记录.md) | 成员 3/6/7/8 | R2–R4 改动记录、65 项 Access COM/DAO 实测详情与待完成人工测试边界 |
| [05_AI思考约束边界_课程对齐Prompt.md](05_AI思考约束边界_课程对齐Prompt.md) | 全员 + 外部网页 AI | 课程对齐版 AI 思考约束与可复制主 Prompt |
| [workspaces/](workspaces/README.md) | 全组 8 人 | `R1_REA` ～ `R8_Reports_UAT` 分角色独立产出目录（防二进制覆盖） |
| [handoff_logs/](handoff_logs/schema.sql) | 全体 Agent + 组长 | `schema.sql`、`query_logs.py` 与 `entries/*.sql` 只追加交接日志库 |
| [technical/](technical/README.md) | 成员 3/5/6/7 | 11 条独立 `.sql`、自动化校验脚本 `test_cw2_access.py`、原型库与实测 JSON |
