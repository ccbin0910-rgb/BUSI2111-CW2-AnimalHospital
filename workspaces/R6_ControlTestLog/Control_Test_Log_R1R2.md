# Control Test Log — Member 6 — Round 1–2 and T01–T22

- **Date:** 2026-11-20 (Asia/Shanghai)
- **Branch:** `role/M6-controls` (start commit `98d8c7e7e7f180a190e587e93de28b1f8de4e68d`)
- **Database:** Microsoft Access 16.0, tested through Access COM / DAO against the isolated test copy.
- **Overall status:** `PARTIAL` — database-engine checks below completed; the SOP-required visible Datasheet View keyboard/paste interaction was not performed.

## Fixed inputs and baseline

All three fixed input snapshots are kept in this role folder under `Inputs/`; the test database is a separate copy. SHA-256 fingerprints:

| Input | SHA-256 |
|---|---|
| `Inputs/v1_Core_Seeded.accdb` | `5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127` |
| `Inputs/Sample_Data_Master.xlsx` | `92458044b9b0ddbB211fe63c7b04b821c4d8c5442b6702c1ee56298943087034` |
| `Inputs/v2_R5_Queries.accdb` | `6c717bd1cc74be416c064b35a6b3bfaae4f6b56c1a707d293baac172c0dbd79c` |

The test copy imported the 11 saved queries from the M5 library; no tables were imported. Baseline row counts were 2 in each of nine tables and 3 in `tblMedication` (21 rows total). Query baseline: A1 total 205.00, paid 205.00, balance 0.00; A2 total 90.00, paid 0.00, balance 90.00; `qry_Ctrl_InvalidAllocations` 0 rows; `qry_Ctrl_DrugInteractionWarnings` 1 row.

After each scenario the copy was reset from `Clean_Baseline.accdb`. A final read-only DAO check found 10 tables, 11 queries, original table row counts, `Pet 1.ParentID=1`, `A1.AppointmentDate=2026-11-10`, and the original `EveningPhone`; the test copy hash remained unchanged during that read-only check.

## Round 1–2 field matrix

The 46 rows below use the inputs in Member 4 `Field_3Rounds_Matrix` and the first seeded row of each table. Each value was applied with an Access SQL `UPDATE`, checked against the Access response and stored value, and restored before the next attempt. `Null` for optional `EveningPhone` in R1 is the expected positive control; the R2 empty-string attempt was rejected.

