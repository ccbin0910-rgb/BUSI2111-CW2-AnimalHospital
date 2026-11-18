# 成员 2 / 4 评审交接

评审文件为本目录的 [v1_Core_Seeded_REVIEW.accdb](v1_Core_Seeded_REVIEW.accdb)，SHA256 为 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`。从 GitHub 拉取发布此文件的分支或提交，关库后算摘要，再复制到各自工作目录打开。

- **成员 2** 对照 R2 冻结字典核对 10 表、46 字段、三组复合主键、字段规则和说明，重点核对 EveningPhone 与药对表规则。依据是技术蓝图第 4–5 节和角色 SOP。此步骤核实 Access 实现是否忠实于字典。请把差异或签收写在 R2 目录。
- **成员 4** 对照 R4 工作簿的 Seed 和 Expected 核对 21 行、符号到实际 ID 的映射及新版案例。独立重算 A1/A2 的收费、核销和余额。依据是工作簿及技术蓝图第 6 节。此步骤核实团队将使用的样例和查询验收预期一致。请把差异或签收写在 R4 目录。
- 成员 2 的依据为 [冻结字典](../R2_Dictionary/Schema_Freeze.xlsx)，回执写入 `workspaces/R2_Dictionary/M2_Core_Review.md`。成员 4 的依据为 [样例与预期工作簿](../R4_SampleData/Sample_Data_Master.xlsx)，回执写入 `workspaces/R4_SampleData/M4_Core_Review.md`。

## 给执行复核的 AI

1. 按仓库根目录的 `AGENTS.md` 完成开工检查。在自己的角色分支工作，从成员 3 提供的 GitHub 提交取本计划、评审库及对应工作簿。用 PowerShell 的 `Get-FileHash` 核对上面的 SHA256，再打开角色目录中的本地副本。
2. 独立完成自己角色的检查。回执注明源提交、库摘要、操作者和实测方式。逐项记录预期、实测、差异及其影响，最后给成员 3 明确结论。无法运行 Access 或只核对了部分内容时，列明未测项及原因，按仓库规则标记状态。发现问题时保留原评审库供成员 3 复现。
3. 在 `handoff_logs/entries/` 追加本角色的 SQL 日志，从仓库根目录运行 `python -X utf8 handoff_logs/query_logs.py --check --summary`。列出本次回执和日志，请本机成员确认后仅提交这两项并推送到自己的角色分支。核实远端提交成功后，把回执的 GitHub 永久链接、源评审提交及复核结论交给成员 3。

成员 3 收到两份回执后处理差异、确认保存后的关系图，再将签收版本生成 `v1_Core_Seeded.accdb` 并记下新发布版本及摘要。成员 5 以该统一版为基础制作 11 个查询。成员 6–8 可按各自的输入依赖从同一统一版开工。
