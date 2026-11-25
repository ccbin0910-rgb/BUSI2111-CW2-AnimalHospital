# 当前版本跨机验收

原交接要求另一台Windows验收。当前本机只能完成同机换路径验证，此项仍为NOT_RUN。

输入可从已发布的M8提交直接取得。
https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/107f551837366033b7d6ea12010af1dcb573edc8/workspaces/R8_Reports_UAT/Group3_animalhospital.accdb

SHA256 ACB5F734BA273DAFD2B64E6FE001894203BD51E360B9EE1C105B040CC6FA0983。

另一台Windows若可用，应先核对下载文件摘要，再复制到不含REA源图的新目录。在Access打开副本，查看10张表、11个查询和3份报表，确认REA图片完整、无意外参数提示，关闭重开后可用。回执应写实际设备与Access版本、来源摘要、运行结果、异常及日期，并交M3。测试会改变副本摘要，保留最初下载文件用于对照。

查询预期行数按本目录Local_Final_Acceptance.json。A1应收/已收/余额205/205/0，A2为90/0/90。无效核销0行，药物警告1行。T21/T22保留已知限制。

本轮用户要求不使用Computer Use。本机未代为执行此项。
