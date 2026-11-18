# 成员 4 底库复核回执

**日期** 2026-11-18（北京时间） · **操作者** OpenAI Codex（协助成员 4，macOS） · **状态** `PARTIAL`

**结论**：评审库实际存储的 21 条样例和新版工作簿一致。15 个符号 ID 已映射，独立复算的 20 个 Expected 核对值全部一致。数据层面未发现需要成员 3 返工的差异。Windows Microsoft Access 原生复核尚未执行。

## 来源与方法

- [成员 3 的评审提交 10d44a7](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/commit/10d44a733e5f6246ab1cb663d001b0ae22d7eef8) 同时固定评审计划、库及 R4 工作簿的版本。
- [评审计划](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/10d44a733e5f6246ab1cb663d001b0ae22d7eef8/workspaces/R3_CoreAndMerge/M3_REVIEW_HANDOFF.md) · [评审库](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/10d44a733e5f6246ab1cb663d001b0ae22d7eef8/workspaces/R3_CoreAndMerge/v1_Core_Seeded_REVIEW.accdb) · [R4 工作簿](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/10d44a733e5f6246ab1cb663d001b0ae22d7eef8/workspaces/R4_SampleData/Sample_Data_Master.xlsx)。
- 评审库 SHA-256 为 `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127`，与 M3 交接声明一致。使用 macOS `shasum -a 256` 在开库前核算。角色目录中的副本以只读方式打开，关闭后摘要相同。
- 同提交工作簿 SHA-256 为 `92458044b9b0ddbb211fe63c7b04b821c4d8c5442b6702c1ee56298943087034`。用 Jackcess 4.0.8 直接读取评审库的实际记录，再用 Python 对照 `Seed` 并从读出的原始行用 Decimal 独立重算，与 `Expected!D6:D25` 比较。日期按完整到分钟的值比较，金额按数值比较。

## Seed 实测

| 表 | Seed 行数 | 实读行数 | 核对结果 |
| --- | ---: | ---: | --- |
| tblPetParent | 2 | 2 | 两名主人与联系方式一致 |
| tblVeterinarian | 2 | 2 | 两位兽医与职务一致 |
| tblMedication | 3 | 3 | 新药名及目录价一致 |
| tblCashAccount | 2 | 2 | 两个账户及类型一致 |
| tblPet | 2 | 2 | Mochi 和 Boba 均归 Emily，其他字段一致 |
| tblAppointment | 2 | 2 | A1 的主诉与诊断采用新版病例。A2 为常规体检 |
| tblMedicationInteraction | 2 | 2 | 药对 (1,2)、(2,3) 的分级和演示规则全文一致 |
| tblCashReceipt | 2 | 2 | 日期、金额、付款主人、收款账户和经办兽医一致 |
| tblPrescriptionLine | 2 | 2 | 两条均在 A1，数量及成交单价一致。A2 无处方 |
| tblReceiptAllocation | 2 | 2 | 两笔收款均分配给 A1，金额一致 |
| **合计** | **21** | **21** | **80 个普通字段值或外键值一致，另核实 15 个 AutoNumber** |

新版 A1 存为猫衣原体性结膜炎合并反流性食管炎，处方关联多西环素和硫糖铝。实际药对 (1,2) 为 `Moderate`。普拉多沙星只出现在目录和药对 (2,3) 中，该药对在本评审库的处方里无命中。

### 实际 AutoNumber 映射

按工作簿中的名称、日期及金额等标识定位实际记录，再用映射逐项核对 12 类外键所对应的已存值。以下号码仅适用于本次评审库。

| 表 / 主键 | 符号 → 实际 ID |
| --- | --- |
| tblPetParent / ParentID | P1 → 1，P2 → 2 |
| tblVeterinarian / VetID | V1 → 1，V2 → 2 |
| tblMedication / MedicationID | M1 → 1，M2 → 2，M3 → 3 |
| tblCashAccount / AccountID | C1 → 1，C2 → 2 |
| tblPet / PetID | T1 → 1，T2 → 2 |
| tblAppointment / AppointmentID | A1 → 1，A2 → 2 |
| tblCashReceipt / ReceiptID | R1 → 1，R2 → 2 |

## Expected 复算

| 核对项 | 工作簿预期 | 从评审库原始行复算 |
| --- | --- | --- |
| 主人及宠物数 | A1/A2 均归 Emily。Emily 2 只，David 0 只 | 两次就诊通过 T1/T2 均指向 ParentID 1。宠物数为 2、0 |
| A1 药费 | 两条为 60.00、25.00，合计 85.00 | 2 × 30.00 + 1 × 25.00 = **85.00**。对应目录价为 35.00、25.00 |
| A1 收费、核销、余额 | 205.00、205.00、0.00 | 120.00 + 85.00 = **205.00**；100.00 + 105.00 = **205.00**；余额 **0.00** |
| A2 收费、核销、余额 | 90.00、0.00、90.00 | 90.00 + 0.00 = **90.00**；无核销；余额 **90.00** |
| R1 / R2 未分配额 | 各 0.00 | 100.00 − 100.00 = **0.00**；105.00 − 105.00 = **0.00** |
| 账务合计 | 收费 295.00、实收 205.00、未收 90.00 | 205.00 + 90.00 = **295.00**；100.00 + 105.00 = **205.00**；295.00 − 205.00 = **90.00** |
| 无效核销 | 0 行 | 两条核销的主人均匹配，收款和就诊均无超额，推导 **0 行** |
| 药物预警 | 1 行 | A1 仅命中药对 (1,2)，分级 Moderate，推导 **1 行** |
| 病历 | 3 行 | A1 有两条处方，A2 有一条无处方就诊，推导 **3 行** |

## 差异、影响与验收边界

1. **旧蓝图 §6 的临床样例文字未同步。** 该节仍列出 AmoxiVet、FeliRelief 和 GastroCalm，A1 记为皮疹和细菌性皮炎。评审库与新版工作簿采用一致的新病例、三种药名及两条相互作用描述。该差异不改变数值或预警行数，但会影响用旧资料验收时预期的药名、诊断及预警文字。成员 3/组长发布时应明确以该提交的工作簿为样例依据。
2. **D1 与币种待确认。** 实读为三条药品和两组药对，是当前评审口径。工作簿暂按 CNY。报告保留上述实际 ID，工作簿既有预留栏待团队按交接流程补录。
3. **原生 Access 待测。** 当前为 macOS 环境，已直接复核库的实际存储记录，未在 Windows Access/DAO 中打开。库中实读到 0 个保存查询，与成员 5 在统一底库发布后创建查询的计划一致。上表的查询行数是从实读数据复算的预期；成员 5 建齐查询后需要用 Access 再跑一遍。关系图重开和三轮越界录入由交接计划指定角色负责。
