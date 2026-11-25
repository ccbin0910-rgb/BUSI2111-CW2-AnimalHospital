# 提交前操作说明

实际提交由用户完成。

## 提交文件

上传 Group3_animalhospital.accdb。候选文件为 M8 107f551 同字节副本，摘要见 Submission_Manifest.json。表定义 PDF 是配套查阅材料，当前作业说明明确要求 .accdb，未明确要求另附 PDF。

## Moodle 封面与截止

课程页的 Coursework submission coversheet - MUST COMPLETE 当前显示未完成。先填写 https://moodle.nottingham.ac.uk/mod/feedback/view.php?id=8874646 ，再进入 https://moodle.nottingham.ac.uk/mod/assign/view.php?id=9381788 上传。课程说明要求改稿重交时重新填写封面。截止为 2026-11-27 15:00；组内目标为当天12:00前。

## AI 使用说明草稿

以下草稿依据八个角色分支的 SQL 日志，应按封面实际问题及组员真实使用情况填写。

Our group used AI tools to assist with database design and documentation, SQL query development, validation scripts, test interpretation, report preparation and review. Tests and limitations are documented with their actual verification methods. Team members reviewed the outputs and remain responsible for the submitted work.

日志记录的工具与角色如下。
- M1 — OpenAI Codex
- M2 — DeepSeek Harness (deepseek-flash)
- M3 — OpenAI Codex
- M4 — OpenAI Codex
- M5 — OpenAI Codex
- M6 — OpenAI Codex
- M7 — DeepSeek Harness
- M8 — OpenAI Codex
- SYS — Antigravity, Antigravity + R2 Automation

详细来源见 AI_Usage_Evidence.json。本机收尾使用 OpenAI Codex 修正 PDF、通过 Access COM/DAO 复验并整理回执。

## 尚需实证的项目

当前机器已完成21项本机验收。新版第二台Windows电脑验收尚缺回执。完整13个T场景的界面操作证据范围沿用M6记录，不能把引擎验证标成界面实测。用户实际提交后可下载上传文件，核对摘要并用副本重开。

## 校验与复核

在本目录运行 python -X utf8 verify_package.py 可检查发布文件与已记录证据的一致性。此脚本不执行新的Access测试。用户明确排除Computer Use，后续验证沿用COM/DAO和已有界面证据。
