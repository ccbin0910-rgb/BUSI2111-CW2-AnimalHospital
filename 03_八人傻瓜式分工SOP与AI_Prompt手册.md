# 八人分工 SOP 与 AI 辅助手册（傻瓜式操作 + 自检版）

> **版本：2026-11-16 R3**（融合 [05 AI 思考约束边界](05_AI思考约束边界_课程对齐Prompt.md) 与课堂规范校准）。  
> **使用铁律**：① 设备预设 **2 Mac + 6 Windows**，组长可按实际电脑调换人员，但**10 表 / 46 字段英文命名以 [02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 为唯一标准，任何人不得私改**；② 每次求助外部 AI 前先看 [05 约束边界](05_AI思考约束边界_课程对齐Prompt.md)，只让 AI 帮写草稿和挑错，**所有数据、SQL、界面与测试结论必须由本人理解并亲手跑出真实结果**；③ 本手册不预设虚假工时或分数，按阶段验收推进。

---

## 0. 一页交接总览表

| 成员 | 上游收到什么 | 本人要做什么 / 交出什么 | 硬性验收怎么看 | 卡住找谁 |
|---|---|---|---|---|
| **成员 1** (Mac 友好) | 官方指南 + 02 第 1/2 节 | `REA_Diagram.png` + 可编辑源文件 + `REA_Assumptions.md` | 按 `Handout_cardinality` 用 `\|, O, <` 与 `▶` 画全 7 实体；逐条能口头读出基数 | 成员 2、组长 |
| **成员 2** (Mac 友好) | 02 第 3–5 节 + 1 的 REA 图 | `Schema_Freeze.xlsx` (或 `.md`)，含 10 表/46 字段/`Handout_normalization` Schema 与 3NF 异常解释 | 与成员 3 建好的真实 Access 表逐列核对无漏、无错 | 成员 1、3 |
| **成员 3** (Win/Access) | 冻结口径 + 4 的样例表 | **Phase 2** `v1_Core_Seeded.accdb`；**Phase 4** 合并集成库 `GroupXX_animalhospital.accdb` | 表/键/验证规则/12 条关系准确；合并只导查询/窗体/报表不导 Tables | 成员 2、8 |
| **成员 4** (Mac 友好) | 02 第 6 节开发样例 | `Sample_Data_Master.xlsx`（`Seed` / `Expected` / `Tests` 三页） | 独立手算验证 205/90 与余额 0/90；明确区分开发 3 药 vs 提交 D1 待定 | 成员 5、6 |
| **成员 5** (Win/Access) | 成员 3 的 `v1_Core_Seeded.accdb` | `v2_R5_Queries.accdb`，含顺序建好的 11 个保存查询 | 双击全跑一遍无“输入参数值”，金额和行数与 4 手算完全一致 | 成员 3、4 |
| **成员 6** (Win/Access) | 底库副本 + 5 的 11 个查询 | `Control_Test_Log.md` + 隔离测试副本（不回传脏数据） | 完成 `T01–T22`（标注 `T21/T22` 为已知限制）；若启用 VBA 再测 `V01–V09` | 成员 5、8 |
| **成员 7** (Win/Access) | 底库副本 + 5 的查询 | `v2_R7_Forms.accdb`（`frm_00_MainMenu` + 3 套主子窗体 + 下拉组合框） | 完成 `F01–F05` 实际点测并与成员 8 在另一台电脑完成 `F06` | 成员 5、8 |
| **成员 8** (Win/Access) | 1 的图、2 字典、5 查询、3 合并库 | 库内报表 (`rpt_00/01/02`)、Documenter PDF、`UAT_Signoff.md`、Rubric 核对 | 离线换路径验证图片嵌入、协助 3 合并与 7 跨机测试、核实提交封面 AI 声明 | 组长、3 |

> **协作补位原则**：成员 3 和成员 7 工作量最集中——**成员 8** 全程协助成员 3 合并回归并协同成员 7 跨机测 `F06`，**成员 5** 支援成员 7 调试下拉框 Row Source SQL。

---

## 1. 全组开工前的 7 条共同铁律

1. **先过 D1 与 D3 门槛（目标 `11-19` 前）**：组长先查 Moodle 是否有新放出的 `Computer Lab 2` / `Rubric` 确认 **D1（每表 2 条 vs 3 种药）** 与 **D3（`CollectedByVetID` 必填假设）**；未获许可前，全组按“开发原型”推进，**绝不对外宣称已是可提交终版**。
2. **禁止网盘实时协同编辑 `.accdb`**：Windows 同学建好本地工作目录（如 `D:\CW2_Work\`），每次备份与发群前**务必先彻底关闭 Access 再复制文件**。Mac 同学负责成员 1/2/4 任务，不强求原生安装 Access。
3. **统一口径先冻结后动手**：成员 3 在 `11-20` 发出 `v1_Core_Seeded.accdb` 后，5/6/7/8 **一律克隆该底座**，严禁各建各的表（否则合并时 AutoNumber ID 和字段拼写一定报错）。
4. **测试副本严格隔离**：所有 `T01–T22` / `V01–V09` 异常和破坏测试只能在后缀 `_Test.accdb` 的副本里做；成员 6 **只交测试日志**，不要让脏数据回流主库。
5. **AutoNumber 跳号正常**：录入或新增时如果 ID 跳过成 `3、4`，记下真实生成的 ID 去填子表外键即可，不要强迫连续而频繁删库重来。
6. **中英文菜单速查**：`Create` = 创建；`Table Design` = 表设计；`Query Design` = 查询设计；`SQL View` = SQL 视图；`Form Wizard` = 窗体向导；`Design View` = 设计视图；`Property Sheet` = 属性表（`Alt+Enter`）；`Database Tools` = 数据库工具；`Relationships` = 关系；`External Data` = 外部数据；`Compact and Repair Database` = 压缩和修复数据库。
7. **多机 Multi-Agent 与 SQL Log 铁律（见 [AGENTS.md](AGENTS.md)）**：① 开工先运行 `python -X utf8 handoff_logs/query_logs.py --check --summary` 查看上游记录；② 本人产出（`.accdb`/`.xlsx`/`.png`）放进 [workspaces](workspaces/README.md) 对应编号目录；③ 每轮让 AI 做完实质修改后，务必让它在 `handoff_logs/entries/` **新建一条独立 `.sql` 交接日志**并跑完 `--check --summary` 校验，不改他人日志也不直接写共用 `.sqlite3`。

---

## 2. 成员 1（Mac 友好）｜REA 概念图与业务假设设计师

- **依赖**：官方指南 + [02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 第一、二节。
- **交付**：`REA_Diagram.png`（白底高清）、`REA_Diagram.drawio`（或 `.pptx` 源文件）、`REA_Assumptions.md`。

### 傻瓜式操作步骤
1. 浏览器打开免费的 `https://app.diagrams.net/`（Draw.io）→ Create New Diagram → Blank Diagram（或使用 PowerPoint）。
2. 按 **“Resources（左）— Events（中）— Agents（右）”三列** 摆好 **7 个方框**：
   - **左列 Resources**：`Medication`（药品）和 `CashAccount`（现金账户，旁边用小字注释课堂惯例 `(cash#, bank, balance — no paper invoices)`）。
   - **中列 Events（自上而下按经济发生顺序）**：`Appointment`（Give 事件：提供诊疗与处方）和 `CashReceipt`（Take 事件：收到付款）。
   - **右列 Agents & 服务对象**：`Veterinarian`（内部参与者）、`PetParent`（外部参与者）、以及放在 `Appointment` 与 `PetParent` 附近的 `Pet`（标 `[Supporting Entity]`）。
   - **两个禁止**：**不要**把 `PrescriptionLine`、`ReceiptAllocation`、`MedicationInteraction` 画成独立事件/资源框（它们是物理桥接表）；**不要**把发票/收据文档画成 Resource（Week 6 Slide 6：*Documents are not resources*）。
3. 参照 **02 蓝图第二节 Crow's Foot 符号表**逐条画连线、方向动词 `▶` 与两端符号 `|` / `O` / `<`（**记住口诀：某侧“可为 0 或多个”，就把 `O<` 画在贴近该侧框的外端**）：
   - `Veterinarian (|) ── Performs ▶ ── (O<) Appointment`
   - `Pet (|) ── Attends ▶ ── (O<) Appointment`
   - `PetParent (|) ── Owns ▶ ── (O<) Pet`
   - `PetParent (|) ┄┄ Billed for ▶ (via Pet) ┄┄ (O<) Appointment`（画虚线标派生）
   - `Medication (>O) ── Prescribed in ▶ ── (O<) Appointment`
   - `Medication` 自环：`Interacts with ▶`，自环两端均标 `O<`
   - `Appointment (>O) ── Settled by ▶ / Settles ◀ ── (O<) CashReceipt`
   - `CashAccount (|) ── Receives ▶ ── (O<) CashReceipt`
   - `PetParent (|) ── Pays ▶ ── (O<) CashReceipt`
   - `Veterinarian (|) ── Collects ▶ (Prototype Assumption) ── (O<) CashReceipt`（*注：若组长在 11-19 D3 决定删去或改可选 `CollectedByVetID`，本条随蓝图同步更新*）
4. 在图一角加小图例 `Legend: | = One/Required, O = Optional/Zero, < = Many (Handout_cardinality.pdf)`；配色统一整洁即可（课堂幻灯片常见黄框黑线红符号，但是否用该配色不影响得分依据）。
5. 点 `File -> Export as -> PNG`（Zoom `200%`，勾选白底非透明），放大检查文字与 `| / O / <` 不糊，再保存 `.drawio` 源文件。
6. 在 `REA_Assumptions.md` 写明 5 条明确假设与边界：整包装药品计量、仅记已发生就诊、禁止跨主人核销、样例兽医兼收款（D3 待定）、暂不支持改主人后保留历史账单归属（`T21`）。

### AI Prompt（连同 05 边界使用）
```text
请先遵守本组《05 AI 思考约束边界》：仅依据以下我给出的 BUSI2111 原文与假设，不要推断未给出的 Rubric 权重或替我编造业务规则。

我要用 Draw.io 为“UNNC Animal Hospital”画三列式 REA 概念图（采用课程 Handout_cardinality.pdf 首选的 Crow's Foot 符号：|=必须为一，O=可为零，<=多，加动词方向箭头 ▶）。
实体与连线已确定如下：
- 左列 Resources：Medication，CashAccount *(cash#, bank, balance)
- 中列 Events：Appointment，CashReceipt
- 右列 Agents + Supporting：Veterinarian，Pet [Supporting]，PetParent
- 连线与左右端符号：[此处直接粘贴 02 蓝图第二节的 10 行连线对照表]

请帮我做两件事：
1. 生成可直接粘贴进 Draw.io（Arrange -> Insert -> Advanced -> XML 或完整 .drawio XML）的三列排版代码，绝对不要把 PrescriptionLine / ReceiptAllocation / MedicationInteraction 画成方框，也不要画 Invoice 单据，右下角带 | / O / < Legend。
2. 帮我将 5 条设计假设（整包装数量、已发生就诊、禁止跨主人核销、原型假设兽医兼收款、宠物改主人不保留历史归属）润色为 120 词左右的英文 REA Boundary Notes。
```

### 交接前 3 个自检问题（答得上来再交接，对应 `05` 规则 6）
1. **为何 `Pet` 不标成 Resource 或 Agent，而三个 M:N 桥接表不画在概念 REA 图里？**  
   *要点*：`Pet` 是主人拥有的被服务对象（载体），不是医院控制的经济资源也不是决策参与者；`PrescriptionLine` 等 3 个表是概念层两实体之间 `O<` 对 `O<` 多对多关系在物理关系模型中的拆解产物（Week 6 Slide 7）。
2. **怎样证明 `Veterinarian (|) ─── (O<) Appointment` 符号没有画反？**  
   *要点*：用“一条 X 对应几条 Y”反向贴框检查：1 次就诊贴近 `Veterinarian` 侧是恰好 `1` 位兽医 (`|`)；1 位兽医贴近 `Appointment` 侧是 `0` 或多次就诊 (`O<`)，与 Week 6 Slide 8 `Operation (O<) ─── (|) Doctor` 完全一致。
3. **如果 D3 最终决定“病例未要求兽医兼前台收款”，你的图与蓝图怎么改？**  
   *要点*：若删掉物理外键则把 `Veterinarian — CashReceipt` 实线移除（或改虚线并注明概念假设），或者改建独立 `Employee` Agent，使概念图与最终物理表保持严格一致。

---

## 3. 成员 2（Mac 友好）｜数据字典、3NF 与课堂 Schema 审计官

- **依赖**：[02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 第三至五节 + 成员 1 的 REA 图。
- **交付**：`Schema_Freeze.xlsx`（或 `.md`），包含 `1_Tables_Fields`、`2_Relationships_12`、`3_Attribute_Trace`、`4_Schema_3NF` 四页。

### 傻瓜式操作步骤
1. 新建 Excel `Schema_Freeze.xlsx`，第 1 页建 11 列：`TableName | FieldName | DataType | Size_Subtype | PK_FK_Index | Required | AllowZeroLength | Format | ValidationRule | ValidationText | Description`。
2. 逐表抄录 **02 第四节全部 10 张表、46 个字段**，**逐一人工核查 6 个最易写错的卡点**：
   - **电话与零长度字符串**：`DayPhone` / `EveningPhone` 必须是 `Short Text (20)`，所有必填短文本必须设 **`Allow Zero Length = No`**（防止输入 `""` 空串绕过 `Required`）；
   - **日期语法**：`BirthDate` 和 `ReceiptDate` 规则写 `<=Date()`，**绝对不是 Excel 的 `TODAY()`**；
   - **正整数防小数截断**：`Quantity` 和 `DurationMin` 设为 **`Number / Double`** 并配 `=Int([字段名])` 规则（Access 的 Integer 会把 `1.5` 静默四舍五入，Double+Int 才能真拦截）；
   - **金额精度**：所有 `Currency` 字段同时约束正值/非负与 **`Round([字段名], 2)`**（实测拦截 `100.001`）；
   - **跨列规则放置位置**：`tblMedicationInteraction` 的 `[MedicationAID]<[MedicationBID]` 单独标红：**必须写在表属性 `Alt+Enter` 里，不可写在字段属性里**；
   - **同名支持**：`ParentName`、`VetName`、`MedicationName`、`AccountName` 的索引一律为 `Duplicates OK`，靠 ID 识别实体。
3. 第 2 页抄录 **12 条外键关系**（全设 `Enforce Referential Integrity=Yes`、`Cascade Delete=No`）与 **3 个联合主键**（严禁只把两列中的一列当主键）。
4. 第 3 页核对指南 Page 2–3 属性追溯表（标明 `AppointmentFee` 系由 Page 3 正文推得；价格同时呈现 `ListPrice`、`UnitPriceCharged`、`LineCharge`）。
5. 第 4 页**按 `Handout_normalization.pdf` 写法**抄录 **02 第 5.1 节全部 10 张表文本 Schema**（主键下划线、外键斜体），并用**插入/更新/删除异常**（而不是仅写“分了 10 张表”）解释 `WeightKg` 放 `Appointment`、`UnitPriceCharged` 独立、`NumberOfPets` 不落表的原因。
6. 与成员 1 对完图、与成员 3 对完实际建好的表后才宣布冻结。若组长在 11-19 修改 D1/D3，立刻同步更新本字典并群内公告版本。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅依据以下我粘贴的 UNNC Animal Hospital 数据字典和作业原文审阅，不得虚构未提供的新属性，也不要只因有 10 张表就声称满足 3NF。

[在此粘贴 02 蓝图第四、五节（包括 5.1 Schema 与 12 条关系）]

请帮我完成 4 项检查与草稿输出：
1. 检查是否漏掉官方原文 Page 2-3 的任何属性或混淆（包括两种关于 medicine price 的表述），并标出每项属性归属于“原文明确要求 / 逻辑推论 / 原型假设”。
2. 用 1NF/2NF/3NF 与具体的插入、更新、删除异常（Insertion / Update / Deletion Anomalies）写一段约 220 词英文规范化证明，附带 Handout_normalization.pdf 格式（下划线主键、斜体外键）的 10 张表文本 Schema。
3. 专门检查是否存在 Access 语法/类型坑（TODAY 误用、Short Text 零长度、Double+Int 整数验证、Currency Round 两位小数、Alt+Enter 表级规则）。
4. 若某项字段依赖我本人决定（如 CollectedByVetID 是否保留），列明改变它会对哪些表、关系和查询产生连锁影响。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **为什么 `tblPrescriptionLine` 和 `tblReceiptAllocation` 都必须用双列联合主键，而不能只以其中一列作主键？**  
   *要点*：因为两张表分别记录“某次就诊开了哪种药”和“某笔收款分配到哪次就诊”，单列会阻止同一就诊开多种药或一笔收款核销多次就诊，业务粒度决定两列合起来才唯一决定 `Quantity`、`UnitPriceCharged` 和 `AppliedAmount`。
2. **为什么不直接把 `NumberOfPets`（宠物数）存在 `tblPetParent`，把 `WeightKg` 存在 `tblPet`？**  
   *要点*：将宠物数存表会在增删宠物时漏改造成更新异常；将体重放 `tblPet` 会在宠物再次来访更新体重时覆盖掉旧病历体重历史（更新异常），且影响 `tblPet` 对每次就诊的函数依赖正确性。
3. **为什么 `Quantity` 用 `Double + =Int([Quantity])` 而不是直接选 `Integer / Long Integer`？**  
   *要点*：在 Access 表设计中，`Integer/Long Integer` 字段遇到输入的 `1.5` 会直接按银行家舍入变成整数保存而不弹出错误提示；用 `Double` 配合 `=Int(...)` 校验规则才能真正报错拒绝小数输入。

---

## 4. 成员 3（Windows + Access 必需）｜主库底座搭建师与最终合并人

- **依赖**：Phase 2 依赖成员 2 的冻结字典 + 成员 4 的样例表；Phase 4 依赖成员 5/7/8 的独立交付文件。
- **交付**：Phase 2 交 `v1_Core_Seeded.accdb`；Phase 4 交合并且压缩后的 `GroupXX_animalhospital.accdb`。

### 4.1 Phase 2：建表与设规则（一步不错点击顺序）
1. 打开 Access → **Blank database（空白数据库）** → 命名为 `v1_Core_Seeded.accdb` 存在本地目录（不要放 OneDrive 同步盘）→ Create。
2. 点 **Create → Table Design（表设计）**：对照 02 第四节（或成员 2 字典）逐表建齐 10 张表：
   - **主键**：单字段主键点中该行左侧灰框后点工具栏 **Primary Key（主键）**；**联合主键**必须按住 `Ctrl` 同时点击两行左侧灰格，再点 Primary Key（两行均出现钥匙图标）。
   - **文本零长度防坑**：每建一个必填 Short Text 字段，在下方 Field Properties 将 **Required = `Yes`** 且紧跟着把 **Allow Zero Length（允许空字符串）= `No`**；姓名/药名/账户名的 Indexed 选 `Yes (Duplicates OK)`。
   - **正整数规则**：`DurationMin` 和 `Quantity` 类型选 `Number` → Field Size 选 **`Double`**，粘贴蓝图规则 `>0 And <=1440 And =Int([DurationMin])` 与 `>0 And <=100000 And =Int([Quantity])`。
   - **金额精度**：所有 `Currency` 字段（`Decimal Places = 2`），逐一在 Field Validation Rule 填入 `(>=0) And [字段名]=Round([字段名],2)` 或 `(>0) And ...`（严格按蓝图区分诊费/目录价/实收单价可为 `0`，收款总计/分配金额必须 `>0`）。
   - **表 9 跨字段规则（高频坑！）**：保存 `tblMedicationInteraction` 后，保持在设计视图按下 **`Alt + Enter`** 打开右侧 **Property Sheet（属性表）**，确认顶部下拉是 **Table Properties（而不是具体某字段）**，填入 `Validation Rule = [MedicationAID]<[MedicationBID]` 与提示文本 → `Ctrl + S` 保存（若弹窗提示现有数据检验点 Yes）。
3. **写齐 Description**：确认 10 张表一共 **46 个字段的 Description 列全部填写**（Guide 第 1 页明示考点 `Document table definitions`）。

### 4.2 Phase 2：建 12 条关系与按顺序录样例
1. 全部 10 张表关闭后，点 **Database Tools → Relationships（数据库工具 → 关系）** → Add Tables 添加全部 10 张表。
2. 先拖拽 **前 8 条一对多/多对多普通关系**（主表 PK 拖到子表 FK），每次在弹出框**勾选 `Enforce Referential Integrity`（实施参照完整性）**，**绝不勾选 `Cascade Delete Related Records`（级联删除）**。
3. **第 9–12 条同表双线关系**：直接把同一张 `tblMedication` 的 `MedicationID` 分别拖两次连向 `MedicationAID` 和 `MedicationBID`（或再次 Show Table 加入 `tblMedication_1` 显示别名，**Aliases 只是界面视图，不是新建表**），同样拖 `tblVeterinarian` 连向 `tblCashReceipt.CollectedByVetID` 和 `tblCashAccount` 连向 `AccountID`，凑齐 **12 条带 `1` 和 `∞` 的连线**并 `Ctrl+S` 保存关系布局。
4. **严格按顺序录样例（防止外键报错）**：先录无外键主表（① `tblPetParent` → ② `tblVeterinarian` → ③ `tblMedication` → ④ `tblCashAccount`），记下 Access 实际生成的 `AutoNumber` 编号 → 再录中间层（⑤ `tblPet` → ⑥ `tblAppointment` → ⑦ `tblMedicationInteraction` → ⑧ `tblCashReceipt`）→ 最后录明细层（⑨ `tblPrescriptionLine` → ⑩ `tblReceiptAllocation`）。
5. **关闭整个 Access 重新打开**确认表、关系与样例仍在；再复制统一分发给成员 5、6、7、8。群里注明：“当前为 3 种药开发底座，未过 D1 前暂不提交”。

### 4.3 Phase 4：只导应用对象合并（禁止导入 Tables）
1. 先复制一份纯净的 `v1_Core_Seeded.accdb` 改名为合并工作稿（例如 `GroupXX_Merge_Draft.accdb`），并确认 5/7/8 交来的数据库都已关闭。
2. 点 **External Data（外部数据） → New Data Source（新建数据源） → From Database → Access**：
   - 选中 **Import tables, queries, forms, reports, macros, and modules into the current database**。
   - **极重要铁律**：依次选中成员 5 的库只勾 **`Queries` 页签 11 个查询**；成员 7 的库只勾 **`Forms` 页签（注意主窗体与 3 个子窗体都要选，若用了可选 VBA 再在 `Modules` 页签勾模块）**；成员 8 的库只勾 **`Reports` 页签**。**全程绝不勾选 `Tables` 页签！**（成员 6 只交测试报告，**绝对不要**从成员 6 导入任何对象）。
3. **排错防重名**：导入后立刻检查 Queries/Forms/Reports 列表，若发现 `qry_...1` 或 `frm_...1` 后缀重名对象，说明之前导入冲突，先备份后删错保留唯一正确版本，确保按钮与子窗体引用名 100% 匹配。
4. **收尾设置**：
   - 在集成库再次打开 `Database Tools -> Relationships`，微调 10 个方框和别名框使 12 条线互不压字 → 点 **Relationship Report** 生成并覆盖保存为 `rpt_00_Relationships_Report`（这样报表标题里才是正式文件名）。
   - 点 **File → Options → Current Database → Display Form** 设为 `frm_00_MainMenu` → 保存关闭重开验证首页弹出。
   - 若启用可选 VBA，打开 `Alt+F11` → `Debug -> Compile` 确认零编译错误（基础版不要改全局宏安全级别）。
   - 确认所有对象窗口关闭后执行 **Database Tools → Compact and Repair Database**，然后连同备份交成员 8 验收。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅针对我在 Access 建表、设验证规则、建关系或导入合并时遇到的真实报错给步骤，不要建议我删约束、关闭参照完整性或降低全局宏安全设置来隐藏错误。

我按《02 蓝图》10 表/12 关系在 Windows MS Access 操作：
- 当前操作表名/对象名：[写清楚]
- 我在设计视图填写的完整属性（类型/大小/Rule/Required/AllowZeroLength）：[粘贴]
- Access 弹出的完整英文/中文报错全文：[粘贴原文截图文字]

请告诉我：
1. 报错精确原因，以及中英文菜单对应的逐点击修复步骤；
2. 修复完成后需要重新校验哪些关联外键、依赖查询或样本数据。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **为什么合并时绝对不能顺手把成员 5 或成员 7 的 `Tables` 页签也导进来？**  
   *要点*：导入同名表会被 Access 重命名为 `tbl...1`，或者替换掉已经过参照完整性与验证规则核对的统一底库表结构、同时破坏已建立的 12 条外键关系。
2. **为什么 12 条关系都要勾选 `Enforce Referential Integrity`，却全部取消 `Cascade Delete Related Records`？**  
   *要点*：开启参照完整性保证不可能出现无主宠物或无就诊处方；关闭级联删除防止操作员误删一位主人或一只宠物时顺带悄悄销毁历史接诊和现金收款审计记录。
3. **如果合并前成员 5 或成员 7 自己的库里 `AutoNumber` 曾删除重建跳成了 `3、4`，合并时查询会乱吗？**  
   *要点*：只要成员 5/7 的查询与窗体绑定的是字段名而非写死数字 `=1`，且他们自己库里子表填的是对应的真实主键，导回只导对象不导表后在统一底库一样正常工作；唯独手工写死测试脚本才需要按真实 ID 对应。

---

## 5. 成员 4（Mac 友好）｜测试数据设计与独立手算审计官

- **依赖**：[02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 第六节 + 03 第 7 节测试清单。
- **交付**：`Sample_Data_Master.xlsx`（无 Excel 可交 CSV/Markdown），含 **`Seed`（录入底数）**、**`Expected`（手算预期）**、**`Tests`（异常变更场景）** 三页。

### 傻瓜式操作步骤
1. **`Seed` 页**：按 02 第六节录入顺序列出全部 10 张表的虚拟数据行，在表格正上方醒目标注 **“开发验证集：药品 3 条、其余 9 表各 2 条；D1 提交合规待组长 11-19 确认，不擅自加造 ConditionCode”**。
2. **`Expected` 页（独立算一遍，不抄蓝图结论！）**：自己拿计算器按原始单行重新汇总核验：
   - **主人宠物数**：Emily (`Parent 1`) 名下 `Mochi`、`Boba` 共 `2` 只；David (`Parent 2`) 无宠物 = **`0`**；
   - **处方与诊费**：`Appt 1` 开 `Med 1` (`2 × 30.00 = 60.00`，目录价 `35.00`) 与 `Med 2` (`1 × 25.00 = 25.00`，目录价 `25.00`) → 药费 **`85.00`** + 诊费 `120.00` = 就诊总额 **`205.00`**；`Appt 2` 无药费 (`0.00`) + 诊费 `90.00` = 总额 **`90.00`**；
   - **收款与余额**：`R1 (100.00) + R2 (105.00) = 205.00` 全部分配给 `Appt 1` → `Appt 1` 余额 **`0.00`**，`Appt 2` 未收款余额 **`90.00`**；两笔收款未分配余额均为 **`0.00`**；
   - **异常基准**：`InvalidAllocations = 0 行`；`DrugInteractionWarnings = 1 行`（命中 `Appt 1` 的 `(1, 2)` 虚构温和冲突）。
3. **`Tests` 页**：逐条为成员 6 写清 `T07–T20` 每个异常场景的 **4 要素**：**① 初始基线状态 → ② 本次唯一变更操作 → ③ 预期返回几行什么类型异常 → ④ 测完如何删除/改回原值恢复基线**（注意 `T07/T08/T09` 必须彼此隔离，绝不混在一起测试后声称返回 3 行）。
4. **变更通知机制**：只要 D1/D3 使组内调整了任何价格、名称或样例行数，你必须重算 `Expected` 与 `Tests` 预期值并第一时间同步成员 3、5、6、8。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅依据我提供的以下 10 张表样本行进行独立验算，不要只复述或盲从我算好的结果。

[在此粘贴 02 第六节 10 张表的样本行和金额]

请你完成两件事：
1. 独立逐行从原始处方行与分配行累加计算：每位主人宠物数、每行药费、每次就诊总额、每笔收款未分配额、每次就诊未收余额，明确区分“收费（Charge）”与“实收现金（Receipt）”，并列出算式供我交叉核对。
2. 针对 T07（跨主人分配）、T08（单笔收款超额）、T09（就诊超付）、T11（一笔收款分配两次就诊），分别设计“单一隔离变更”的测试记录表，写明：初始状态、唯一新增或修改操作、预期报错或查询结果、以及测完后恢复基线的操作步骤。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **为什么 `Med 1` 的目录价 `ListPrice=35.00`，处方单价却故意写成 `UnitPriceCharged=30.00`？**  
   *要点*：为了把标准目录价与交易实收价格拆开测试，确保如果未来目录价涨成 `99.00`（`T16`），`Appt 1` 已发生的 `205.00` 历史账单和 `0` 余额不会跟着漂移。
2. **为什么样本里特意让 `Parent 2 (David Wang)` 养 `0` 只宠物、且让 `Appt 2` 开 `0` 种药？**  
   *要点*：用来实测查询是否正确用了 `LEFT JOIN` 和 `Nz()`——如果误用 `INNER JOIN` 或 `CCur(Sum(...))`，`Parent 2` 会直接从报表里消失、`Appt 2` 会报错或变成空值。
3. **如果在 `T07` 跨主人测试时，你随手把一笔收款金额设得既跨主人又超出收款额，这算好测试吗？**  
   *要点*：不算；单次场景只能改变一个因素，否则无法判断查询到底抓到了“跨主人”还是抓到了“超额”，还会污染期望行数。

---

## 6. 成员 5（Windows + Access 必需）｜查询构建与数据验证师

- **依赖**：成员 3 建好的 `v1_Core_Seeded.accdb` + [02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 第七节 + 成员 4 的期望值表。
- **交付**：`v2_R5_Queries.accdb`（内含全部 11 个保存查询）+ 查询运行结果截图/核对清单（协助成员 7 写下拉 Row Source）。

### 傻瓜式操作步骤
1. 把成员 3 发来的底库复制一份本地改名为 `v2_R5_Queries.accdb`。
2. **严格按以下两批顺序新建查询（防止引用未建查询导致弹出“输入参数值”！）**：
   - **第一批（无上游查询依赖，先建先运行）**：
     1. `qry_00_AppointmentOwner`（供可选核销验证查主人，也可独立核对每次就诊的主人）
     2. `qry_01_ParentPetCount`
     3. `qry_02_PrescriptionCharges`
     4. `qry_02b_AppointmentMedSummary`
     5. `qry_02c_AppointmentPaidSummary`
     6. `qry_05_ReceiptReconciliation`
     7. `qry_Ctrl_DrugInteractionWarnings`
     8. `qry_06_PetMedicalHistory`
   - **第二批（依赖第一批，必须等前面保存完再建）**：
     9. `qry_03_AppointmentTotal`（依赖 `qry_02b_AppointmentMedSummary`）
     10. `qry_04_AppointmentBalance`（依赖 `qry_03_AppointmentTotal` 和 `qry_02c_AppointmentPaidSummary`）
     11. `qry_Ctrl_InvalidAllocations`（依赖 `qry_04_AppointmentBalance` 和 `qry_05_ReceiptReconciliation`）
3. **每个查询的统一操作点击路径**：点 **Create → Query Design（创建 → 查询设计）** → 弹出的 Add Tables 窗直接点 Close/关闭 → 左上角 **View → SQL View（SQL 视图）** → 从 02 第七节复制对应 SQL（**注意不要把代码块前后的 ````sql ` 和 ```` 一起复制！**）→ 点 `Ctrl + S` 按精确英文名保存 → 点 **Run (`!`)** 运行。
4. **遇错排查铁律**：如果运行查询时弹出 **Enter Parameter Value（输入参数值）** 对话框，我们没有设计参数查询，说明 **字段名拼错、表/查询别名拼错、或者上游依赖查询还没保存**！**立刻点 Cancel 并核对拼写，禁止随便输个数字凑过去！**
5. **逐行对照成员 4 手算预期**：确认 `Appt 1 = 205.00`、`Appt 2 = 90.00`、`Parent 2 = 0`、`InvalidAllocations = 0 行`、`DrugInteractionWarnings = 1 行`。记住：**控制查询只是列出结果数据表，不会自动弹窗阻止录入**。
6. 通知成员 7 窗体下拉框需用的 SQL 写法已就绪，需要调下拉时协助测试；将整份 `v2_R5_Queries.accdb` 交给成员 3（Phase 4 合并）与成员 6（导入测试）。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：只能按 Microsoft Access ACE/Jet SQL 方言（层层括号 JOIN、Nz()、CCur()）分析问题；说明哪些部分是你静态推断的，不能声称已在我的 Access 中运行。

我在构建 11 个查询的 [写查询名，例如 qry_04_AppointmentBalance] 时报错或数据翻倍：
- 我的实际 SQL 语句：[粘贴 Access SQL 视图原文]
- 上游表或依赖查询字段名：[粘贴对应部分]
- Access 真实报错全文（含“输入参数值”提示里的词）或实际出数：[粘贴]

请帮我定位括号配对、依赖先后、Null 处理或连接翻倍问题，给出可直接替换测试的修正 SQL 与预期检查点。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **为什么不能直接把 `tblAppointment` 同时连 `tblPrescriptionLine` 和 `tblReceiptAllocation` 再写 `SUM`，而要先写 `qry_02b` 和 `qry_02c`？**  
   *要点*：当某次就诊有 2 条药行和 2 条分配行时，同时左连接两张明细表会产生 `2 × 2 = 4` 条交叉行，导致诊费与药费重复计入 `SUM`。先各自按 `AppointmentID` 聚合为 1 行后再连接，才能彻底避免笛卡尔积翻倍。
2. **为什么在 `qry_03_AppointmentTotal` 里要写成 `CCur(Nz(M.TotalMedCharge, 0))`，而不是在 `qry_02b` 里直接用 `CCur(Sum(...))`？**  
   *要点*：经过真实 Access 实测，对于没开药的 `Appt 2`，在左连接外层对空行执行从 `CCur(Sum(...))` 返回的 Null 读取会抛出“无效的 null 使用”；辅助汇总只返回原 `Sum`，留到外层先 `Nz(..., 0)` 变零再 `CCur` 才能安全通过。
3. **如果 `qry_Ctrl_DrugInteractionWarnings` 查出了 1 行结果，说明系统在开药时自动阻止医生保存冲突药物了吗？**  
   *要点*：没有！这只是事后**侦测性控制（Detective Control）**，用来提醒人工复核或展示潜在冲突，系统并未在处方表录入前物理阻断提交。

---

## 7. 成员 6（Windows + Access 必需）｜内控、异常与回归测试官

- **依赖**：底库副本 + 成员 5 的 11 个查询 + 成员 4 的预期与恢复步骤（注：若 11-19 D3 改变 `CollectedByVetID`，`T20` 同步调整）。
- **交付**：`Control_Test_Log.md`（列名：`TestID | 版本 | 环境 | 前置基线 | 唯一操作 | 期望结果 | 实际结果与证据 | 结论`）+ 独立 `_Test.accdb` 副本（**严禁把测试副本交成员 3 合并！**）。

### 傻瓜式操作步骤
1. 复制成员 3 底库为 `v2_R6_Control_Test.accdb`，用 `External Data -> Import` 导入成员 5 的 **11 个 Queries**（不要导 Tables），核对全部查询和干净基线正常，再另复制一份备份 `Clean_Baseline.accdb` 方便随时还原。
2. 逐项跑表中 **22 项核心异常测试（`T01–T22`）**。**原则**：先写预期再改数；**涉及破坏或增删改的用例（`T07–T17`、`T21–T22`）每次只用一个干净副本或恢复后单测一个场景**；只能填入亲自执行看到的真实结论，尚未测标 `NOT RUN`。
3. **严格区分 3 种测试性质（对齐 `05` 规则 4 & 5）**：
   - `T01–T06, T12, T18–T20`：验证**表约束 / 参照完整性 / 主键（Preventive）**能否拒绝违规写入或保留正当支持；
   - `T07–T11, T13–T17`：验证**账务核算与侦测查询（Detective）**能否正确发现异常及准确重算；
   - **`T21–T22`：确认已知未实现边界**——这两项在文档和日志中**必须写为 `KNOWN_LIMITATION`（已证实边界存在）**，**绝不能**在给老师说明时说“测试通过，已拦截”。

| ID | 隔离操作（只在测试副本执行） | 期望表现与应标结论性质 |
|---|---|---|
| T01 | `WeightKg=-2`；另测 `Quantity=0` | 验证规则拒绝保存（`Preventive PASS`） |
| T02 | `Quantity=1.5`；另测 `DurationMin=1.5` | 验证规则拒绝小数，不得静默舍入（`Preventive PASS`） |
| T03 | `BirthDate=2099-01-01` | 拒绝未来出生日期（`Preventive PASS`） |
| T04 | 仅将已有就诊的 `PetID` 改 `999`（其余必填全填好） | 参照完整性外键报错拒绝（`Preventive PASS`；确保不是其他空字段引起的） |
| T05 | 删除仍有就诊的 `Pet 1` | 禁止级联删除，拒绝删且病历留存（`Preventive PASS`） |
| T06 | `tblMedicationInteraction` 试插 `(1,1)`、`(2,1)` 及重复 `(1,2)` | 前两个被表级 `Alt+Enter` 规则拦住，重复键被联合主键拦住 |
| T07 | 独立新增 `R3`（`Parent 2`、`50`、有效账户/经办），向 `A2` 分配 `40` | `InvalidAllocations` **只出 1 行 Cross-Parent**（不混超额） |
| T08 | 独立新增 `R3`（`Parent 1`、`50`、有效账户/经办），向 `A2` 分配 `60` | **只出 1 行 Receipt Over-Allocated**（未超过 A2 的 90） |
| T09 | 独立新增 `R3`（`Parent 1`、`120`、有效账户/经办），向 `A2` 分配 `100` | **只出 1 行 Appointment Over-Paid**（未超过 R3 的 120） |
| T10 | 独立新增无分配 `R3=50`；再向 `A2` 分配 `30` | `ReceiptReconciliation` 未分配余额依次为 `50`、`20`，均无异常 |
| T11 | 独立新增 `A3`（同主人、诊费 `50`、无药）；`R3=100` 拆分给 `A2=60` 和 `A3=40` | 分配总额 `100`；余额分别为 `30` 与 `10` |
| T12 | 对已存在 `(R1, A1)` 尝试再插入同主键行 | 联合主键拒绝（需要调金额只能原地修改原行） |
| T13 | 将现有 `(R1, A1)` 的 `100` 改为 `80`（之后恢复） | `R1` 未分配 `20`、`A1` 余额 `20`，不把新旧叠加成 180 |
| T14 | 仅将 `R1.ReceiptTotal` `100` 改为 `90`，原分配 `100` 保持不动（测完恢复） | `InvalidAllocations` 事后检出超收款；说明窗体事件不能保护直接上游改表 |
| T15 | 仅将 `A1.AppointmentFee` `120` 改为 `100`（测完恢复） | 总额降为 `185`，相对已分配 `205` 检出超付 `-20` |
| T16 | `Med 1` 目录价 `35` 改 `99`（测完恢复） | `A1` 历史处方单价 `30` 与总额 `205` 不变 |
| T17 | `Appt 1` 历史处方单价 `30` 改 `20`（测完恢复） | `A1` 总额降为 `185` 检出超付；记录需要历史账单锁定机制 |
| T18 | 新增同名兽医/同名主人；记录不同 `ID` | 允许同名保存；配合 ID/电话能区分，不串单 |
| T19 | `ReceiptTotal=100.001` | 表规则拒绝超过两位小数（`Round(...,2)` 生效） |
| T20 | 收款 `AccountID` 或 `CollectedByVetID` 填 `999` 或留空（依 D3 定稿） | 外键/必填拒绝保存 |
| **T21** | 把已有历史就诊的 `Pet 1` 的主人改挂给 `Parent 2`，查看 `qry_00` 与余额 | **实际行为**：历史就诊所属主人会随当前档案变为 `Parent 2` → **必须标为 `KNOWN_LIMITATION`（未做宠物转主人历史追踪）** |
| **T22** | 把 `Appt 1` 的就诊日期改成早于 `Pet 1` 出生日期的 `2020-01-01` | **实际行为**：Access 允许保存 → **必须标为 `KNOWN_LIMITATION`（缺跨表日期校验）** |

4. **可选核销 VBA 测试（仅当组长决定挂载 [02 第八节](02_最终版数据库架构蓝图与技术规范.md) 的 `modAllocationValidation` 与事件代码时执行）**：
   - 先在测试副本按 02 第八节导入 ASCII 无 BOM 的标准模块，粘贴 `sfrm_ReceiptAllocations_events.txt` 到核销子窗体，确保 `Debug -> Compile` 通过；新增收款时先保存主记录再录子记录，`ReceiptID` / `AppointmentID` 绑定控件存在；
   - 按 `V01–V09` 测试：合法增改（`V01/V06`）、空/负/3 位小数（`V02`）、跨主人（`V03`）、收款超额（`V04`）、就诊超付（`V05`）、已有分配企图修改主外键（`V07`）、测试副本临时改名 `qry_00_AppointmentOwner` 验证依赖缺失 fail-closed 报错拒绝（`V08`）、**直接开表或改上游诊费确认 VBA 只护子窗体入口而非全局保护（`V09`）**。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：不要把“异常查询发现错误”或“确认存在某已知限制”美化成“系统已阻止错误/功能通过”。

请审查我填写的以下测试记录：[粘贴 Control_Test_Log.md]。
请严格检查 4 件事：
1. T07-T09 等测试之间是否真的隔离开初始基线（没有把两个异常混在一个副本里）；
2. 有没有因为别的必填项未填导致的误判 PASS（例如 T04 实际上是不是外键触发的拒绝）；
3. 有没有把 T14/T15/T17（侦测查询检出）或 T21/T22（确认无归属历史/无跨表日期拦截）误标成“系统已阻断”；
4. 对照 02 蓝图检查还有哪些关键场景被漏测或标成了未写具体证据的通过。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **如果在测试完 `T07` 跨主人分配后忘了删掉那条错误分配，紧接着跑 `T08` 会发生什么问题？**  
   *要点*：异常查询 `qry_Ctrl_InvalidAllocations` 会同时输出 `T07` 和 `T08` 两行结果，无法区分究竟哪个测试触发，导致期望行数失效、基线被污染。
2. **为什么 `T21`（改挂主人导致历史账单变更）和 `T22`（就诊日期早于出生日期）哪怕与测试脚本预期一致，也不能在报告里写成“系统防错通过”？**  
   *要点*：因为它们检验的是**“当前设计缺乏该保护的已知局限确实存在”**，写成 PASS 会误导读者以为系统能防止这两类错误；必须归类为 `KNOWN_LIMITATION` 写入局限说明。
3. **当启用核销子窗体 VBA（`V01–V09`）后，为什么我们仍然必须保留 `qry_Ctrl_InvalidAllocations` 查询？**  
   *要点*：子窗体 `BeforeUpdate` VBA 只拦截通过该子窗体输入/改价的错误（`V09` 实测可知），若管理员直接开基础表改数据、调低诊费 `AppointmentFee` 或调低 `ReceiptTotal`，唯有事后侦测查询能及时揪出失衡。

---

## 8. 成员 7（Windows + Access 必需）｜用户窗体、下拉与跨机点击官

- **依赖**：底库副本 + 成员 5 的 11 个查询（如调整 `CollectedByVetID` 需配合简化 8.2 下拉）。
- **交付**：`v2_R7_Forms.accdb`（`frm_00_MainMenu` + 3 主 3 子窗体）+ **`F01–F06` 实机点击记录**（**含在另一台 Windows/Access 电脑的 `F06` 记录**）。

### 8.1 三套主子窗体建设与常见点击坑点
1. 复制底库，导入成员 5 的 **11 个查询**，命名 `v2_R7_Forms.accdb`。
2. 依次用 **Create → Form Wizard（窗体向导）** 建 3 套主子窗体：先选主表全部显示字段 → 在上方 `Tables/Queries` 下拉切到子表选全部非自动外键或所需字段 → 下一步选“按主表查看” → 选 **`Form with subform(s)`（带子窗体的窗体）** + `Datasheet（数据表）` → 严格命名：
   - `frm_01_ParentAndPets`（主 `tblPetParent`，子窗体控件名建议 `sfrm_Pets` / `tblPet`，关联 `ParentID / ParentID`）
   - `frm_02_AppointmentAndRx`（主 `tblAppointment`，子窗体控件 `sfrm_PrescriptionLines` / `tblPrescriptionLine`，关联 `AppointmentID / AppointmentID`）
   - `frm_03_CashReceiptAndAlloc`（主 `tblCashReceipt`，子窗体控件 `sfrm_ReceiptAllocations` / `tblReceiptAllocation`，关联 `ReceiptID / ReceiptID`）
3. **最容易点错的边界提醒（必查！）**：向导完成后切进主窗体 **Design View**，用鼠标**点击子窗体灰色框的外边框线（Subform Control）**，再看右侧 Property Sheet → `Data` 页签：确认 **`Source Object`、`Link Master Fields`、`Link Child Fields`** 与上表一模一样（如果点到子窗体里面某个格子，是看不到这三项的！）。同时确认主子窗体 `Record Source` 都指向真实基础表，保证可更新。
4. 主键防篡改：主窗体 `AutoNumber` 文本框设 **`Locked = Yes`、`Tab Stop = No`**。在 `frm_01` 子窗体把 `ParentID` 设 `Locked = Yes`（配合 `Link Master/Child` 新增时自动继承当前主人，日常界面不自由改挂已有宠物归属，减轻 `T21` 风险）。若核销子窗体准备挂载 VBA，确保 `ReceiptID`、`AppointmentID`、`AppliedAmount` 三个绑定文本框即使隐藏也保留在子窗体上。

### 8.2 外键全改下拉框（Combo Box）防错
切到各窗体/子窗体 **Design View**，右键外键文本框 → **Change To → Combo Box（更改为组合框）**，打开 Property Sheet：
- `Control Source` = 原外键字段名（**绝不能留空！否则选完不保存！**）
- `Row Source Type` = `Table/Query`；`Bound Column` = `1`；`Column Count` = `2`；`Column Widths` = `0cm;7cm`；`Limit To List` = `Yes`
- 分别粘贴对应 `Row Source` SQL（如有问题找成员 5 协助）：

```sql
-- 1) frm_02 就诊的 PetID
SELECT PetID, CStr(PetID) & ' - ' & PetName & ' (Parent #' & ParentID & ')' AS DisplayName FROM tblPet ORDER BY PetName, PetID;
```
```sql
-- 2) frm_02 就诊的 VetID & frm_03 收款的 CollectedByVetID（若保留该列）
SELECT VetID, CStr(VetID) & ' - ' & VetName AS DisplayName FROM tblVeterinarian ORDER BY VetName, VetID;
```
```sql
-- 3) frm_02 子窗体开药的 MedicationID
SELECT MedicationID, CStr(MedicationID) & ' - ' & MedicationName & ' | List ' & Format(ListPrice,'0.00') AS DisplayName FROM tblMedication ORDER BY MedicationName, MedicationID;
```
```sql
-- 4) frm_03 收款的 ParentID
SELECT ParentID, CStr(ParentID) & ' - ' & ParentName & ' | ' & DayPhone AS DisplayName FROM tblPetParent ORDER BY ParentName, ParentID;
```
```sql
-- 5) frm_03 收款的 AccountID
SELECT AccountID, CStr(AccountID) & ' - ' & AccountName AS DisplayName FROM tblCashAccount ORDER BY AccountID;
```
```sql
-- 6) frm_03 子窗体核销的 AppointmentID
SELECT A.AppointmentID, 'Appt #' & A.AppointmentID & ' | ' & T.PetName & ' | Parent #' & T.ParentID AS DisplayName FROM tblAppointment AS A INNER JOIN tblPet AS T ON A.PetID=T.PetID ORDER BY A.AppointmentID;
```

> **边界提示**：基础版中 `AppointmentID` 下拉仅在名称旁显示 `Parent #` 供目视对照，**并非**自动级联筛选或事前阻断；实际成交单价 `UnitPriceCharged` 由录入人员参考目录价确认填写（若额外加自动带价事件，务必只初始化新增行且不覆盖已有旧行）。

