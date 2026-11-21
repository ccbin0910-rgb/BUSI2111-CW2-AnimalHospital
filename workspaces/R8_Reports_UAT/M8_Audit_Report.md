# Member 8 技术审计与报表交付说明

2026-11-21 · BUSI2111 CW2 · `role/M8-reports`

**报表阶段已验证两份报表，可供 M3 导入。Documenter 归档的来源仍需更新，最终候选库 UAT 尚未执行。**

## 输入、备份与可追溯性

| 输入 | 固定版本与核对结果 |
|---|---|
| 原 R8 附件 | `C:\AIS_CW2\workspaces\R8_Reports_UAT\v2_R8_Reports.accdb`。Access 锁文件仍在，未关闭原实例或删除锁文件。先创建独立备份，再在审计副本运行 Access COM 16.0 / DAO。以共享只读流复核原件，SHA-256 与备份一致，均为 `1E74E5E2CA984EF60572E677FF3D92E8D23E6BD39E2614FB3ADA029B603EC097`。 |
| M3 合库清单 | [`bb12b48` 固定清单](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/bb12b48fb1dfabaa8f63d88508283c772fb0194f/workspaces/R3_CoreAndMerge/M3_Merge_Checklist.md)。允许先准备 R8 报表，M3 正式合库后发布候选库及 SHA-256。 |
| M3 正式底库 | [`810b603` 的 v1_Core_Seeded.accdb](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13/workspaces/R3_CoreAndMerge/v1_Core_Seeded.accdb)，SHA-256 `5779B94439854514F6B32F3BADBF8B132ABF8FD22CAC35AECF3D000D14974127`，与清单一致。 |
| M5 已验收查询 | [`efc7eb7` 的 v2_R5_Queries.accdb](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/efc7eb7a6f71248e2970c033b198d97866cabac7/workspaces/R5_Queries/v2_R5_Queries.accdb)，SHA-256 `6C717BD1CC74BE416C064B35A6B3BFAAE4F6B56C1A707D293BAAC172C0DBD79C`。 |
| M1 正式图 | [`7fb4ebb` 的 REA_Diagram.png](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/7fb4ebbeeee6ab7859e0c546d2b82ef2ab7d6127/workspaces/R1_REA/REA_Diagram.png)，SHA-256 `FBA51FB510B23FD9916823F98EDE3D1987D2997BD4BB5F1B28872ED37A2400A4`，与原 R8 报表中序列化导出的嵌入 PNG 逐字节一致。 |
| 本次交付副本 | 从固定 M3 底库复制，导入固定 M5 的 11 个查询和已验证的两个 R8 报表。未编辑表、样例数据或添加 VBA。关库后 SHA-256 `61D66836960E3693B15AD4EB7DE473C03B04F101E7A428D773E18BB609344E14`。 |

## 实机核验

| 项目 | 结果与证据 |
|---|---|
| 表和样例 | DAO 枚举 10 张本地正式表，`Connect` 全空。逐表按 PK 排序比较原 R8 和正式底库的所有字段值，10/10 相同。DAO 计数为药品 3 条，其余九表各 2 条，合计 21 条。 |
| 字段和主键 | DAO 枚举 46 个字段，46 个 `Description` 均非空。7 张表为单列主键。3 个联合主键分别为处方（AppointmentID、MedicationID）、核销（ReceiptID、AppointmentID）、相互作用（MedicationAID、MedicationBID）。 |
| 查询 | 原 R8 的 11 个 DAO `QueryDef.SQL` 与 M5 逐条完全一致。交付副本导入后 11 个均成功打开 DAO 快照，无意外参数错误。核销余额检查见下表。 |
| 关系 | DAO 对照蓝图第 5 节，12 条端点和方向一致，属性全部为 0，即参照完整性开启，更新和删除级联均关闭。完整端点见下文。 |
| `rpt_01_REA_Diagram` | Access 打开打印预览并导出 1 页横向 PDF。图形、箭头和底部图例完整，无可见裁切。空 `RecordSource`，无查询依赖。Image0 的 `PictureType=0`（Embedded），`SizeMode=3`（Zoom），序列化中有实际 PNG 数据。原件审计副本及重建交付副本的预览渲染像素一致。第二台 Windows 的离线复验留待候选库。 |
| `rpt_02_System_Design_Notes` | Access 打开打印预览并导出 1 页纵向 PDF，六节英文正文可见。空 `RecordSource`，说明中提及的计费和侦测查询属于设计说明，无运行时数据源。T21、T22 均保留。 |
| `rpt_00_Relationships_Report` | 原 R8 的 Access `AllReports` 只有以上两个对象。按固定合库清单，由 M3 在最终候选库生成关系报表。 |

## 查询快照与关系核对

| 查询 | 行数 |
|---|---:|
| qry_00_AppointmentOwner | 2 |
| qry_01_ParentPetCount | 2 |
| qry_02_PrescriptionCharges | 2 |
| qry_02b_AppointmentMedSummary | 1 |
| qry_02c_AppointmentPaidSummary | 1 |
| qry_03_AppointmentTotal | 2 |
| qry_04_AppointmentBalance | 2 |
| qry_05_ReceiptReconciliation | 2 |
| qry_06_PetMedicalHistory | 3 |
| qry_Ctrl_DrugInteractionWarnings | 1 |
| qry_Ctrl_InvalidAllocations | 0 |

