# M2 核心库复核回执（对 M3 评审库 v1_Core_Seeded_REVIEW.accdb）

> **结论：结构层签收。** 10 张表、46 个字段、3 组复合主键、12 条关系与表级规则均与 R2 冻结字典一致；仅发现 **2 类共 8 处文档级差异**，均不改变结构、不阻断 M3 发布 v1 基线。

## 1. 复核对象与方式

| 项 | 内容 |
|---|---|
| 源提交 | `10d44a733e5f6246ab1cb663d001b0ae22d7eef8`（分支 `role/M3-review`，提交说明 “M3: publish seeded Access database for M2 and M4 review”） |
| 评审文件 | `workspaces/R3_CoreAndMerge/v1_Core_Seeded_REVIEW.accdb` |
| SHA256（M3 提供） | `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127` |
| SHA256（本机实测） | `5779B94439854514F6B32F3BADBF8B132ABF8FD22CAC35AECF3D000D14974127` —— **一致** |
| 复核时间 | 2026-11-18 17:49（Asia/Shanghai） |
| 复核人 / 工具 | M2（AI 辅助：DeepSeek Harness，人工确认后提交）；只读方式，未改动评审库 |
| 打开方式 | 本机未安装 Access 桌面版；使用已安装的 ACE 引擎 + DAO（`DAO.DBEngine.120`，`OpenDatabase(..., ReadOnly)`）读取元数据 |
| 比对基准 | `workspaces/R2_Dictionary/Schema_Freeze.xlsx`（v1.0，D3 确认版：46 字段 / 12 关系）与 `02_最终版数据库架构蓝图与技术规范.md` §4–5 |

## 2. 逐项结果

| 检查项 | 预期（字典） | 实测 | 结论 |
|---|---|---|---|
| 表数量 | 10 | 10 | 通过 |
| 字段总数 | 46 | 46 | 通过 |
| 字段名称与顺序 | 46 个 | 逐表顺序完全一致 | 通过 |
| 数据类型 / 大小 | AutoNumber、Short Text(20/30/50/60/80/100/255)、Number(Long/Double)、Date/Time、Currency | 与字典逐字段一致 | 通过 |
| 必填（Required） | 非 AutoNumber 共 39 个：38 个为 Yes，EveningPhone 为 No | 38/38 一致；EveningPhone 为 No；7 个 AutoNumber 见发现 1 | 通过（附 1 条建议） |
| 允许空串（AllowZeroLength） | 16 个文本字段均为 No（EveningPhone 允许 Null，但不允许 `""`） | 16/16 为 No | 通过 |
| Format / 小数位 | 日期 Short Date；金额 Currency + 2；WeightKg Fixed + 2；数量与时长 General Number | 全部一致 | 通过 |
| 字段 Validation Rule / Text | 12 个字段有规则，其余为空 | 12/12 规则与提示逐字一致；其余为空 | 通过 |
| 字段 Description | 46 个全部非空 | 46/46 非空且与字典一致 | 通过 |
| 主键 | 7 个单列 + 3 组复合 | 完全一致 | 通过 |
| 关系（外键） | 12 条 | 12 条，父表 / 子表 / 子表外键全部匹配 | 通过 |
| 参照完整性 | 12 条全部开启，级联删除 / 更新全部关闭 | 12/12 开启；0/12 级联 | 通过 |
| 表级规则 | `tblMedicationInteraction` = `[MedicationAID] < [MedicationBID]` | `[MedicationAID]<[MedicationBID]` | 通过（空格差异，见发现 2） |
| 名称索引 | ParentName / VetName / MedicationName / AccountName 为 Duplicates OK | 4 个非唯一索引齐全 | 通过 |
| 外键索引 | 12 个 | 12 个（rel_1 … rel_12） | 通过 |
| 样例行数 | 9 表各 2 行；Medication 3 行（D1 口径） | 9×2 + 3，与口径一致 | 通过（数据值由 M4 核） |
| 保存查询 | 不在 M2 范围（M5 建 11 个） | 0 个 | 不影响签收 |

**分表明细**：`tblPetParent` 5 · `tblPet` 6 · `tblVeterinarian` 3 · `tblAppointment` 9 · `tblMedication` 3 · `tblPrescriptionLine` 4 · `tblCashReceipt` 6 · `tblReceiptAllocation` 3 · `tblMedicationInteraction` 4 · `tblCashAccount` 3。

## 3. 重点核对项（M3 指定）