### 8.3 建导航主页与按钮（认清嵌入式宏）
1. **Create → Blank Form → Design View** 保存为 `frm_00_MainMenu`，加入医院标题和分组按钮区域。
2. 用 **Command Button Wizard（命令按钮向导）** 放按钮（注意：**向导生成的按钮在 Property Sheet → Event → On Click 显示为 `[Embedded Macro]`**，因此无 VBA 并不代表“没有任何宏”，只采用安全的内置 `OpenForm / OpenReport / OpenQuery` 动作，**OpenQuery 只许连向 SELECT 查询**！）：
   - 3 个打开窗体按钮：`frm_01_ParentAndPets`、`frm_02_AppointmentAndRx`、`frm_03_CashReceiptAndAlloc`
   - 核心查询与审计入口：`qry_01_ParentPetCount`、`qry_04_AppointmentBalance`、`qry_05_ReceiptReconciliation`、`qry_Ctrl_InvalidAllocations`、`qry_Ctrl_DrugInteractionWarnings`
   - 报表入口（待成员 8 合并后指向）：`rpt_01_REA_Diagram`、`rpt_00_Relationships_Report`、`rpt_02_System_Design_Notes`
3. 按钮文字规范、不挡住数据显示区；明确区分“开单计费 (`frm_02`)”和“现金收款核销 (`frm_03`)”；**不要禁用/彻底隐藏左侧 Access 导航窗格（Navigation Pane）**，保留直接打开表/查询的备用通道以防他机禁止按钮运行；**绝不为消黄条去全局降低系统宏安全设置**。

