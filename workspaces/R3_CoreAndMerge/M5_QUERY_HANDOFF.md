# 成员 5 查询交接

从本说明所在的 Git 提交取 [正式底库](v1_Core_Seeded.accdb)、[样例及预期工作簿](../R4_SampleData/Sample_Data_Master.xlsx) 和 [11 个查询的 SQL](../../technical/)。在仓库根目录按 AGENTS.md 开工。结构与查询顺序见根目录 02 蓝图第 4、5、7 节。病例、药名和金额预期采用该提交的工作簿 Seed / Expected。

## 成员 3 发布记录

正式底库与评审提交 10d44a7 的数据库逐字节相同。SHA256 为 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`。Windows DAO 只读核对 10 表、46 字段、12 条关系、21 条样例和 0 个保存的业务查询。Access 在独立副本重开关系窗口后保留了排版，见[重开截图](M3_Layout_Reopened.png)。最右侧药品别名框在当前窗口内只显示一部分，可横向滚动查看。

- [成员 2 结构签收](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/0c231ee195fd1de33f2d66c4abbcd4cdf532a470/workspaces/R2_Dictionary/M2_Core_Review.md)。保留实测的 7 个 AutoNumber 主键 Required=No，由主键约束保证键值非空。请成员 2 在下一版字典中区分属性读数和业务约束。保留药对规则原写法，空格差异不影响比较。
- [成员 4 样例回执与实际 ID 映射](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/e373560e6f3b1bfb023101175d720e8e034b216a/workspaces/R4_SampleData/M4_Core_Review.md)。21 行、15 个 ID 映射、20 个预期值已对齐。D1 已确认，每表至少两条，药品表三条。币种标签待团队确认。M4 在 macOS 独立复算，查询的 Access 执行结果由 M5 提供。

## 成员 5 和 AI 的操作

1. 获取发布提交并在本地核对正式底库的 SHA256。在自己的 `role/M5-queries` 分支，把该底库复制为 `workspaces/R5_Queries/v2_R5_Queries.accdb`，在该副本中操作。
2. 按 02 第 7 节的 Q01–Q11 依赖顺序，用对应 SQL 在 Access 中创建并保存全部 11 个查询。逐个运行并对照工作簿 Expected，记录实际值、行数、差异及未测项。A1 收费/核销/余额应为 205/205/0，A2 为 90/0/90，无效核销 0 行，药物预警 1 行，病历 3 行。按工作簿核对具体药名与收费单价。
3. 关库重开，确认保存查询可运行。把核对清单放入 R5 目录，注明来源提交、底库摘要、执行环境与结果。追加本角色 SQL 交接日志并运行日志校验。经本人确认后，将查询库、核对清单和日志推送到 `role/M5-queries`，把提交链接及待处理问题交回成员 3。成员 3 后续从交付库导入查询。
