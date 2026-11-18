# 成员 5 查询实测与交接

状态 **PASS（成员 5 的 11 个查询和发布样例）**。目标分支为 `role/M5-queries`。交付库为同目录的 `v2_R5_Queries.accdb`。

底库、样例工作簿和 11 份 SQL 均来自成员 3 的同一发布提交 `810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13`。底库 SHA-256 与发布说明一致，为 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`。[成员 3 交接说明](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13/workspaces/R3_CoreAndMerge/M5_QUERY_HANDOFF.md) · [成员 4 工作簿](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13/workspaces/R4_SampleData/Sample_Data_Master.xlsx)

在 Windows 的 Microsoft Access 16.0（16.0.20430.20182）中，通过 Access.Application 和 DAO 按 Q01–Q11 在底库副本创建保存查询。逐个打开只读记录集，关库后使用新的 Access 实例重开，再逐个运行。两次实际结果一致，11 个查询的参数数均为 0。工作簿 `Expected` 的 20 项对照均通过。按 `Seed` 核对了 15 个实际 ID 映射及 21 条原始数据，读取到 10 张表、46 个字段和 12 条关系。

| 顺序 | 查询 | 预期行数 / 实测行数 | 实测结果 |
|---|---|---:|---|
| Q01 | `qry_00_AppointmentOwner` | 2 / 2 | A1、A2 都归属 P1（Emily Chen） |
| Q02 | `qry_01_ParentPetCount` | 2 / 2 | Emily 2 只，David 0 只 |
| Q03 | `qry_02_PrescriptionCharges` | 2 / 2 | A1 的 Doxycycline oral suspension：数量 2，目录价 35.00，收费单价 30.00，小计 60.00。Sucralfate oral suspension：数量 1，目录价与收费单价均为 25.00，小计 25.00 |
| Q04 | `qry_02b_AppointmentMedSummary` | 1 / 1 | A1 药费 85.00，A2 无分组记录 |
| Q05 | `qry_02c_AppointmentPaidSummary` | 1 / 1 | A1 已核销 205.00，A2 无分组记录 |
| Q06 | `qry_03_AppointmentTotal` | 2 / 2 | A1：120.00 + 85.00 = 205.00。A2：90.00 + 0.00 = 90.00 |
| Q07 | `qry_04_AppointmentBalance` | 2 / 2 | A1 收费 / 核销 / 余额为 205.00 / 205.00 / 0.00。A2 为 90.00 / 0.00 / 90.00 |
| Q08 | `qry_05_ReceiptReconciliation` | 2 / 2 | R1 实收与核销均为 100.00，R2 均为 105.00，两笔差额均为 0.00 |
| Q09 | `qry_Ctrl_InvalidAllocations` | 0 / 0 | 发布样例中没有查到异常核销 |
| Q10 | `qry_Ctrl_DrugInteractionWarnings` | 1 / 1 | A1 命中 Doxycycline oral suspension 与 Sucralfate oral suspension，演示等级为 Moderate |
| Q11 | `qry_06_PetMedicalHistory` | 3 / 3 | Mochi 两条处方明细。Boba 一条无处方记录，药名、数量和收费单价均为 Null |

合计收费 295.00，实收 205.00，尚欠 90.00。全部核对项无差异。工作簿旧注仍将第三种药标为暂定，实际验收按成员 3 发布说明中已确认的 D1 口径，药品表三行。币种标签仍待组内确认。

本次覆盖发布样例和查询重开。非法录入、异常核销的各类正向检出、组装后的最终库和跨机器验收待下游测试。Q09 和 Q10 用于侦测。成员 3 集成时请从本库导入 11 个查询对象，保留正式库已有表和样例，并在合并库重跑以上核对。成员 6 可用独立副本执行异常场景。