### 8.4 真实界面点击验收（`F01–F06`，只留真实记录，SQL 不能代替 UI）
- **F01**：依次点按 `frm_00_MainMenu` 上每一个按钮，验证都能打开正确对象且不报缺失或弹出“输入参数值”（合并前后各点一次）。
- **F02**：在独立测试副本上通过窗体翻页确认子表随之更新；完整走一圈闭环：“`frm_01` 新增主人+宠物 → 关重开窗体再进 `frm_02` 为新宠录就诊开药 → 关重开进 `frm_03` 录收款并核销一部分”，确认主外键全部自动带正。
- **F03**：测出同名同姓下列表能凭 `ID / Phone` 辨认，主键值只读且底层保存为真实数字 ID。
- **F04**：新增主人或药品后提示先保存记录并关重开（或做并测试 `Requery`）可见新项；更改目录价确认历史处方窗体显示不变。
- **F05**：全关重开确认写入持久化，且对半填记录按 `Esc` 取消未保存编辑不留残缺记录。
- **F06（跨机实地验收，和成员 8 协作）**：把合并文件发到**另一台已装 Access、且文件所在文件夹不在“受信任位置”的 Windows 电脑**打开，真实记录黄条出现与否、点击每个按钮的实际结果（若被组织策略禁用如实记入交接并依赖左侧导航窗格入口，不谎称“所有电脑零问题”）。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅针对我在 MS Access 窗体与控件属性遇到的问题给出操作定位，不要把普通全表下拉说成已做跨主人自动过滤，也不要承诺换任何电脑都能零安全警告打开。

