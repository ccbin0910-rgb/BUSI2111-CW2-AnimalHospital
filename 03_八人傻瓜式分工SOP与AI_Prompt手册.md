# 八人分工 SOP 与 AI 辅助手册（傻瓜式操作 + 自检版）

> **版本：2026-11-16 R4（Rubric 4×25 保分优先重构版）**（已校准至《Grading Rubrics》4×25、《Computer Lab 2》14 页与 [05 AI 思考约束边界](05_AI思考约束边界_课程对齐Prompt.md)）。  
> **核心策略调整**：官方 Rubric **4 项满分全在表/字段规则与三轮越界录入测试、主外键、12 条关系方向与 REA 完整性**，未单独给复杂窗体或 VBA 计分。因此全组 **100% 先保四大核心大项零漏项**，默认 **不上 VBA**，**轻量无宏窗体降为核心全部通过后的可选体验补充**！  
> **使用铁律**：① 设备预设 **2 Mac + 6 Windows**，**10 表 / 46 字段英文命名以 [02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 为唯一标准**；② 每次求助外部 AI 前先看 [05 约束边界](05_AI思考约束边界_课程对齐Prompt.md)；③ **所有字段拦截、关系方向、查询结果与测试结论必须亲手运行真实 Access 核实**。

---

## 0. 一页交接总览表（紧扣 Rubric 4×25 保分）

| 成员 | 对应 Rubric 得分线 | 上游收到什么 | 本人要做什么 / 交出什么 | 硬性验收怎么看 | 卡住找谁 |
|---|---|---|---|---|---|
| **成员 1** (Mac 友好) | **Completeness (25)** | 官方指南 + 02 第 1/2 节 | `REA_Diagram.png` + 可编辑源文件 + `REA_Assumptions.md` | 用 `\|, O, <` 与 `▶` 画全 7 实体（含 `CashAccount` 对齐 Lab 2） | 成员 2、组长 |
| **成员 2** (Mac 友好) | **Completeness + Functionality + PK/FK (75)** | 02 第 3–5 节 + 1 的 REA 图 | `Schema_Freeze.xlsx`（10 表/46 字段规则/`12 关系`/`Handout_normalization` Schema） | 与成员 3 建好的 Access 表 46 个字段逐列属性比对零差异 | 成员 1、3 |
| **成员 3** (Win/Access) | **全部 4×25 (100) 技术底座** | 冻结口径 + 4 的样例表 | **Phase 2** `v1_Core_Seeded.accdb`；**Phase 4** 合并终版 `GroupXX_animalhospital.accdb` | 10 表/46 字段全规则/3 组联合 PK/12 条 `1→∞` RI 关系准确；合并绝不导 Tables | 成员 2、8 |
| **成员 4** (Mac 友好) | **Completeness + Functionality (50)** | 02 第 4–6 节 | `Sample_Data_Master.xlsx`（`Seed` / `Expected` / **`46字段×3轮越界压测矩阵`** / `Tests`） | 独立手算 205/90 与余额 0/90；46 字段每列至少 1 个违规测试值分配至 Round 1–3 | 成员 2、6 |
| **成员 5** (Win/Access) | **Completeness (25，Page 3 衍生值)** | 成员 3 的 `v1_Core_Seeded.accdb` | `v2_R5_Queries.accdb`（顺序建齐 11 个核心与控制查询） | 双击全跑无“输入参数值”，金额行数与成员 4 手算零误差 | 成员 3、4 |
| **成员 6** (Win/Access) | **Functionality "3 Rounds" (25)** | 底库副本 + 4 压测矩阵 + 5 查询 | `Control_Test_Log_R1R2.md`（执行 **Round 1–2 表录入压测 + T01–T22**） | 逐表直接在 Datasheet 录坏数据确认全拦截；异常查询准确暴露跨主人/超额；T21/T22 标 `KNOWN_LIMITATION` | 成员 4、5 |
| **成员 7** (Win/Access) | **Functionality Round 3 + PK/FK + Relationships (75)** | 底库副本 + 4 矩阵 + 6 的 R1–R2 记录 | **【P0】`Round3_Audit_Log.md`**（盲测第 3 轮全字段非法录入 + **逐一核验 PK/复合PK/FK 与 12 关系 `1→∞` 方向**）；**【P1 可选】**核心全过后建无 VBA 轻量录入窗体 `v2_R7_Forms.accdb` | 必须交出 46 字段 Round 3 盲测全阻断、12 条关系方向零反向的独立签收单；不强求复杂菜单或 VBA | 成员 3、8 |
| **成员 8** (Win/Access) | **Guide 文档化 + 4×25 终审** | 1 的图、2 字典、5 查询、6/7 测试单、3 合并库 | `rpt_01_REA_Diagram`、`rpt_02_System_Design_Notes`、`rpt_00_Relationships_Report`、`Database Documenter PDF`、`UAT_Signoff.md` | 46 字段 `Description` 全满；离线换路径打开嵌图无断链；核对 `GroupNo` 与 AI 封面声明 | 组长、3 |

> **协作补位原则**：成员 6 与成员 7 形成**相互独立的双人三轮压测闭环**（完全对应 Rubric *"After three rounds of data entry tests..."* 条款）；成员 8 协助成员 3 做 Phase 4 合并、关系排版与跨机重开校验。

---

## 1. 全组开工前的 7 条共同铁律

1. **先过 D1 与 D3 门槛（目标 `11-19` 前）**：`Grading Rubrics` (4×25) 与 `Computer Lab 2` (14 页) **已确认**：不考复杂窗体/VBA，核心考 REA、10 表、46 字段三轮录入拦截、PK/FK 与 12 关系方向；全组仅剩 **D1（2 条 vs 3 药）** 与 **D3（`CollectedByVetID` 必填假设）** 待 11-19 前由组长问老师/拍板。
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

## 5. 成员 4（Mac 友好）｜测试数据、独立手算 & 46 字段三轮压测矩阵师

- **依赖**：[02 蓝图](02_最终版数据库架构蓝图与技术规范.md) 第四至六节 + 03 第 7 节测试清单。
- **交付**：`Sample_Data_Master.xlsx`（或 CSV/Markdown），含 **`Seed`（录入底数）**、**`Expected`（手算预期）**、**`Field_3Rounds_Matrix`（46 字段 × 3 轮非法录入矩阵 — 支撑 Rubric Functionality 25 分！）**、**`Tests`（T07–T20 隔离场景）** 四页。

### 傻瓜式操作步骤
1. **`Seed` 页**：按 02 第六节录入顺序列出全部 10 张表的虚拟数据行，醒目标注 **“开发验证集：药品 3 条、其余 9 表各 2 条；D1 提交合规待组长 11-19 确认，不擅自加造 ConditionCode”**。
2. **`Expected` 页（独立算一遍，不抄蓝图结论！）**：自己拿计算器按原始单行重新汇总核验：
   - **主人宠物数**：Emily (`Parent 1`) 名下 `Mochi`、`Boba` 共 `2` 只；David (`Parent 2`) 无宠物 = **`0`**；
   - **处方与诊费**：`Appt 1` 开 `Med 1` (`2 × 30.00 = 60.00`，目录价 `35.00`) 与 `Med 2` (`1 × 25.00 = 25.00`，目录价 `25.00`) → 药费 **`85.00`** + 诊费 `120.00` = 就诊总额 **`205.00`**；`Appt 2` 无药费 (`0.00`) + 诊费 `90.00` = 总额 **`90.00`**；
   - **收款与余额**：`R1 (100.00) + R2 (105.00) = 205.00` 全部分配给 `Appt 1` → `Appt 1` 余额 **`0.00`**，`Appt 2` 未收款余额 **`90.00`**；两笔收款未分配余额均为 **`0.00`**；
   - **异常基准**：`InvalidAllocations = 0 行`；`DrugInteractionWarnings = 1 行`（命中 `Appt 1` 的 `(1, 2)` 虚构温和冲突）。
3. **`Field_3Rounds_Matrix` 页（紧扣 Rubric "three rounds of data entry tests"）**：按 02 第四节全部 **10 张表、46 个字段**逐行建表，给**每一个字段**写出 **3 轮不同非法输入测试值**（分配给成员 6 测 Round 1–2、成员 7 盲测 Round 3），覆盖：
   - **必填短文本**：Round 1 留空；Round 2 输空字符串 `""`（测 `Allow Zero Length=No`）；Round 3 输超长字符串（测 Size 截断/限制）；
   - **数字字段**：Round 1 输负数/0；Round 2 输字母 `"abc"` 或小数 `1.5`（测 `Double+Int()`）；Round 3 输超上界（如 `1441` 分钟）；
   - **货币字段**：Round 1 输负值/0（适用处）；Round 2 输文本 `"$abc"`；Round 3 输 `100.001`（测 `Round(...,2)`）；
   - **日期与外键**：Round 1 输文本 `"Pickle"`（Lab 2 原例！）；Round 2 输未来日期 `2099-01-01`（适用处）；Round 3 输不存在的外键 `999` 或重复主键！
4. **`Tests` 页**：为成员 6 写清 `T07–T20` 每个隔离异常场景的 4 要素：**① 初始基线 → ② 唯一变更 → ③ 预期返回行与类型 → ④ 测完恢复步骤**（绝不把两个异常混在一个副本）。
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

## 7. 成员 6（Windows + Access 必需）｜表级 Round 1–2 压测与内控测试官（Functionality 25 主力）

> **R4 角色聚焦**：直接对应 Rubric **`Functionality and Reliability (25)`**（*"After three rounds of data entry tests, some fields can be entered with data outside the rules"*）。你负责**直接打开每张表（Datasheet View）执行第 1–2 轮 46 字段越界录入测试**与 **`T01–T22` 完整性/对账异常测试**；**无需做 `V01–V09` VBA 测试**（R4 已停用默认 VBA）。

- **依赖**：底库副本 + 成员 4 的 `Field_3Rounds_Matrix` 与预期 + 成员 5 的 11 个查询（若 D3 改动 `CollectedByVetID`，`T20` 同步调）。
- **交付**：`Control_Test_Log_R1R2.md`（含 46 字段 R1/R2 勾选结果 + `T01–T22` 逐条日志）+ 隔离 `_Test.accdb` 副本（**严禁把测试副本交成员 3 合并！**）。

### 傻瓜式操作步骤
1. 复制成员 3 底库为 `v2_R6_Control_Test.accdb`，用 `External Data -> Import` 导入成员 5 的 **11 个 Queries**（不要导 Tables），核对基线无误后再另存一份 `Clean_Baseline.accdb`。
2. **执行 Round 1 & Round 2 全表 46 字段 Datasheet 录入压测**：逐个双击打开 10 张表，照成员 4 的 `Field_3Rounds_Matrix`，依次在**新行中**尝试把 Round 1 和 Round 2 坏数据直接打进格子并按 `Tab/Enter`（每次报错拦截后按 **`Esc` 撤回该未保存行**），逐个打勾确认 **46 个字段 0 漏网**！若发现任何字段竟然被允许存进去（例如 `""` 空串、小数 `1.5`、错用 `TODAY()` 漏检），**立刻写求助卡退回成员 3 修复再重测**！
3. 逐项跑完下方 **22 项完整性与对账场景（`T01–T22`）**。**原则**：先写预期再改数；**涉及增删改的 `T07–T17`、`T21–T22` 每次只用一个干净副本单测**；只能填亲眼所见，未测标 `NOT RUN`。
4. **严格区分 3 种结论标签（对齐 `05` 规则 4 & 5）**：
   - `T01–T06, T12, T18–T20`：验证**表约束 / 参照完整性 / 主键（Preventive）**能否直接拦截；
   - `T07–T11, T13–T17`：验证**账务核算与侦测查询（Detective）**能否正确发现异常；
   - **`T21–T22`：确认已知未实现边界**——**必须标为 `KNOWN_LIMITATION`**，**绝不能**谎称“系统已阻止”。

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

4. **把未拦截/漏项与 Round 1–2 全表字段矩阵交接给成员 7**：通知成员 7 在完全独立的另一台电脑上用干净副本执行 **Round 3 盲测**。*(注：若全组未来极少数情况决定额外启用 `02` 第八节备选 VBA，才需补跑可选 V 系列测试，当前 R4 默认停用 VBA)*。

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

## 8. 成员 7（Windows + Access 必需）｜Round 3 盲测、PK/FK & 关系方向审计官（附可选轻量窗体）

> **R4 核心重排**：按照官方 Rubric 4×25，**PK/FK (25 分) + Relationships (25 分) + Functionality Round 3 占绝对权重**！你的 **【P0 必做】** 是在独立 Windows 电脑亲自审计全部主键、外键、12 条关系方向与第 3 轮 46 字段坏数据拦截，确保那 75 分一块都不掉；**【P1 可选】** 只有当 P0 全数 `PASS` 且仍有时间时，才用 Form Wizard 做不带 VBA 的极简录入窗体！

- **依赖**：成员 3 的 `v1_Core_Seeded.accdb` + 成员 4 的 `Field_3Rounds_Matrix` + 成员 6 的 Round 1–2 日志。
- **交付**：
  1. **【P0 必交】`Round3_And_Relationship_Audit.md`**（46 字段第 3 轮独立盲测日志 + 10 表 PK/FK/12 关系方向逐条签收表）；
  2. **【P1 可选】** 若团队需要简化界面才交 `v2_R7_Forms.accdb`（3 套轻量无 VBA 窗体 + `F01–F06` 实机点击记录）。

### 8.1 【P0 必做】PK / FK（25 分）与 12 条关系方向（25 分）逐表盲审
打开一份独立复制的 **`v1_Core_Seeded_R7Audit.accdb`**：
1. **逐表进 Design View 核验 PK & 联合主键 & FK（保 25 分）**：
   - 检查 7 张单主键表钥匙图标位置无错位，Data Type 为 `AutoNumber`；
   - **重点抽查 3 张联合主键表**：`tblPrescriptionLine` (`AppointmentID` + `MedicationID`)、`tblReceiptAllocation` (`ReceiptID` + `AppointmentID`)、`tblMedicationInteraction` (`MedicationAID` + `MedicationBID`) —— **两行左侧都必须有钥匙图标**！若只看到一把钥匙，立刻通知成员 3 重建！
   - 核对所有 12 个外键字段数据类型全部是 `Number -> Long Integer`（才能与 `AutoNumber` 连起），且 `Required` 属性与 02 蓝图完全一致。
2. **逐线核验 `Database Tools -> Relationships`（保 25 分：`all in the right direction`）**：
   - 检查 10 张表 + 别名框全部显示完整（拉高小窗格，**不要把任何字段遮到滚动条下面看不到！**）；
   - 数清共 **12 条线**，逐条双击连线本身看 `Edit Relationships` 弹窗：
     - Left Table (`Table/Query`) 必须是 **“1”方（主表 PK）**，Right Table (`Related Table/Query`) 必须是 **“∞”方（子表 FK）** —— 重点防反：`tblVeterinarian (1) -> tblAppointment (∞)`、`tblCashAccount (1) -> tblCashReceipt (∞)`、`tblPetParent (1) -> tblPet (∞)`、`tblPetParent (1) -> tblCashReceipt (∞)`；
     - 每条线两端必须看得见 **`1` 和 `∞`**（代表已勾选 `Enforce Referential Integrity`），且 **`Cascade Delete Related Records` 全部不勾**。

### 8.2 【P0 必做】Round 3 独立 46 字段越界盲测（保 Functionality 25 分）
在同一隔离副本（测完不回传脏数据！）按成员 4 矩阵的 **Round 3** 列，独立测试老师最爱试的坏数据：
1. 在所有文本表输入超出 `Field Size` 或空字符串 `""`；
2. 在所有日期字段输入 `"Pickle"` 非法文本与 `2099-01-01` 未来日期；
3. 在所有 `Currency` 字段输入 `100.001`（三位小数）与文本字符；
4. 在 `Quantity / DurationMin` 输 `1.5`、`1441`；在各外键列直接填 `999`；
5. 记录结果并确认 **46 字段 100% 拒绝违规数据**（如发现任何一条能存进去，立即贴求助卡通知成员 3 修复并让成员 6+7 一起复测！）。

### 8.3 【P1 可选 · 仅核心全过后考虑】极简无 VBA 窗体（不计入 Rubric 4×25）
如果 P0 审计全部零失误、成员 5 查询也已完成、且团队仍希望为“Dr. Nottingham 非 IT 背景”提供更友好的操作界面：
1. 复制**成员 3 确认后的干净底库**改名为 `v2_R7_Forms.accdb`，用 **Create → Form Wizard（窗体向导）** 仅生成 3 个无 VBA 基础主子窗体：`frm_01_ParentAndPets`、`frm_02_AppointmentAndRx`、`frm_03_CashReceiptAndAlloc`（如要做导航可建简版 `frm_00_MainMenu`，向导按钮产生的 `[Embedded Macro]` 仅允许 `OpenForm / OpenQuery (SELECT) / OpenReport`）。
2. **两个必查细节**：① 设计视图点**子窗体边框外框**查 `Source Object / Link Master / Link Child Fields` 正确；② 外键改成 ComboBox 时 `Control Source` 必须绑回原外键列名、`Bound Column=1`、`Limit To List=Yes`，下拉里拼上 `ID + Name/Phone`（区分重名）。
3. 若制作了任何窗体或按钮，**必须补测 `F01–F06`（含与成员 8 在另一台不放白名单的 Windows 电脑打开测试按钮与导航窗格）**，否则不要把未经实测的窗体并入最终交付！

### AI Prompt
```text
请先遵守《05 AI 思考约束边界》：仅协助我核查 10 表/46 字段/PK-FK/12 关系方向或排查简化无 VBA 窗体的原生属性；不要建议引入 BeforeUpdate VBA，也不要仅凭静态设计声称“已通过三轮测试”。

我正在执行《Assignment 2》Rubric 核心审计（Round 3 + PK/FK + 12 关系方向）：
- 我当前检查的表/关系/字段属性截图文字：[粘贴]
- 我在 Round 3 直接向 Datasheet 输入 [填测试值] 时 Access 的真实表现（是报错拒绝、静默四舍五入、还是居然保存成功？）：[描述]

请告诉我：
1. 根据 Rubric Functionality (25) / PK&FK (25) / Relationships (25) 标准，这是否算失分隐患；
2. 应当建议成员 3 在 Table Design 或 Relationships 窗口修改哪个具体属性（包括英文与中文 Access 选项名）；
3. 改完后我需要复核哪几项避免连带影响。
```

### 交接前 3 个自检问题（对应 `05` 规则 6）
1. **在 `Relationships` 窗口里，如果你看见一条连线没有显示 `1` 和 `∞`，即使字段名都连上了，Rubric 的 Relationships (25 分) 会面临什么风险？**  
   *要点*：没有 `1` 和 `∞` 说明未勾选 `Enforce Referential Integrity`，既未发挥参照完整性拦截垃圾外键，也可能被评阅者认为关系未有效建立或无法直观看出 `1→∞` 正确方向。
2. **为什么我们把 `tblPrescriptionLine` 等 3 张桥接表设为双列联合主键，如果误把其中一列设成单主键会坏在哪里？**  
   *要点*：若 `tblPrescriptionLine` 只设 `AppointmentID` 为主键，同一次就诊只能开 1 种药（第 2 种药立即报主键冲突）；同时设两列联合主键才能既允许一诊多药，又防止同诊同药重复插两行。
3. **如果你做了可选窗体但时间不够没在另一台电脑做 `F06`，或者发现跨机禁用了向导按钮宏，交接时应该怎么处理？**  
   *要点*：未测实写 `NOT RUN`；若只是想靠它加分体验却来不及完整验收，宁可暂不放进最终提交库（或保留左侧导航窗格直接打开表/查询/报表并如实写清边界），绝不能拿未经跨机检验的界面冒充稳定。

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
- [ ] **U01**：确认 **D1** 与 **D3** 已拍板，且全库 100% 对标已获取的官方 **Grading Rubrics（4×25）** 与 **Computer Lab 2** 规范。
- [ ] **U02**：REA 图 ↔ 数据字典 (`Schema_Freeze`) ↔ 最终合并文件 10 表/46 字段/全 PK-复合PK-FK/12 条 `1→∞` 参照完整性关系完全一致（已通过成员 7 的 8.1 独立方向审计）。
- [ ] **U03**：逐表确认数据条数符合拍板方案、46 个字段 `Description` 全非空、11 个查询双击正常出数（支撑 Completeness Page 3 衍生指标）、金额与成员 4 零误差。
- [ ] **U04**：确认成员 6（Round 1–2 + `T01–T22`）与成员 7（Round 3 盲测）**三轮 46 字段越界录入全部拦截**（`T21/T22` 标 `KNOWN_LIMITATION` 未夸大）；若有可选无 VBA 窗体则确认已测 `F01–F06`，否则确认已从纯净合并稿剔除未测半成品。
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
3. **交接终审时，成员 6 发来一份“65 项全 `PASS`”的自动化结果或 R1–R2 测试通过，你能仅凭这句就批准提交吗？**  
   *要点*：不能；官方 Rubric 要求 **三轮数据录入测试 + 全部关系方向正确 + 表定义文档化**，必须看到成员 7 独立完成的 **Round 3 盲测与 12 条关系方向审计**、你自己的 **`rpt_01` 离线嵌图实测（`U05`）**、**46 字段 Description & Relationship Report**、以及无测试脏数据的干净压缩版（`U07`）才能放行。

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
