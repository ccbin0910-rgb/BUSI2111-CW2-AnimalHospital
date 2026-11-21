# 成员 3｜Access 合并核验清单

**成员 3 亲自操作最终合库，成员 8 准备报表并负责跨机终验，成员 7 同步复核最终候选库的结构和关系。** 成员 5 的查询批次已在 Access 试合并并通过复验。正式合库和终验当前为 `NOT_RUN`。

## 分工与交接顺序

| 阶段 | 负责人 | 交付和交接条件 |
|---|---|---|
| 现在可并行 | 成员 7 | 使用[第三轮交接指定的底库和工作簿](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/752bd681616082f256a6a2e758aade41c0e83727/workspaces/R3_CoreAndMerge/M7_ROUND3_HANDOFF.md)，完成 46 字段独立盲测和主外键、12 条关系审计。回执给成员 3，并同步成员 8。 |
| 现在可并行 | 成员 8 | 在自己的 Access 副本制作嵌入式 REA 图和设计说明报表，预排关系报表并导出组内留底的表定义 PDF。将报表库、对象名和依赖、预览与嵌入检查结果交成员 3。可先用成员 5 的查询库准备报表。 |
| 报表交回后 | 成员 3 | 核对报表交付，使用固定版本底库创建工作稿并亲自执行下方合库步骤。发布同一份候选库及其 SHA256，交成员 7、8 验收。 |
| 候选库发布后 | 成员 7、8 | 成员 7 复核候选库的主外键、关系方向及结构，核对受改动影响的测试。成员 8 汇总成员 6、7 的三轮记录，检查查询、字段说明、报表和样例，在另一台 Windows 电脑上离线重开并写 `UAT_Signoff.md`。 |
| 终验通过后 | 成员 3、指定提交人 | 成员 3 处理差异并定稿。若候选库改动，发布新摘要并复测受影响项。指定提交人核对 Moodle 上传规则，提交后下载重开核验。 |

成员 8 的报表工作和成员 7 的独立测试可以同时开始。最终签收以三轮测试记录齐备、问题处理完成和同一候选库的实测结果为准。成员 6 的 T21/T22 按已知局限记录，其余场景按回执注明引擎或界面实测范围。

成员 8 把报表库 `v2_R8_Reports.accdb`、表定义 PDF 和交付说明放入 `workspaces/R8_Reports_UAT/`。交付说明列出输入提交、报表名称、数据源及预览结果。报表交付与候选库签收分别追加 SQL 日志，经本人确认后推送到 `role/M8-reports`，把相应的固定链接交给成员 3。

## 接收交付

- [ ] 成员 3 记录正式底库文件名、提交版本、关库后的 SHA256、按表分列的样例行数与 ID 对照。接收方在创建工作副本时保存其来源底库的 SHA256。交回的副本另记自身 SHA256，因为加查询、报表等操作会改变文件内容。来源不明时先确认版本，再导入。
- [ ] 成员 4 的 `Seed`、`Expected` 与正式底库对照完成后，保留各表按主键排序的完整行值作为合并前后比较依据。D1 的行数口径为药品表 3 条、相互作用表 2 条、其余八表各 2 条。行数相同仍需核对 ID、日期、FK 和金额等内容。
- [ ] 记下每个来源文件的负责人、文件名、SHA256、要导入的准确对象名和依赖。成员 6 提供 Round 1–2 与控制测试记录，成员 7 提供独立 Round 3 和关系方向审核记录。两份记录用于最终验收。

| 来源 | 合并范围 | 合并前核对 |
|---|---|---|
| 成员 5 `v2_R5_Queries.accdb` | `Queries` 页签内冻结的 11 个核心和控制查询 | 对照 [02 §7](../../02_最终版数据库架构蓝图与技术规范.md) 核对全部名称，先确认查询依赖，再打开检查参数提示、列名和手算结果。 |
| 成员 7 `v2_R7_Forms.accdb`，可选 | `Forms` 页签内经批准且完成 F01–F06 的主窗体及其子窗体 | 检查 `Record Source`、`Row Source`、子窗体链接字段和按钮引用。未采用窗体时，启动窗体属性保持空白。 |
| 成员 8 `v2_R8_Reports.accdb` | `Reports` 页签内 `rpt_01_REA_Diagram`、`rpt_02_System_Design_Notes` | 检查报表和子报表依赖、查询字段名及 REA 图的 `Picture Type = Embedded`。`rpt_00_Relationships_Report` 以最终候选库关系窗口重新生成并核对。 |