| 重点项 | 预期 | 实测 | 结论 |
|---|---|---|---|
| `tblPetParent.EveningPhone` | Short Text(20)、Required = No、AllowZeroLength = No | 完全一致；允许 Null，拒绝空字符串 | 通过 |
| `tblMedicationInteraction` 表级规则 | `[MedicationAID] < [MedicationBID]`，写在表属性而非字段属性 | 规则存在且生效于表级；与字典仅空格差异 | 通过 |
| 三组复合主键 | 处方明细 (AppointmentID, MedicationID)；核销 (ReceiptID, AppointmentID)；药对 (MedicationAID, MedicationBID) | 三组均为双列主键，且各有对应 FK 索引 | 通过 |
| D3 收款经办 | `CollectedByVetID` 必填外键 + 第 12 条关系 | 字段存在、Required = Yes、关系 `tblVeterinarian(1) → tblCashReceipt(∞)` 已建、RI 已开 | 通过 |

## 4. 发现与建议（均为 P3，文档级，不阻断发布）

### 发现 1：7 个 AutoNumber 主键的 Required 与字典不一致

- **预期**（字典）：`tblPetParent.ParentID`、`tblPet.PetID`、`tblVeterinarian.VetID`、`tblAppointment.AppointmentID`、`tblMedication.MedicationID`、`tblCashReceipt.ReceiptID`、`tblCashAccount.AccountID` 均为 `Required = Yes`。
- **实测**：7 个字段均为 `Required = No`。
- **补充验证**：在评审库的**副本**上用 DAO 将 `tblPetParent.ParentID.Required` 设为 `True` 可以成功保存，说明这不是 ACE 引擎的限制，而是建库时未设置。
- **影响**：无功能影响——AutoNumber 由系统生成，不会为空；但字典与实现口径不一致，成员 7 审计时会对不上。
- **建议（二选一，不阻断）**：
  1. M3 在最终 `v1_Core_Seeded.accdb` 中把 7 个 AutoNumber 字段的 Required 设为 Yes（每处约 10 秒）；或
  2. M2 在字典 v1.1 中注明“AutoNumber 由系统生成，Required 可留 No”，并同步 `02`。

### 发现 2：药对表表级规则的空格写法

- **字典**：`[MedicationAID] < [MedicationBID]`
- **实测**：`[MedicationAID]<[MedicationBID]`
- **影响**：语义完全相同，Access 求值不受影响；仅文本不一致。
- **建议**：以库为准，M2 在字典 v1.1 去掉空格；或 M3 加回空格。二者皆可。

## 5. 给 M3 的结论

1. **结构层可以签收**：表、字段、类型、必填、空串、格式、规则、说明、主键、关系、参照完整性全部对齐冻结字典，未发现 P1/P2 问题。
2. **发布 v1_Core_Seeded.accdb 不需要改结构**；如时间允许，只做发现 1 的 7 处 `Required = Yes` 即可让字典与实现完全一致。
3. 建议在发布说明中记录：AutoNumber 的 Required 口径（发现 1）、药对规则的空格写法（发现 2），避免成员 7 复核时重复提出。

## 6. 未测项与边界

| 未测项 | 原因 / 影响 |
|---|---|
| Access 桌面 UI 层（关系窗口排版、说明列显示、数据表视图行为、窗体） | 本机未安装 Access；DAO 读取的是同一份 schema 元数据，但 UI 呈现与窗体未验证 |
| 关系窗口截图核对 | 同上，未做可视化核对；方向依据 DAO 的 Table/ForeignTable 与外键索引判定 |
| 保存查询（11 个） | 评审库中为 0 个，属 M5 建设范围，不在 M2 字典范围 |
| 数据录入与越界压测 | M6/M7 范围；本次只核对样例行数，未核数据值（M4 负责） |
| 跨机打开、Excel 导入导出、压缩修复 | 不在本次复核范围 |

## 7. 复现步骤

1. 从 `role/M3-review` 的 `10d44a7` 取 `workspaces/R3_CoreAndMerge/v1_Core_Seeded_REVIEW.accdb`。
2. `Get-FileHash <file> -Algorithm SHA256`，应为 `5779B9…4127`。
3. 以只读方式打开：PowerShell `New-Object -ComObject DAO.DBEngine.120` → `OpenDatabase(path, 0, $true)`。
4. 遍历 `TableDefs`（字段属性、索引、表级规则）、`Relations`（Table / ForeignTable / Attributes），与 `Schema_Freeze.xlsx` 第 1–2 页逐项比对。
5. 比对脚本与原始 dump 保存在操作者本机工作目录，未入库；如需复现可向 M2 索取。

## 8. 签署

- 复核角色：成员 2（数据字典与 Schema 审计）
- 源提交：`10d44a7`（`role/M3-review`）
- 评审库摘要：`5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`（实测一致）
- 结论：**签收（结构层 100% 通过，附 2 条 P3 文档级建议）**
- 日期：2026-11-18
