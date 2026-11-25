# M8 接单与合库预检回执

日期 2026-11-22。按 M1 `7922f90` 接手 Windows Access 合库，工作位置为 `role/M8-reports` 的 `workspaces/R8_Reports_UAT/`。本回执保存在本地，待成员确认后发布。

- 固定输入为 M3 `810b603` 正式底库、M5 `efc7eb7` 查询库、M8 `785f490` 报表库。导入前原件摘要与交接记录一致。Access 访问本地报表来源时改写了文件字节，已从固定提交恢复本地来源，保留访问后的临时副本。
- 从底库复制工作稿，导入 11 个查询及两份报表，使用 Access 原生关系窗口生成 `rpt_00_Relationships_Report`。DAO 压缩到独立预检库后重开，全量样例、字段名、类型、大小、属性、Required、Description、主键及关系端点/属性与底库一致。10 表、46 字段、21 条样例、12 条关系，11 个查询成功运行。
- Access 重开导出三份报表预览。REA 图 `PictureType=0`（Embedded），`SizeMode=3`（Zoom）。两份 M8 报表各 1 页。关系报表原生布局起初分页，调整报表控件比例后为 1 页 A4 横向，10 张表和药品自反关系别名可见。个别长表名、字段名仍被表框截短，且标题使用工作稿名称。正式命名后需重出或更新标题并复查布局。
- 当前工作稿 `M8_Integrated_Precheck.accdb`，关库 SHA-256 `C530D8C2F812E87AF6BCCE7C27BF0948F49C8A799022E51B99428A4570AA3A3E`。该摘要仅用于本地预检版本。
- 正式组号与币种标签待确认。历史 Documenter 仍保留，正式候选库的原生 Documenter 导出待执行。上一次曾出现 Property not found / Disabled Mode。待正式版本命名、版面复核与关库哈希完成后，由 M7 对同一 SHA-256 做结构与跨机复验，再汇总 U01–U07。T21、T22 保留 KNOWN_LIMITATION。

## 正式命名副本 · 2026-11-22

成员 8 提供 Moodle 核对结果，正式组号为 3；币种标签按成员 4 样例约定采用 CNY。金额及样例原值沿用底库。已从预检稿另建 Group3_animalhospital.accdb，更新关系报表标题，压缩并重开。关库 SHA-256 为 AF22A4B58809B5C29EB51993DA368F9EFB4930723F6A8DEBB4459AC231E2DD28。

复核 10 张表、46 个非空字段说明、21 条样例、12 条无级联且启用参照完整性的关系及 11 个查询。三份报表各成功导出一页预览，关系报表为 A4 横向，正式标题可见；部分长标签仍被截短。REA 图确认 Embedded 和 Zoom。此为本机候选版，仍待新版原生 Documenter、报表长标签调整及 M7 跨机复验。版面若再修改，应重新关库并生成 SHA-256，交 M7 核对同一版。

## 关系报表修订 · 2026-11-22

基于已交付的 2503c06 制作独立副本。调整关系报表标题宽度、表标题及字段列表字体，并增加就诊字段列表高度。A4 横向单页预览中，完整显示 Group3_animalhospital、tblMedicationInteraction、InteractionDescription、Diagnosis 和 AppointmentFee。压缩重开后，11 个查询均能打开，三份报表均成功预览。

修订库关库 SHA-256 为 02A835410FEDDE73D6762BAAF194B3FFAFFE3B35627DFA62360A8078D48F8676。该摘要取代旧候选版摘要用于后续 M7 验收。原生 Documenter 与跨机 UAT 仍待完成；原生导出的已知阻碍见 M8_Audit_Report.md。

## 获准修订与复验 · 2026-11-25

基于 34b5587，保留 GitHub 原验收版本。独立副本中为原来没有允许值规则的 13 个必填短文本字段新增 Len(Trim([Field]))>0，保持 Required 与 AllowZeroLength 设置。其余两个必填短文本字段 SeverityLevel、AccountType 沿用并复测原有允许值规则。更新 tblCashReceipt.CollectedByVetID 字段说明为 “Veterinarian who collected the payment.”，保留库内设计说明的 D3 口径。待团队确认预收款口径后再决定日期侦测查询。此次未采纳可选文档查询和子数据表属性改动，T21/T22 仍为 KNOWN_LIMITATION。

DAO 在独立回归副本以事务执行 58 项测试并逐项回滚。13 个字段的三空格、零长度串和 Null 均拒绝，各自原合法样例值均可保存（52 项）。两个枚举字段均拒绝三空格和非法枚举值，原合法值仍可保存（6 项）。这是 DAO 引擎复测，未重新执行完整跨机或数据表 UI 测试。比对 21 条完整样例记录、12 条关系和 11 条已发布查询 SQL，均与 34b5587 一致。11 条查询可运行，三份报表可预览。

新文件 SHA-256 为 ACB5F734BA273DAFD2B64E6FE001894203BD51E360B9EE1C105B040CC6FA0983。Group3_Table_Definitions_Final.pdf 共 11 页，包含候选库 SHA-256、10 表、46 字段、12 关系及 11 查询。使用 Access DAO 读出结构后用 ReportLab 排版，保留此前的原生 Documenter 历史 PDF。此次未重新运行原生 Database Documenter。待推送后请 M7 使用新摘要复验，既有 M7 回执针对 34b5587。