| Table.Field | Round 1 actual | Round 2 actual |
|---|---|---|
| tblPetParent.ParentID | `2` → 拒绝：不能更新 'ParentID'；字段不可更新。 | `2` → 拒绝：不能更新 'ParentID'；字段不可更新。 |
| tblPetParent.ParentName | `Null` → 拒绝：必须在字段 'tblPetParent.ParentName' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPetParent.ParentName' 不能是零长度的字符串。 |
| tblPetParent.Address | `Null` → 拒绝：必须在字段 'tblPetParent.Address' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPetParent.Address' 不能是零长度的字符串。 |
| tblPetParent.DayPhone | `Null` → 拒绝：必须在字段 'tblPetParent.DayPhone' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPetParent.DayPhone' 不能是零长度的字符串。 |
| tblPetParent.EveningPhone | `Null` → 接受；存储 Null，Restored | `"" (zero-length)` → 拒绝：字段 'tblPetParent.EveningPhone' 不能是零长度的字符串。 |
| tblPet.PetID | `2` → 拒绝：不能更新 'PetID'；字段不可更新。 | `2` → 拒绝：不能更新 'PetID'；字段不可更新。 |
| tblPet.ParentID | `Null` → 拒绝：必须在字段 'tblPet.ParentID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblPet.PetName | `Null` → 拒绝：必须在字段 'tblPet.PetName' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPet.PetName' 不能是零长度的字符串。 |
| tblPet.Breed | `Null` → 拒绝：必须在字段 'tblPet.Breed' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPet.Breed' 不能是零长度的字符串。 |
| tblPet.Color | `Null` → 拒绝：必须在字段 'tblPet.Color' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblPet.Color' 不能是零长度的字符串。 |
| tblPet.BirthDate | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 | `2099-12-31 00:00:00` → 拒绝：Birth date cannot be in the future. |
| tblVeterinarian.VetID | `2` → 拒绝：不能更新 'VetID'；字段不可更新。 | `2` → 拒绝：不能更新 'VetID'；字段不可更新。 |
| tblVeterinarian.VetName | `Null` → 拒绝：必须在字段 'tblVeterinarian.VetName' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblVeterinarian.VetName' 不能是零长度的字符串。 |
| tblVeterinarian.RoleTitle | `Null` → 拒绝：必须在字段 'tblVeterinarian.RoleTitle' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblVeterinarian.RoleTitle' 不能是零长度的字符串。 |
| tblAppointment.AppointmentID | `2` → 拒绝：不能更新 'AppointmentID'；字段不可更新。 | `2` → 拒绝：不能更新 'AppointmentID'；字段不可更新。 |
| tblAppointment.PetID | `Null` → 拒绝：必须在字段 'tblAppointment.PetID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblAppointment.VetID | `Null` → 拒绝：必须在字段 'tblAppointment.VetID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblAppointment.AppointmentDate | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 | `Null` → 拒绝：必须在字段 'tblAppointment.AppointmentDate' 中输入一个值。 |
| tblAppointment.DurationMin | `0` → 拒绝：Enter whole minutes from 1 to 1440. | `1.5` → 拒绝：Enter whole minutes from 1 to 1440. |
| tblAppointment.WeightKg | `0` → 拒绝：Pet weight must be greater than 0 kg. | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblAppointment.VisitReason | `Null` → 拒绝：必须在字段 'tblAppointment.VisitReason' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblAppointment.VisitReason' 不能是零长度的字符串。 |
| tblAppointment.Diagnosis | `Null` → 拒绝：必须在字段 'tblAppointment.Diagnosis' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblAppointment.Diagnosis' 不能是零长度的字符串。 |
| tblAppointment.AppointmentFee | `-0.01` → 拒绝：Enter a non-negative amount with at most two decimal places. | `$abc` → 拒绝：标准表达式中数据类型不匹配。 |
| tblMedication.MedicationID | `2` → 拒绝：不能更新 'MedicationID'；字段不可更新。 | `2` → 拒绝：不能更新 'MedicationID'；字段不可更新。 |
| tblMedication.MedicationName | `Null` → 拒绝：必须在字段 'tblMedication.MedicationName' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblMedication.MedicationName' 不能是零长度的字符串。 |
| tblMedication.ListPrice | `-0.01` → 拒绝：Enter a non-negative amount with at most two decimal places. | `$abc` → 拒绝：标准表达式中数据类型不匹配。 |
| tblPrescriptionLine.AppointmentID | `Null` → 拒绝：必须在字段 'tblPrescriptionLine.AppointmentID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblPrescriptionLine.MedicationID | `Null` → 拒绝：必须在字段 'tblPrescriptionLine.MedicationID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblPrescriptionLine.Quantity | `0` → 拒绝：Enter whole units from 1 to 100000. | `1.5` → 拒绝：Enter whole units from 1 to 100000. |
| tblPrescriptionLine.UnitPriceCharged | `-0.01` → 拒绝：Enter a non-negative amount with at most two decimal places. | `$abc` → 拒绝：标准表达式中数据类型不匹配。 |
| tblCashReceipt.ReceiptID | `2` → 拒绝：不能更新 'ReceiptID'；字段不可更新。 | `2` → 拒绝：不能更新 'ReceiptID'；字段不可更新。 |
| tblCashReceipt.ParentID | `Null` → 拒绝：必须在字段 'tblCashReceipt.ParentID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblCashReceipt.AccountID | `Null` → 拒绝：必须在字段 'tblCashReceipt.AccountID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblCashReceipt.CollectedByVetID | `Null` → 拒绝：必须在字段 'tblCashReceipt.CollectedByVetID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblCashReceipt.ReceiptDate | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 | `2099-12-31 00:00:00` → 拒绝：Receipt date cannot be in the future. |
| tblCashReceipt.ReceiptTotal | `0` → 拒绝：Enter a positive amount with at most two decimal places. | `$abc` → 拒绝：标准表达式中数据类型不匹配。 |
| tblReceiptAllocation.ReceiptID | `Null` → 拒绝：必须在字段 'tblReceiptAllocation.ReceiptID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblReceiptAllocation.AppointmentID | `Null` → 拒绝：必须在字段 'tblReceiptAllocation.AppointmentID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblReceiptAllocation.AppliedAmount | `0` → 拒绝：Enter a positive amount with at most two decimal places. | `$abc` → 拒绝：标准表达式中数据类型不匹配。 |
| tblMedicationInteraction.MedicationAID | `Null` → 拒绝：必须在字段 'tblMedicationInteraction.MedicationAID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblMedicationInteraction.MedicationBID | `Null` → 拒绝：必须在字段 'tblMedicationInteraction.MedicationBID' 中输入一个值。 | `Pickle` → 拒绝：标准表达式中数据类型不匹配。 |
| tblMedicationInteraction.SeverityLevel | `Null` → 拒绝：必须在字段 'tblMedicationInteraction.SeverityLevel' 中输入一个值。 | `Critical` → 拒绝：Severity must be High, Moderate, or Low. |
| tblMedicationInteraction.InteractionDescription | `Null` → 拒绝：必须在字段 'tblMedicationInteraction.InteractionDescription' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblMedicationInteraction.InteractionDescription' 不能是零长度的字符串。 |
| tblCashAccount.AccountID | `2` → 拒绝：不能更新 'AccountID'；字段不可更新。 | `2` → 拒绝：不能更新 'AccountID'；字段不可更新。 |
| tblCashAccount.AccountName | `Null` → 拒绝：必须在字段 'tblCashAccount.AccountName' 中输入一个值。 | `"" (zero-length)` → 拒绝：字段 'tblCashAccount.AccountName' 不能是零长度的字符串。 |
| tblCashAccount.AccountType | `Null` → 拒绝：必须在字段 'tblCashAccount.AccountType' 中输入一个值。 | `Card` → 拒绝：Choose Cash or Bank. |

