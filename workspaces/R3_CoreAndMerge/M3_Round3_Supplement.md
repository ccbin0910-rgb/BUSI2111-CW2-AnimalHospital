# 成员 7 第三轮补测与五轮复测

成员 3 接手成员 7 回执中欠缺的界面证据。原任务的独立审计以 [成员 7 的 255eced 回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/255ecede794f65edfb76e513b47366a1c2994ff6/workspaces/R7_Forms/Round3_Audit_Log.md) 为准。本次是追加复验。按分工手册 §8.3，轻量窗体由团队决定是否采用。

## 手测结束时的证据口径

成员 3 完成手测并关库后，我从 `M3_R3_Standard_UI_Test.accdb` 用 DAO 只读验证 19/19 项实际保存结果符合预期。副本 SHA256 为 `823569d3f25228efdf6ae8fec7f79969577855eee8dbb351481cae41574a74d6`。18:38 的开库预查在后续保存前，只读到 7 个已保存的文本字段。正式结果以关库后的读回为准。

| 核对项 | 结果 |
|---|---|
| 4 个手测外键 | 界面截图显示预期拒绝。关闭并重开数据库后，读取到对应外键原值。 |
| 13 个手测超长文本 | 行 8–19 和 22 都保存为精确的截断字符串。开库预查时尚未读到的行 11、14、15、16、19、22，关库后分别读回 20、50、100、100、100、60 个 X。 |
| 两个允许值用例 | 成员 3 报告手测完成，关库后读回 `Moderate` 和 `Cash`。`AccountType` 有[实际保存拒绝截图](Evidence/M3_R3_Row23_AccountType_Save.png)。`SeverityLevel` 的手测截图覆盖超长警告，规则报错由 M7 的界面验证和本次 DAO 复测提供证据。 |
| 另外 8 个界面用例 | 成员 3 的 7 个外键和 `InteractionDescription` 已在较早的独立 Access 界面测试中完成并读回，完整说明见下方。 |

## 补测范围

- 补 11 个仅有引擎证据的外键用例。按 Round 3 矩阵输入不存在的键，离开记录或尝试保存，记录实际拦截反馈，再重开核对原键。
- 补 `tblMedicationInteraction.InteractionDescription` 的超长录入。复核 15 个已有 Zoom 提示的用例，记录最终存储长度，或确认 Access 拒绝保存并保留原值。
- 所有测试取发布底库 `810b603` 和修订工作簿 `752bd68`。每轮从提交中的干净底库复制独立 `_Test.accdb`。每次核实目标表、字段、记录及预期。实验产生的数据保留在隔离副本。

## 五轮复测安排

关库读回 19/19 通过后，用五份独立的干净底库副本再跑正式复测。五轮各 27/27 项符合预期，共 135/135 项。每轮验证 11 个外键拒绝、2 个允许值规则拒绝、14 个截断值重新打开后长度正确，并复核 12 条关系和恢复后的 21 条样例记录。原始发布底库摘要重复核对一致。五轮的方式为 Windows Access DAO/SQL，三轮课程界面证据仍单独保留。[关库确认后的五轮结果](M3_Round3_Final_Retest.json)

合库后需对最终候选版本执行结构和关系复核。目前按正式底库开展本次补测。

## 已取得的证据

以下 8 项在本机 Windows Access 数据表视图执行，并用 DAO 重新读取存储值。外键输入均为 999。第 21 项通过 Zoom 输入 256 个 X，看到截断提示后保存。

| 矩阵行 | 字段 | Access 界面提示 | 重读结果 |
|---:|---|---|---|
| 21 | `tblMedicationInteraction.InteractionDescription` | 生成器返回的字符串太长。 结果将被截断。 | 保存为 255 字符 |
| 25 | `tblAppointment.PetID` | 由于数据表 'tblPet' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 26 | `tblAppointment.VetID` | 由于数据表 'tblVeterinarian' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 27 | `tblPrescriptionLine.AppointmentID` | 由于数据表 'tblAppointment' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 28 | `tblPrescriptionLine.MedicationID` | 由于数据表 'tblMedication' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 29 | `tblCashReceipt.ParentID` | 由于数据表 'tblPetParent' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 30 | `tblCashReceipt.AccountID` | 由于数据表 'tblCashAccount' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |
| 31 | `tblCashReceipt.CollectedByVetID` | 由于数据表 'tblVeterinarian' 需要一个相关记录，不能添加或修改记录。 | 原键保留为 1 |

保留[手测前初步引擎结果](M3_Round3_Engine_Retest.json)及[关库前复测结果](M3_Round3_Post_Manual_Retest.json)供追溯。

## 手测过程与证据索引

