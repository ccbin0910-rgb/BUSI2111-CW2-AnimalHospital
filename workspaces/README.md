# 各角色独立工作目录说明（防二进制 `.accdb` 合并冲突）

- 每位成员和其 AI Agent 只在**本人编号目录**下存放二进制产出文件（`.accdb`、`.xlsx`、`.drawio`、`.png`、`.pdf`）；
- `.gitignore` 已自动排除 Access 锁文件 `*.laccdb` 与本地测试脏库 `*_Test.accdb` / `UAT_Sandbox_Test.accdb` / `Clean_Baseline.accdb`；
- 各目录分工：
  - `R1_REA/`：成员 1 放 `REA_Diagram.png`、源文件与 `REA_Assumptions.md`
  - `R2_Dictionary/`：成员 2 放 `Schema_Freeze.xlsx` / `.md`
  - `R3_CoreAndMerge/`：成员 3 放 `v1_Core_Seeded.accdb` 及 Phase 4 最终合并库 `GroupXX_animalhospital.accdb`
  - `R4_SampleData/`：成员 4 放 `Sample_Data_Master.xlsx`
  - `R5_Queries/`：成员 5 放 `v2_R5_Queries.accdb` 与查询核对清单
  - `R6_ControlTestLog/`：成员 6 放 `Control_Test_Log.md`（测试脏副本保留在本地，不交成员 3 合并）
  - `R7_Forms/`：成员 7 放 `v2_R7_Forms.accdb` 与 `F01–F06` 实测截图记录
  - `R8_Reports_UAT/`：成员 8 放 `v2_R8_Reports.accdb`、`Table_Definitions_Documenter.pdf` 与 `UAT_Signoff.md`
