# 2026-11-22 接管进度与合库交接

成员 1 根据本人授权接管进度核对和交接推进。核对范围为八个角色分支及 M3/M8 固定版本交付文档。本轮为文档审阅，Access 最终合库及跨机验收仍待执行。

## 已核实进度

| 成员 | 证据与状态 |
| --- | --- |
| M1 | [7fb4ebb REA 与假设](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/7fb4ebbeeee6ab7859e0c546d2b82ef2ab7d6127/workspaces/R1_REA/REA_Assumptions.md)，D3 已确认。 |
| M2 | [0c231ee 结构回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/0c231ee195fd1de33f2d66c4abbcd4cdf532a470/workspaces/R2_Dictionary/M2_Core_Review.md)，M3 发布记录引用已签收。 |
| M3 | [bb12b48 合库清单](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/bb12b48fb1dfabaa8f63d88508283c772fb0194f/workspaces/R3_CoreAndMerge/M3_Merge_Checklist.md)，底库发布、查询试合并和 R3 补测已有记录，正式候选库尚待发布。 |
| M4 | [e373560 样例回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/e373560e6f3b1bfb023101175d720e8e034b216a/workspaces/R4_SampleData/M4_Core_Review.md)，M3 记录 21 行、15 个 ID 映射、20 个预期值已对齐。 |
| M5 | [efc7eb7 查询交付](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/efc7eb7a6f71248e2970c033b198d97866cabac7/workspaces/R5_Queries/M5_QUERY_VERIFICATION.md)，11 个查询已交付，M3/M8 记录复核一致。 |
| M6 | [cf861c3 测试记录](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/cf861c3613926c0fd5f86bcd14ae28aa5b8210b4/workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md)，R1–R2 界面矩阵 92/92，另有 13 个 T 场景未完整界面重跑，按原文保留方法范围。 |
| M7 | [255eced 第三轮审计](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/255ecede794f65edfb76e513b47366a1c2994ff6/workspaces/R7_Forms/Round3_And_Relationship_Audit.md)，46 行中 34 行有界面观察，12 行为引擎证据；M3 后续补测见 bb12b48。 |
| M8 | [785f490 报表审计](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/785f490c01630b6325cb69999bdaaaf6e31786d6/workspaces/R8_Reports_UAT/M8_Audit_Report.md)，两份报表已交，可进入集成阶段。Documenter 重导和候选库 UAT 待完成。 |

**状态更新**：M3 清单中“等待 M8 报表库”已被 11 月 21 日晚的 785f490 交付满足。接下来可核对报表来源并推进正式合库。

## 输入版本

- 正式底库取 810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13 的 workspaces/R3_CoreAndMerge/v1_Core_Seeded.accdb，SHA256 为 5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127。
- 查询取 efc7eb7a6f71248e2970c033b198d97866cabac7 的 workspaces/R5_Queries/v2_R5_Queries.accdb。
- 报表取 785f490c01630b6325cb69999bdaaaf6e31786d6 的 workspaces/R8_Reports_UAT/v2_R8_Reports.accdb，报告记载 SHA256 为 61d66836960e3693b15ad4eb7de473c03b04f101e7a428d773e18bb609344e14。
- 本轮读到了 M8 对上述文件的核对记录；接收者下载后须自行核对文件摘要。

## 交接任务

### M8 — Windows 合库执行人（成员 1 于 2026-11-22 指定）

成员 8 在自己的 Windows 和 Access 上代为完成本次集成，在 role/M8-reports 分支及 workspaces/R8_Reports_UAT/ 保存工作稿、候选库与执行记录。成员 1 负责接收与推进。此为成员 1 确认的交接安排，成员 8 的接单回执待返回。

1. 从固定底库建立独立工作稿，按 bb12b48 清单导入 M5 的 11 个查询、M8 的 rpt_01_REA_Diagram 和 rpt_02_System_Design_Notes。逐批核对对象、依赖、完整表值和结构。
2. 确认真实组号与币种标签。在候选库的 Relationships 中生成 rpt_00_Relationships_Report，核对 10 表和 12 条关系。
3. 从该候选库导出原生 Database Documenter。M8 曾遇 Property not found / Disabled Mode，需记录实际错误及修复结果。现有 PDF 页眉指向旧 R5 副本，应保留来源说明并生成当前版本。
4. 完成压缩、重开、查询和三份报表预览，关库后生成 SHA256。把同一候选库、来源、对象清单和检查结果链接交 M1、M7，并同步 M3。候选库修改后重新记录 SHA256 并通知复核方。

### M7 — 最终候选库复核

收到同一 SHA256 的候选库后，在独立副本复核 10 表/46 字段、主外键和 12 条关系方向、参照完整性及级联设置，检查合并影响。回执放 R7 目录和本人分支，附输入摘要、实测方法、证据及未测项，交 M1、合库执行人、M8。

### M7 与 M8 — 跨机验收和结果汇总

M8 完成候选库后，由 M7 在自己的另一台 Windows、无源图的新目录离线重开同一 SHA256 的副本，检查嵌图、查询、报表、说明和样例，并记录 U01–U07 的实际结果。M7 将环境、证据和回执交 M1、M8。M8 据此汇总 UAT_Signoff.md，逐项注明证据来自谁、哪台电脑及输入摘要。M8 的本机检查与 M7 的跨机检查分别留存。

### M6 — 证据范围确认

沿用 cf861c3 记录，确认 13 个尚未完整界面重跑的 T 场景是否有后续补测。提供新增证据或明确保留原范围，避免将引擎测试写成界面测试。T21/T22 保留 KNOWN_LIMITATION。结果放 R6 本人分支，交 M1、M8。

### M1 — 收尾协调

按回执逐项记录已采纳、待修复和待测。确认所有人验收的是同一候选版本。核对 Moodle 的真实组号、截止时刻、上传文件和 AI 声明。最终提交以指定提交人实际上传并下载重开回执为准。

## 当前尚缺

M8 接单回执；最终候选库及摘要；正式关系报表；当前来源 Documenter；跨机 UAT；真实组号/币种和 Moodle 提交规则的最终核对。本机 Mac 本轮没有执行 Access 合库或运行测试。