我在修改窗体 [写窗体或子窗体名] 时遇到问题：
- 当前涉及的表、外键、下拉 Row Source 与 Control Source：[粘贴]
- 子窗体的 Link Master / Link Child Fields 设置：[粘贴]
- 实际遇到的症状（如无法保存/不保存外键/选完显示数字/报参数错/下拉不刷新）：[描述]

请给出 Property Sheet 中英文精确检查项，区分 Control Source、Row Source 与 Link 字段，并提醒哪些更改会影响已测过的历史价格或需要补充哪项 F/V 测试。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **在 `frm_03` 把 `AccountID` 改成下拉框后，如果忘了设 `Control Source` 但设了 `Row Source`，界面上能下拉但实际发生了什么？**  
   *要点*：能看到账户名称列表也能选中，但因为未绑定到底层表字段，保存记录时 `tblCashReceipt.AccountID` 仍是空的（被必填规则拦下），等于白选。
2. **为什么我们在向导后一定要保留“主窗体翻页同步子表”和“用另一台电脑点按钮（F06）”的实测，而不能只看 SQL 测试全对就算窗体完成？**  
   *要点*：SQL 测试不检验窗体的主子关联字段 (`Link Master/Child`)、控件锁定、ComboBox 写回 ID，也不检验按钮向导的嵌入式宏在未经信任策略电脑上是否会被禁用。