**Round totals:** R1 46/46 expected outcomes (45 invalid values rejected; optional `EveningPhone=Null` accepted and restored); R2 46/46 expected outcomes (all 46 rejected). Evidence includes the full input instruction, literal attempt, Access response, stored value, and restoration status for each field in `Control_Test_Log_R1R2_Evidence.json`.

## T01–T22 integrity and reconciliation scenarios

| T01 | PASS | WeightKg = −2 and Quantity = 0 are rejected. | WeightKg = -2 → Blocked by Access (Access error: Pet weight must be greater than 0 kg.)<br>Quantity = 0 → Blocked by Access (Access error: Enter whole units from 1 to 100000.) |
| T02 | PASS | Quantity = 1.5 and DurationMin = 1.5 are rejected without rounding. | Quantity = 1.5 → Blocked by Access (Access error: Enter whole units from 1 to 100000.)<br>DurationMin = 1.5 → Blocked by Access (Access error: Enter whole minutes from 1 to 1440.) |
| T03 | PASS | Future BirthDate is rejected. | BirthDate = 2099-01-01 → Blocked by Access (Access error: Birth date cannot be in the future.) |
| T04 | PASS | Nonexistent PetID is rejected by referential integrity. | Appointment PetID = absent ID 999 → Blocked by Access (Access error: 由于数据表 'tblPet' 需要一个相关记录，不能添加或修改记录。) |
| T05 | PASS | Referenced Pet cannot be deleted; its row remains. | Delete referenced Pet 1 → DeleteAccepted=False; remaining rows=1 (Access error: 由于表 'tblAppointment' 中了包含相关记录，不能删除或改变该记录。) |
| T06 | PASS | Self/reverse drug pairs fail the table rule; the existing ordered pair fails the composite PK. | Insert self pair (1,1) → Accepted=False; rows=0 (Access error: MedicationAID must be strictly less than MedicationBID to prevent self-links and duplicate reverse pairs.)<br>Insert reverse pair (2,1) → Accepted=False; rows=0 (Access error: MedicationAID must be strictly less than MedicationBID to prevent self-links and duplicate reverse pairs.)<br>Insert duplicate ordered pair (1,2) → Accepted=False; rows=1 (Access error: 由于将在索引、 主关键字、或关系中创建重复的值，请求对表的改变没有成功。改变该字段中的或包含重复数据的字段中的数据，删除索引或重新定义索引以允许重复的值并再试一次。) |
| T07 | PASS | Exactly one Cross-Parent exception (+40); R3 remaining 10; A2 balance 50. | R3(P2,50) → A2(40) → exceptions=1:Cross-Parent Allocation, amount=40; R3 remaining=10; A2 balance=50 |
| T08 | PASS | Exactly one Receipt Over-Allocated exception (−10); A2 balance 30. | R3(P1,50) → A2(60) → exceptions=1:Receipt Over-Allocated, amount=-10; R3 remaining=-10; A2 balance=30 |
| T09 | PASS | Exactly one Appointment Over-Paid exception (−10); R3 remaining 20. | R3(P1,120) → A2(100) → exceptions=1:Appointment Over-Paid, amount=-10; R3 remaining=20; A2 balance=-10 |
| T10 | PASS | Unapplied R3 is 50 then 20; no exception rows. | R3=50; then allocate 30 to A2 → phase1 remaining=50, exceptions=0; phase2 remaining=20, exceptions=0 |
| T11 | PASS | R3 fully allocated; A2 balance 30, A3 balance 10; no exception rows. | A3=50; R3=100 split 60/40 to A2/A3 → R3 remaining=0.0000; A2=30; A3=10; exceptions=0 |
| T12 | PASS | Composite PK blocks duplicate (R1,A1); original amount 100 remains. | Append duplicate (R1,A1) allocation → Accepted=False; pair rows=1; amount=100 (Access error: 由于将在索引、 主关键字、或关系中创建重复的值，请求对表的改变没有成功。改变该字段中的或包含重复数据的字段中的数据，删除索引或重新定义索引以允许重复的值并再试一次。) |
| T13 | PASS | Editing allocation to 80 yields R1 unapplied 20 and A1 balance 20; no exception. | Edit only R1→A1 AppliedAmount 100→80 → R1 unapplied=20; A1 paid=185; balance=20; exceptions=0 |
| T14 | PASS | Reducing R1 total to 90 yields one Receipt Over-Allocated exception (−10). | Reduce R1 total 100→90 → exceptions=1:Receipt Over-Allocated, amount=-10 |
| T15 | PASS | Reducing A1 fee to 100 yields total 185 and one Appointment Over-Paid exception (−20). | Reduce A1 fee 120→100 → total=185; balance=-20; exceptions=1:Appointment Over-Paid |
| T16 | PASS | Changing M1 catalog price leaves charged price 30, line charge 60, and A1 total 205. | Change M1.ListPrice 35→99 → list=99; charged=30; line=60; A1 total=205 |
| T17 | PASS | Changing historical unit price to 20 yields medicine 65, A1 total 185, and one Appointment Over-Paid exception (−20). | Change A1/M1 charged unit price 30→20 → medicine=65; total=185; balance=-20; exceptions=1 |
| T18 | PASS | Duplicate owner and veterinarian display names are allowed and remain distinguishable by IDs. | Add duplicate ParentName Emily Chen → same-name rows=2; pet counts=2,0<br>Add duplicate VetName Dr. Nottingham → same-name rows=2; IDs=1,3 |
| T19 | PASS | Currency rule rejects 100.001 and keeps stored total 100.00. | Set R1.ReceiptTotal=100.001 → Accepted=False; stored=100 (Access error: Enter a positive amount with at most two decimal places.) |
| T20 | PASS | AccountID/CollectedByVetID invalid IDs and Nulls are rejected. | AccountID=999 → Blocked by Access (Access error: 由于数据表 'tblCashAccount' 需要一个相关记录，不能添加或修改记录。)<br>AccountID=Null → Blocked by Access (Access error: 必须在字段 'tblCashReceipt.AccountID' 中输入一个值。)<br>CollectedByVetID=999 → Blocked by Access (Access error: 由于数据表 'tblVeterinarian' 需要一个相关记录，不能添加或修改记录。)<br>CollectedByVetID=Null → Blocked by Access (Access error: 必须在字段 'tblCashReceipt.CollectedByVetID' 中输入一个值。) |
| T21 | KNOWN_LIMITATION | Known limitation: pet owner change rewrites the owner shown for historical appointments. | Reassign historical Pet 1 to Parent 2 → A1 current ParentID=2; A1 balance=0.0000 |
| T22 | KNOWN_LIMITATION | Known limitation: appointment date earlier than pet birth date is accepted. | Set A1 date earlier than Pet 1 birth date → A1 date=01/01/2020 00:00:00; Pet 1 birth=2023-04-15 |

