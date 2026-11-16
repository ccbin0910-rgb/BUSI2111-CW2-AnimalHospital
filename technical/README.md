# 技术文件与验证原型

这里的 `.accdb` 是结构、SQL和核销辅助函数的验证原型，不是课程成品；药品3条，是否符合提交数量尚未确认；不含成品窗体/报表。

- SQL：与02蓝图的11个查询一一对应，按蓝图顺序创建。
- modAllocationValidation.bas：ASCII无BOM标准模块；在Access VBA编辑器导入。
- sfrm_ReceiptAllocations_events.txt：核销子窗体事件包装；不能作为标准模块导入。
- spec.json：从数据字典整理的结构/查询，供测试脚本建独立数据库。
- validation_results.json：本次真实Access自动检查的最终结果；其中确认限制的测试不是功能修复证明。
- test_cw2_access.py：需Windows、Access、Python与pywin32；运行会在本目录新建带时间戳的run文件夹和独立数据库，更新latest_run.json，不会覆盖验证原型或修改系统宏策略。

复跑：在本目录运行 `python -X utf8 test_cw2_access.py`。如环境阻止COM启动，记录实际错误，不通过降低全局宏设置规避。本脚本是技术复现材料，小组按03手册操作不依赖Python。