使用由发布底库 810b603 提取的本地副本 `verification_layout/M3_R3_Manual_Test.accdb`。在 Access 中测试各表第一条记录。对外键用例，输入后按 Shift+Enter，记下提示并撤销编辑。对超长文本，按 Shift+F2，在 Zoom 框内全选并粘贴对应数量的 X，确认后按 Shift+Enter。各字段只测一次。保留成功保存的测试值，关库后由成员 3 用 DAO 读取实际长度。拒绝的编辑应撤销。

成员 3 实际在另一个隔离副本 `verification_layout/M3_R3_Standard_UI_Test.accdb` 完成手测。下表保存操作过程和截图，最终保存结果见本文开头。

| 行 | 字段 | 输入 | 预期 | 实际提示 |
|---:|---|---|---|---|
| 32 | `tblReceiptAllocation.ReceiptID` | 999 | 提示缺少 tblCashReceipt 的关联记录 | 成员 3 手测看到了预期提示，见[截图](Evidence/M3_R3_Row32_ReceiptID.png)。关库后确认原键未变。 |
| 33 | `tblReceiptAllocation.AppointmentID` | 999 | 提示缺少 tblAppointment 的关联记录 | 第二条记录 `(2,1)` 出现预期提示，见[截图](Evidence/M3_R3_Row33_AppointmentID.png)。关库后确认原键未变。 |
| 34 | `tblMedicationInteraction.MedicationAID` | -999 | 提示缺少 tblMedication 的关联记录 | 第一条记录 `(1,2)` 出现预期提示，见[截图](Evidence/M3_R3_Row34_MedicationAID.png)。关库后确认原键未变。 |
| 35 | `tblMedicationInteraction.MedicationBID` | 999 | 提示缺少 tblMedication 的关联记录 | 第二条记录 `(2,3)` 出现预期提示，见[截图](Evidence/M3_R3_Row35_MedicationBID.png)。关库后确认原键未变。 |
| 8 | `tblPetParent.ParentName` | 101 个 X | Zoom 路径截断并保存 100 字符 | 数据表编辑显示[因文本太长而无法编辑](Evidence/M3_R3_Row08_ParentName.png)。改用 Zoom 后显示[结果将被截断](Evidence/M3_R3_Row08_ParentName_Zoom.png)，关库后读回 100 个 X。 |
| 9 | `tblPetParent.Address` | 256 个 X | 截断并保存 255 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row09_Address_Zoom.png)，关库后读回 255 个 X。 |
| 10 | `tblPetParent.DayPhone` | 21 个 X | 截断并保存 20 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row10_DayPhone_Zoom.png)，关库后读回 20 个 X。 |
| 11 | `tblPetParent.EveningPhone` | 21 个 X | 截断并保存 20 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row11_EveningPhone_Zoom.png)，关库后读回 20 个 X。 |
| 12 | `tblPet.PetName` | 81 个 X | 截断并保存 80 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row12_PetName_Zoom.png)，关库后读回 80 个 X。 |
| 13 | `tblPet.Breed` | 101 个 X | 截断并保存 100 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row13_Breed_Zoom.png)，关库后读回 100 个 X。 |
| 14 | `tblPet.Color` | 51 个 X | 截断并保存 50 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row14_Color_Zoom.png)，关库后读回 50 个 X。 |
| 15 | `tblVeterinarian.VetName` | 101 个 X | 截断并保存 100 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row15_VetName_Zoom.png)，关库后读回 100 个 X。 |
| 16 | `tblVeterinarian.RoleTitle` | 101 个 X | 截断并保存 100 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row16_RoleTitle_Zoom.png)，关库后读回 100 个 X。 |
| 17 | `tblAppointment.VisitReason` | 256 个 X | 截断并保存 255 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row17_VisitReason_Zoom.png)，关库后读回 255 个 X。 |
| 18 | `tblAppointment.Diagnosis` | 256 个 X | 截断并保存 255 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row18_Diagnosis_Zoom.png)，关库后读回 255 个 X。 |
| 19 | `tblMedication.MedicationName` | 101 个 X | 截断并保存 100 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row19_MedicationName_Zoom.png)，关库后读回 100 个 X。 |
| 20 | `tblMedicationInteraction.SeverityLevel` | 21 个 X | 允许值规则拒绝，保留原值 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row20_SeverityLevel_Zoom.png)。成员 3 报告手测完成，关库后读回原值 Moderate。 |
| 22 | `tblCashAccount.AccountName` | 61 个 X | 截断并保存 60 字符 | 第一条记录的 Zoom 编辑显示[结果将被截断](Evidence/M3_R3_Row22_AccountName_Zoom.png)，关库后读回 60 个 X。 |
| 23 | `tblCashAccount.AccountType` | 31 个 X | 允许值规则拒绝，保留原值 | 第一条记录先显示[截断提示](Evidence/M3_R3_Row23_AccountType_Zoom.png)，再显示[保存拒绝提示](Evidence/M3_R3_Row23_AccountType_Save.png)。关库后读回原值 Cash。 |