T01–T20 subcases matched their expected preventive or detective behavior. `qry_Ctrl_InvalidAllocations` reports exceptions after entry; it does not block them.

### Known-limitations reproduction steps

1. **T21 — owner history:** Start from a clean test copy. In `tblPet`, change `PetID=1` from `ParentID=1` to `ParentID=2`. Re-run `qry_00_AppointmentOwner`: A1 now shows ParentID 2; the A1 balance remains 0.00. The database has no owner-history table, so prior appointments follow the current pet owner.
2. **T22 — cross-table date:** Start from a clean test copy. In `tblAppointment`, change `AppointmentID=1` to `AppointmentDate=2020-01-01` while Pet 1 has `BirthDate=2023-04-15`. Access accepts the value; no cross-table date validation is implemented.

## Not tested / handoff

- The requested SOP method says to type/paste and commit each case directly in visible Datasheet View. The CUA session could not activate the minimized Windows desktop app. This run used Access 16.0 COM/DAO SQL and saved queries instead; it validates the Access data engine but not Datasheet focus, clipboard, cell-edit, Enter/Tab, Esc, visual error dialogs, or UI normalization.
- Supplemental M4 cases C01–C04 were outside this request and were not run. C05–C07 are covered by T06. VBA cases V01–V09 were not run (VBA is disabled by the current design). Round 3 plus PK/FK and 12 relationship-direction review remain in M7 scope.
- **D1 source conflict for M3:** The 2026-11-18 M3 handoff says the lecturer confirmed D1, while the fixed M4 workbook Seed sheet still says `D1 OPEN` and marks M3/M2–M3 provisional. The tested 3-medication/2-interaction fixture matches the file contents; reconcile the workbook status before final integration.
- D3 (`CollectedByVetID` required) is treated as confirmed per M1/M2 handoff; T20 exercised both invalid ID and Null for both required receipt FKs.
- Handoff to M7: use a separate clean copy and run the Round 3 blind matrix before viewing these results. The isolated test database is local-only and must not be merged into the submission database.

## Evidence file

`workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json` records Access version, fixed-input hashes, query import, baseline values, all 92 field attempts, each T subcase, and the final expected result. The `_Test.accdb` and `Clean_Baseline.accdb` are gitignored local copies.