3. **如果操作员刚在 `frm_01` 新增完一只新猫，马上切到旁边原本就开着的 `frm_02` 却在下拉里找不到这只猫，是因为没存进表里吗？**  
   *要点*：不是没存盘，而是旧窗体打开时缓存了当时的下拉列表未刷新（`Requery`）；保存主表后关闭重开 `frm_02`（或按 `Shift+F9` 刷新组合框）即可见到。

---

## 9. 成员 8（Windows + Access 必需）｜数据库文档化与总验收官

- **依赖**：成员 1 的 PNG、成员 2 字典、成员 3 合并稿、`D:\AIS` 后续补充到的 Lab 2 / Rubric。
- **交付**：`rpt_01_REA_Diagram`、`rpt_02_System_Design_Notes`、`rpt_00_Relationships_Report`、`Table_Definitions_Documenter.pdf`（组内归档备查）、`UAT_Signoff.md`。

### 9.1 库内自包含文档与报表（确保单文件可完整查看）
1. **`rpt_01_REA_Diagram`（绝对防断链！）**：
   - Create → Report Design → `Page Setup -> Landscape`（横向）；顶部加标题 Label：`UNNC Animal Hospital - Conceptual REA Diagram`。
   - Report Design → Insert Image 选成员 1 的 `REA_Diagram.png` 拉满主区域。
   - **铁律检查**：选中图片框 `Alt+Enter` → `Format` 页签：**`Picture Type` 必须为 `Embedded（嵌入）`**（严禁 `Linked`！），**`Size Mode` = `Zoom`**。Print Preview 确认 1 页清晰不裁边，保存 `rpt_01_REA_Diagram`。