`qry_04_AppointmentBalance` 的 A1 总额 205、已付 205、余额 0，A2 总额 90、已付 0、余额 90，与交接基线一致。DAO 快照与候选库最终界面双击检查是不同的验证步骤。

| 父表键 | 子表外键 |
|---|---|
| tblPetParent.ParentID | tblPet.ParentID |
| tblPetParent.ParentID | tblCashReceipt.ParentID |
| tblPet.PetID | tblAppointment.PetID |
| tblVeterinarian.VetID | tblAppointment.VetID |
| tblAppointment.AppointmentID | tblPrescriptionLine.AppointmentID |
| tblMedication.MedicationID | tblPrescriptionLine.MedicationID |
| tblCashReceipt.ReceiptID | tblReceiptAllocation.ReceiptID |
| tblAppointment.AppointmentID | tblReceiptAllocation.AppointmentID |
| tblMedication.MedicationID | tblMedicationInteraction.MedicationAID |
| tblMedication.MedicationID | tblMedicationInteraction.MedicationBID |
| tblCashAccount.AccountID | tblCashReceipt.AccountID |
| tblVeterinarian.VetID | tblCashReceipt.CollectedByVetID |

## 问题、证据与修复

| 状态 | 问题与证据 | 修复或验收条件 |
|---|---|---|
| NEEDS FIX | 现有 `Table_Definitions_Documenter.pdf` 由 Microsoft Access for Microsoft 365 生成，32 页页眉均记录 `C:\AIS_CW2\workspaces\R8_Reports_UAT\v2_R5_Queries (1).accdb`。PDF 提取文本有 10 个正式表名、46 处 Description 和 10 个 Relationships 段。文件名是后来收到的 PDF 名称，页眉显示的是导出时记录的数据库路径。原 R8 与固定 M5 查询 SQL 相同，支持从查询库副本开始准备报表的解释；缺少该旧路径文件的哈希和导出日志，无法确定当时具体是何种复制或重命名操作。 | 原 PDF 随本次交付保留为历史归档，SHA-256 `0248540D61F95278CF688906CD94138E1DDFBAA43CB55601211E1DBA483BF9A8`。应从新交付副本重新运行原生 Database Documenter，勾选全部正式表和字段、属性、关系，检查新 PDF 页眉后交付。已在交付副本的原生 Documenter 中选择全部 10 张表并确认详细选项，Access 随后显示 Property not found，状态栏报告 The action or event has been blocked by Disabled Mode。未更改 Access 安全设置，未生成新版。 |
| BLOCKED | 缺正式关系报表，`AllReports` 未发现该对象。 | M3 在最终命名候选库内从 Relationships 生成报表，核对 10 张表、12 条连线、标题与最终文件名。 |
| 信息项 | 原 R8 的 DAO `AppTitle` 和 `Title` 均不存在，因此没有自定义数据库标题可以与文件名比较。两个预览所见是报表标题。原附件中也没有由这两项属性提供的来源版本记录。 | 交付版本以输入固定提交和关库后的 SHA-256 追溯。关系报表标题由 M3 在最终命名后核对。 |
| BLOCKED | 原 R8 的数据及查询与正式输入一致，但内容一致无法反推原文件生成历史。新 R8 从固定底库重新构建，有明确来源。M3 的固定合库清单标明正式合库、终验尚未完成，本轮没有收到 M3 的最终候选库及 SHA-256。 | M3 导入两个报表并生成关系报表，发布候选库和 SHA-256；M7、M8 对同一版本复核，由 M8 在另一台 Windows 上离线重开后填写 U01–U07。 |

## 上游测试证据边界

- M6 的 R1–R2 界面矩阵覆盖 92/92 个字段轮次，另有引擎控制测试，仍有 13 个 T 场景未做完整可见重跑。T21 宠物转主人会改变历史就诊显示的归属，T22 就诊早于出生日期仍可保存，均保留 `KNOWN_LIMITATION`。 [M6 日志](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/cf861c3613926c0fd5f86bcd14ae28aa5b8210b4/workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md)
- M7 独立 R3 共 46 行，34 行有数据表视图观察，剩余 12 行在其原报告中为 DAO 引擎证据。 [M7 日志](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/255ecede794f65edfb76e513b47366a1c2994ff6/workspaces/R7_Forms/Round3_And_Relationship_Audit.md)
- M3 补录手工 Access 界面证据，并对关闭后的副本读回 19/19，随后 5 次 DAO 回归每次 27/27，合计 135 项。上述结果对应上游试验副本。 [M3 补测](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/bb12b48fb1dfabaa8f63d88508283c772fb0194f/workspaces/R3_CoreAndMerge/M3_Round3_Supplement.md)

候选库 U01–U07 待执行。此报告作为报表阶段交付说明，供 M3 接收对象；候选库验收完成后另写 `UAT_Signoff.md`。本轮未提交或推送。