## 合并与复验

1. **保存恢复点。** 关闭来源文件，将正式底库复制到 `workspaces/R3_CoreAndMerge/` 下的合并工作稿。在工作稿导入前读取正式底库摘要和样例、结构基线。每个来源文件也先复制一份，导入时选择副本。Access 打开来源时可能改写文件字节。把工作稿和来源副本置于本地独立目录，避免多人同时编辑。
2. **按依赖导入。** 在工作稿选择 **External Data → New Data Source → From Database → Access → Import**，依次导入查询、已验收的可选窗体、报表。逐批只勾上表列出的对象。基础版保持 `Tables`、关系、其他设置、宏、模块未选中。若团队已采用并验收依赖 VBA 的可选窗体，按 03 §4.3 在 Modules 页签仅选该窗体所需且已核对的模块。导入后在合并副本按 Alt+F11 → Debug → Compile，重跑 F01–F06；如有编译错误，记录缺失依赖并回退该批导入。每批导入后检查对象名、数量和依赖。出现 `qry_…1` 等同名后缀或意外对象时，恢复导入前备份，核对清单与现有对象后重试。
3. **对照结构与数据。** 合并后逐项核对 10 张表及 46 字段、字段属性与 `Description`、7 个单列主键、3 组联合主键、12 条从 PK 到 FK 的 `1 → ∞` 关系、参照完整性及无级联。按主键比对每张表的完整记录与底库基线，确认没有测试脏数据、同名表或外部链接表。候选库增加对象后文件摘要会变化，用结构与数据对照证明底库内容完整。
4. **验证对象。** 逐个打开 11 个查询，检查无意外参数提示、字段与结果均符合成员 4 的独立预期。启用可选窗体时重测主子窗体及相关按钮。确认真实组号并给候选库使用对应的 `GroupNo_animalhospital.accdb` 文件名后，由成员 3 从该库的关系窗口核对 12 条线及方向，保存布局，生成并预览 `rpt_00_Relationships_Report`。打开两份导入报表，检查依赖与图像。
5. **压缩并重开。** 备份后执行 **Database Tools → Compact and Repair Database**，关库重开复核结构、样例、查询和报表。关库后记录候选文件 SHA256、来源提交和已导入对象，发同一个固定版本给成员 7 和 8。成员 7、8 按 [03 §9.2](../../03_八人傻瓜式分工SOP与AI_Prompt手册.md) 在独立副本完成 U01–U07，其中 U05 在另一台 Windows 的新目录离线打开 REA 图。提交人按 U08–U09 核实 Moodle 要求并在上传后下载重开。

## 当前证据

- 成员 3 从固定提交 `810b603` 取正式底库。其 SHA256 为 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`。核验样例用同一提交的工作簿。[正式底库与工作簿入口](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13/workspaces/R3_CoreAndMerge/M5_QUERY_HANDOFF.md)
- 成员 5 的 `efc7eb7` 提供正式查询来源，11 个查询已在原交付和成员 3 的试合并副本中复验一致。[成员 5 查询交付](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/tree/efc7eb7a6f71248e2970c033b198d97866cabac7/workspaces/R5_Queries)
- 成员 8 从成员 1 的固定提交取 REA 图。[成员 1 的 REA 图与假设](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/tree/7fb4ebbeeee6ab7859e0c546d2b82ef2ab7d6127/workspaces/R1_REA)
- 成员 6 已交付前两轮，成员 7 已交第三轮。成员 3 补测的 19 项已在关库后读回核对，之后五轮 DAO 复测共 135 项符合预期。当前等待成员 8 的报表库。[成员 6 回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/cf861c3613926c0fd5f86bcd14ae28aa5b8210b4/workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md) · [成员 7 回执](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/255ecede794f65edfb76e513b47366a1c2994ff6/workspaces/R7_Forms/Round3_Audit_Log.md) · [成员 3 补测](M3_Round3_Supplement.md)