2. **`rpt_02_System_Design_Notes`（系统设计与实测边界英文说明）**：
   - Create → Report Design，用大文本框/标签分段放严谨英文说明，覆盖 6 块内容：① 系统范围（已发生诊疗与收款对账、不包含未来预约）；② REA 映射（10 表、46 字段与 Crow's Foot 口径）；③ 收款假设（原型假设 `CollectedByVetID` 及依据 D3 定稿结果）；④ 计费、价格（ListPrice vs UnitPriceCharged vs LineCharge）与防笛卡尔积汇总；⑤ 样例说明（真实核实后的 D1 口径）；⑥ **实证已知局限（`T21` 宠物转主人历史、`T22` 跨表日期、表修改绕过子窗体事件、药物预警仅为事后侦测、缺字段修改审计日志）**。
   - **切记**：不要硬套 Assignment 1 的“5 个弱点占 20 分”说法。
3. **`rpt_00_Relationships_Report`**：先由你在己方副本调试排版，最后在 **成员 3 合并出的最终文件** 中再次打开 `Database Tools -> Relationships`，把 10 张表和别名排整齐（12 条 `1` / `∞` 连线清晰不交叠），点 **Relationship Report** 并调好页面横向与纸张宽，保存 `rpt_00_Relationships_Report`（这样报告左上角标题才与最终文件名完全一致）。
4. **运行官方 `Database Documenter`**：Database Tools → Database Documenter → `Tables` 页签点 `Select All` → `Options...` 勾全 Fields/Properties/Relationships → OK → Print Preview 导出 `Table_Definitions_Documenter.pdf` 供小组留底自查（若 Moodle 仅收 1 个 Access 文件，确保库内表 Design View 的全部 `Description` 和关系报表本身可被直接打开）。
5. **（可选）病历或账单报表**：如确认制作，以 `qry_06_PetMedicalHistory` 为源时按 **`PetID` 分组并在页眉显示 `PetName`**（绝不能按 `PetName` 分组以免同名宠物串单！）；账单统计以 **`qry_04_AppointmentBalance`** 为源，严禁从处方行表直接把基础诊费反复累加。

