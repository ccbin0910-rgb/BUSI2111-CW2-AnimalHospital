# 成员 7 第三轮盲测与关系审计

成员 6 已交回前两轮，第三轮可以开始。按 AGENTS.md 在 `role/M7-audit` 工作。先完成独立测试，再看 [成员 6 的实测回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/cf861c3/workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md)。

1. 从[发布提交 810b603](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13/workspaces/R3_CoreAndMerge/v1_Core_Seeded.accdb) 获取正式底库，核对 SHA256 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`。在本人工作目录制作干净的 `_Test.accdb` 副本。
2. 用同一交接提交里的[修订工作簿](Sample_Data_Master_M7.xlsx)，SHA256 为 `a356a9c4f415682e606aee2d0bf0c4d598697965ff97019f1791b908246528ed`。修订更新了 D1 说明和数据表视图的零长度字符串录入说明。按分工手册第 8 节及 `Field_3Rounds_Matrix` 的 Round 3 列，独立测试 46 个字段，并审计所有 PK、FK、12 条关系方向和参照完整性。
3. 在 `workspaces/R7_Forms/Round3_Audit_Log.md` 记录来源提交、环境、测试方法、实际表现、差异和未测项。完成独立记录后再对照 M6 回执。追加并校验 SQL 日志，经本人确认后将回执与日志推送到本人分支，把固定回执链接交给 M3 并同步 M8。测试数据库留在本地。