### 9.2 最终候选库 9 项放行核验（`U01–U09`，在只读/独立副本执行）
- [ ] **U01**：确认 **D1** 与 **D3** 已拍板并对照已获知的 Lab 2 / Rubric 要求（未获 Rubric 前明确标记哪几项是依当前指南、哪几项待核实）。
- [ ] **U02**：REA 图 ↔ 数据字典 (`Schema_Freeze`) ↔ 最终合并文件 10 表/46 字段/12 条参照完整性关系 100% 一致（若之前改过 D1/D3 必须同步全套文件与测试）。
- [ ] **U03**：逐表确认数据条数符合拍板方案、全字段 `Description` 非空、11 个查询双击全部正常出数无弹窗报错、金额对照成员 4 手算表零误差。
- [ ] **U04**：成员 6 的 `T01–T22` 全部核清（`T21/T22` 确已标 `KNOWN_LIMITATION` 未夸大），且若启用 VBA 或按钮已完成全部 `V/F` 实测（重点：不把侦测写成已阻止）。
- [ ] **U05**：**离线换路径实测**：把候选 `.accdb` 拷到**另一电脑或不含原 PNG 的全新文件夹**打开 `rpt_01_REA_Diagram`，确认图片清晰还在（真正嵌入未断链）。
- [ ] **U06**：记录两台电脑的 `F06` 按钮、关闭重开及安全性表现，有受限行为如实交接保留导航窗格。
- [ ] **U07**：核对即将上传的 `GroupNo_animalhospital.accdb` 未留有任何 `T/V/F` 测试脏数据，且已完成 `Compact and Repair`。
- [ ] **U08**：按 Moodle 页面真实规则确认**精准截止时间、单/多文件个数、组号替换方式 (`GroupNo_animalhospital`)**；检查电子封面/声明页若含类似 [Session 1 Slide 21](<D:/AIS/Course_Labs/originals/Session%201%20-%20Lab%20slides%20[BUSI2111].pdf>) 的 **`Academic Honesty and AI`** 勾选栏，务必据本组真实工具与用途如实填报（不漏勾、不伪造“未使用”；可先运行 `python -X utf8 handoff_logs/query_logs.py --sql "SELECT * FROM v_ai_coversheet_ledger;"` 核对全组 AI 台账）。
- [ ] **U09**：由指定提交人在 **2026-11-27 12:00 前**（留足缓冲）上传 Moodle，**立即从 Moodle 下载回自己电脑重开核验**并截图回执。

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅依据我以下提供的实际实现、测试日志与已核实限制，撰写准备嵌入 Access 报表 `rpt_02_System_Design_Notes` 的英文系统说明，不要自创“Rubric 占比”或宣称“所有测试均已无缺陷通过”。

[在此粘贴：1) D1/D3 最终拍板口径；2) 02 第二/六节结构与样例摘要；3) 成员 6/7/8 实际完成与未测范围（含 T21/T22 及仅在单机测试还是已跨机实测 `F06`）]

请分段写一篇约 300-360 词、学术商业规范的英文说明，必须涵盖：
1. System Scope & REA-to-Schema Alignment（说明 10 表、CashAccount 与若存在的 CollectedByVetID 原型假设）；
2. Sample Data Scope & Pricing Separation（解释目录价、开药实收单价、行小计与当前样例数依据）；
3. Preventive vs. Detective Controls（准确区分表规则阻断、查询事后发现、及若未启用 VBA 时的实际拦截边界）；
4. Verified System Limitations（如实列出 T21 宠物转主人无历史、T22 跨表日期未阻断、直接改表风险与药物提醒仅事后显示，不虚夸）。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **如果把 `rpt_01_REA_Diagram` 里图片的属性误留成 `Linked`，在本机测明明正常显示，为什么交上去老师可能看到一片空白？**  
   *要点*：`Linked` 只在文件内保存成员 8 电脑硬盘上的路径字符串（例如 `C:\Users\...\REA.png`），文件一传到 Moodle 在老师电脑打开就找不到源图；只有改成 `Embedded` 并在不含原图的文件夹/另一台机器离线打开验证（`U05`），才证明真正打包进 `.accdb`。
2. **如果可选病历报表按 `PetName` 而不是 `PetID` 分组，在有同名同姓宠物时会出现什么严重事故？**  
   *要点*：会把两只恰好都叫 “Mochi” 的不同主人宠物病历、诊断、体重和开药记录混到同一页甚至同一个账单里，造成严重医疗档案混乱与对账错误。
3. **交接终审时，成员 6 发来一份“65 项全 `PASS`”的自动化结果或全部自己手测 `PASS`，你能仅凭这句就批准提交吗？**  
   *要点*：不能；还要核查窗体 (`F01–F06`) 与报表是否在集成后的最终库实机点击过、另一台机表现如何、已知限制 (`T21/T22`) 是否被错写为已阻止、提交库中是否清净无脏数据，以及 D1/D2/D4 是否均已核实。

---

## 10. 遇到问题的标准化求助交接格式

发群或私发协助人时直接复制以下模板，不要只发“报错了/打不开”：

```text
【求助卡】文件名与版本（例如 v2_R7_Forms.accdb）：
Access 版本 / Windows 环境（是否在我自己桌面或 OneDrive 盘？）：
当前所在对象名 & 第几步操作：
输入测试数据（虚构样例ID即可）：
原本期望发生什么：
实际发生了什么 & Access 报错框全文（原字抄下或截图）：
如果在全新的干净底库副本重做这一步，是否必现：
刚刚顺手改过什么：
截图/日志保存路径：
```
