# Round 3 Audit - M7 (Datasheet Blind Test + PK/FK/Relationship Audit)

| Item | Value |
| --- | --- |
| Auditor | Member 7 (M7), branch `role/M7-audit` |
| Date | 2026-11-21 (Asia/Shanghai) |
| Database tested | `workspaces/R7_Forms/Inputs/v1_Core_Seeded.accdb` (source commit `810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13`) |
| SHA-256 of tested copy | `5779B94439854514F6B32F3BADBF8B132ABF8FD22CAC35AECF3D000D14974127` (matches the SHA-256 quoted by M3's handoff) |
| Working copies | `workspaces/R7_Forms/_Test.accdb`, `workspaces/R7_Forms/_Clean_Baseline.accdb` (both byte-identical to the input; restored to this hash after testing) |
| Test workbook | `workspaces/R7_Forms/Inputs/Sample_Data_Master_M7.xlsx`, sheet `Field_3Rounds_Matrix` (46 field rows) |
| Workbook SHA-256 | `A356A9C4F415682E606AEE2D0BF0C4D598697965FF97019F1791B908246528ED` |
| Access build | Microsoft Access 16.0.20527.20196 (Microsoft 365, English UI) |
| Independence | These observations were recorded before reading M6's R1/R2 log; the M6 comparison in section 6 was written afterwards. |

## 1. Design baseline used (from `02_最终版数据库架构蓝图与技术规范.md`)

10 tables, 46 fields. 7 single-column AutoNumber primary keys; 3 junction tables with two-column primary keys (`tblPrescriptionLine` = AppointmentID + MedicationID, `tblReceiptAllocation` = ReceiptID + AppointmentID, `tblMedicationInteraction` = MedicationAID + MedicationBID). 12 foreign keys, all Long Integer. 12 relationships, every one with Enforce Referential Integrity on, Cascade Delete off, cascades off.

## 2. Method (read this before reading the table)

Two evidence tracks were used, and the **Method** column of every row says which one produced the result:

1. **Datasheet UI track.** The real Access datasheet view, driven through the Access COM automation surface plus synthetic keystrokes. Values that fit the field were typed; overlength text was inserted through the `Zoom` dialog (Shift+F2), because the datasheet grid on this machine does not accept Ctrl+V into a cell.
2. **Engine track (DAO/SQL).** The same R3 input for each field was applied with a single `UPDATE` through `CurrentDb.Execute sql, dbFailOnError` against the same `.accdb`, and the error text was captured verbatim. This is the same engine-level technique M6 used for their R1/R2 sweep, so the R3 figures are directly comparable.

**Important limitation, stated up front.** Under this automated harness the datasheet flow frequently does not reach the commit point. An illegal value such as `DurationMin = 1441` stays in the edit control, and Tab / Enter / F2 / clicking another cell neither commits it nor raises a message box, while a legal value entered the same way (`45`) commits normally. Enumerating every visible top-level window of the Access process (including untitled ones) while the illegal value was pending found no dialog. Field-level dialogs *were* captured for a few fields - the required-field message, one currency rule (`tblMedication.ListPrice`) and the Zoom overlength box - and where a dialog was captured its text is identical to the engine text below. Because UI coverage is therefore incomplete, every rule / required / datatype row states the track that produced its message, and no row is written up as a datasheet observation unless the dialog was actually captured.

## 3. Primary key audit (10 tables)

| Table | Primary key | Kind | DAO index name | Fields in index | Verdict |
| --- | --- | --- | --- | --- | --- |
| tblPetParent | ParentID | AutoNumber | PrimaryKey | 1 | PASS |
| tblPet | PetID | AutoNumber | PrimaryKey | 1 | PASS |
| tblVeterinarian | VetID | AutoNumber | PrimaryKey | 1 | PASS |
| tblAppointment | AppointmentID | AutoNumber | PrimaryKey | 1 | PASS |
| tblMedication | MedicationID | AutoNumber | PrimaryKey | 1 | PASS |
| tblCashReceipt | ReceiptID | AutoNumber | PrimaryKey | 1 | PASS |
| tblCashAccount | AccountID | AutoNumber | PrimaryKey | 1 | PASS |
| tblPrescriptionLine | AppointmentID + MedicationID | Composite (two keys) | PrimaryKey | 2 | PASS |
| tblReceiptAllocation | ReceiptID + AppointmentID | Composite (two keys) | PrimaryKey | 2 | PASS |
| tblMedicationInteraction | MedicationAID + MedicationBID | Composite (two keys) | PrimaryKey | 2 | PASS |

All 7 AutoNumber keys carry the AutoIncrement attribute (DAO `Attributes & 16`). All 3 junction tables have a single `PrimaryKey` index over exactly the two columns required by the blueprint - the "two keys" requirement is met.

## 4. Foreign key audit (12 fields)

| Child table | FK field | Type (DAO) | Required | Referenced parent | Verdict |
| --- | --- | --- | --- | --- | --- |
| tblPet | ParentID | Long Integer (4) | Yes | tblPetParent.ParentID | PASS |
| tblAppointment | PetID | Long Integer (4) | Yes | tblPet.PetID | PASS |
| tblAppointment | VetID | Long Integer (4) | Yes | tblVeterinarian.VetID | PASS |
| tblPrescriptionLine | AppointmentID | Long Integer (4) | Yes | tblAppointment.AppointmentID | PASS |
| tblPrescriptionLine | MedicationID | Long Integer (4) | Yes | tblMedication.MedicationID | PASS |
| tblCashReceipt | ParentID | Long Integer (4) | Yes | tblPetParent.ParentID | PASS |
| tblCashReceipt | AccountID | Long Integer (4) | Yes | tblCashAccount.AccountID | PASS |
| tblCashReceipt | CollectedByVetID | Long Integer (4) | Yes | tblVeterinarian.VetID | PASS |
| tblReceiptAllocation | ReceiptID | Long Integer (4) | Yes | tblCashReceipt.ReceiptID | PASS |
| tblReceiptAllocation | AppointmentID | Long Integer (4) | Yes | tblAppointment.AppointmentID | PASS |
| tblMedicationInteraction | MedicationAID | Long Integer (4) | Yes | tblMedication.MedicationID | PASS |
| tblMedicationInteraction | MedicationBID | Long Integer (4) | Yes | tblMedication.MedicationID | PASS |

All 12 FK columns are `dbLong` (DAO type 4, i.e. Long Integer / Number - Long Integer) and `Required = True`, exactly as the blueprint specifies. No FK is Text, none is Double, none is nullable.

## 5. Relationship audit (12 relationships)

Read from the `Relations` collection of the live database, and cross-checked in the Relationships window.

| # | Relationship (DAO name) | Parent (1 side) | Child (many side) | Attributes | Enforce RI | Cascade Delete | Cascade Update | Line shows 1 : infinity | Verdict |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | rel_1 | tblPetParent.ParentID | tblPet.ParentID | 0 | Yes | No | No | Yes | PASS |
| 2 | rel_2 | tblPetParent.ParentID | tblCashReceipt.ParentID | 0 | Yes | No | No | Yes | PASS |
| 3 | rel_3 | tblPet.PetID | tblAppointment.PetID | 0 | Yes | No | No | Yes | PASS |
| 4 | rel_4 | tblVeterinarian.VetID | tblAppointment.VetID | 0 | Yes | No | No | Yes | PASS |
| 5 | rel_5 | tblAppointment.AppointmentID | tblPrescriptionLine.AppointmentID | 0 | Yes | No | No | Yes | PASS |
| 6 | rel_6 | tblMedication.MedicationID | tblPrescriptionLine.MedicationID | 0 | Yes | No | No | Yes | PASS |
| 7 | rel_7 | tblCashReceipt.ReceiptID | tblReceiptAllocation.ReceiptID | 0 | Yes | No | No | Yes | PASS |
| 8 | rel_8 | tblAppointment.AppointmentID | tblReceiptAllocation.AppointmentID | 0 | Yes | No | No | Yes | PASS |
| 9 | rel_9 | tblMedication.MedicationID | tblMedicationInteraction.MedicationAID | 0 | Yes | No | No | Yes | PASS |
| 10 | rel_10 | tblMedication.MedicationID | tblMedicationInteraction.MedicationBID | 0 | Yes | No | No | Yes | PASS |
| 11 | rel_11 | tblCashAccount.AccountID | tblCashReceipt.AccountID | 0 | Yes | No | No | Yes | PASS |
| 12 | rel_12 | tblVeterinarian.VetID | tblCashReceipt.CollectedByVetID | 0 | Yes | No | No | Yes | PASS |

Evidence for each column:

- **Attributes = 0** on all 12 relations. In DAO, `dbRelationUpdateCascade = 256` and `dbRelationDeleteCascade = 4096` are the cascade bits, and `dbRelationDontEnforce = 2` is the "do not enforce" bit; 0 therefore means enforce RI, no cascades.
- **`1 : infinity` on screen.** The Relationships window shows a `1` at the parent end and an `infinity` glyph at the child end of every link; that glyph pair is only drawn for relationships with referential integrity enforced. Screenshot: `_m7work/p34_relations.png` (saved layout) and `_m7work/p36_relations_all.png` (all tables, after Clear Layout).
- **Direction.** Every parent is a primary-key side and every child is the foreign-key side; the four links the SOP flagged as easy to reverse are all correct: `tblVeterinarian -> tblAppointment`, `tblCashAccount -> tblCashReceipt`, `tblPetParent -> tblPet`, `tblPetParent -> tblCashReceipt`. The independent cross-check is that an update to each of the 12 FK columns with a non-existent key was rejected naming **the parent table**, i.e. the engine resolves each link in the direction recorded above (see the 12 FK rows in section 6).
- **Cascade Delete off** was verified by attempting to delete each populated parent row (`tblPetParent` 1, `tblPet` 1, `tblAppointment` 1, `tblVeterinarian` 1, `tblCashAccount` 1, `tblMedication` 1, `tblCashReceipt` 1). All seven deletes were refused, e.g. "The record cannot be deleted or changed because table 'tblPet' includes related records." No child row was ever removed, so no cascade delete path exists.

Two `MSys*` relations also exist in the file (Access navigation-pane internals, attributes 4352). They are system objects, not part of the data model, and are excluded from the count of 12.

## 6. Round 3 - 46 field rows

Baseline before every row: `tblPetParent` (1 Emily Chen, 2 David Wang), `tblPet` (1 Mochi, 2 Boba), `tblVeterinarian` (1 Dr. Nottingham, 2 Dr. Lin), `tblAppointment` (1 fee 120, 2 fee 90), `tblMedication` (1,2,3), `tblPrescriptionLine` (1/1 2.0, 1/2 1.0), `tblCashReceipt` (1 100, 2 105), `tblReceiptAllocation` (1/1 100, 2/1 105), `tblMedicationInteraction` (1-2 Moderate, 2-3 High), `tblCashAccount` (1 Cash, 2 Bank). Workbook control totals (A1 205 / paid 205 / balance 0, A2 90 / unpaid 90, fees 295) were left untouched by the tests, because every rejected row changed nothing and every accepted row was the overlength text case.

| # | Table | Field | R3 input | Method | Observed result (verbatim messages in quotes) | Verdict |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | tblPetParent | ParentID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'ParentID'; field not updateable." | PASS |
| 2 | tblPet | PetID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'PetID'; field not updateable." | PASS |
| 3 | tblVeterinarian | VetID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'VetID'; field not updateable." | PASS |
| 4 | tblAppointment | AppointmentID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'AppointmentID'; field not updateable." | PASS |
| 5 | tblMedication | MedicationID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'MedicationID'; field not updateable." | PASS |
| 6 | tblCashReceipt | ReceiptID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'ReceiptID'; field not updateable." | PASS |
| 7 | tblCashAccount | AccountID | Select the key cell, press Delete | Datasheet UI + engine | UI: value stayed '1', no error dialog, record not flagged dirty. Engine: "Cannot update 'AccountID'; field not updateable." | PASS |
| 8 | tblPetParent | ParentName | 101 x 'X' (FieldSize+1 = 101) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 100 characters (read-back length = 100; nothing beyond FieldSize can ever be stored). | PASS |
| 9 | tblPetParent | Address | 256 x 'X' (FieldSize+1 = 256) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 255 characters (read-back length = 255; nothing beyond FieldSize can ever be stored). | PASS |
| 10 | tblPetParent | DayPhone | 21 x 'X' (FieldSize+1 = 21) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 20 characters (read-back length = 20; nothing beyond FieldSize can ever be stored). | PASS |
| 11 | tblPetParent | EveningPhone | 21 x 'X' (FieldSize+1 = 21) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 20 characters (read-back length = 20; nothing beyond FieldSize can ever be stored). | PASS |
| 12 | tblPet | PetName | 81 x 'X' (FieldSize+1 = 81) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 80 characters (read-back length = 80; nothing beyond FieldSize can ever be stored). | PASS |
| 13 | tblPet | Breed | 101 x 'X' (FieldSize+1 = 101) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 100 characters (read-back length = 100; nothing beyond FieldSize can ever be stored). | PASS |
| 14 | tblPet | Color | 51 x 'X' (FieldSize+1 = 51) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 50 characters (read-back length = 50; nothing beyond FieldSize can ever be stored). | PASS |
| 15 | tblVeterinarian | VetName | 101 x 'X' (FieldSize+1 = 101) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 100 characters (read-back length = 100; nothing beyond FieldSize can ever be stored). | PASS |
| 16 | tblVeterinarian | RoleTitle | 101 x 'X' (FieldSize+1 = 101) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 100 characters (read-back length = 100; nothing beyond FieldSize can ever be stored). | PASS |
| 17 | tblAppointment | VisitReason | 256 x 'X' (FieldSize+1 = 256) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 255 characters (read-back length = 255; nothing beyond FieldSize can ever be stored). | PASS |
| 18 | tblAppointment | Diagnosis | 256 x 'X' (FieldSize+1 = 256) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 255 characters (read-back length = 255; nothing beyond FieldSize can ever be stored). | PASS |
| 19 | tblMedication | MedicationName | 101 x 'X' (FieldSize+1 = 101) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 100 characters (read-back length = 100; nothing beyond FieldSize can ever be stored). | PASS |
| 20 | tblMedicationInteraction | SeverityLevel | 21 x 'X' (FieldSize+1 = 21) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: rejected on the allowed-values rule: "Severity must be High, Moderate, or Low.". | PASS |
| 21 | tblMedicationInteraction | InteractionDescription | 256 x 'X' (FieldSize+1 = 256) | Engine (DAO/SQL UPDATE) | Engine: value accepted and stored truncated at exactly 255 characters (read-back length = 255). The Zoom-paste message box was not captured for this field (earlier state contamination in that session). | PASS |
| 22 | tblCashAccount | AccountName | 61 x 'X' (FieldSize+1 = 61) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: value accepted and stored truncated at exactly 60 characters (read-back length = 60; nothing beyond FieldSize can ever be stored). | PASS |
| 23 | tblCashAccount | AccountType | 31 x 'X' (FieldSize+1 = 31) | Datasheet UI (Zoom paste) + engine | UI: message box "The string returned by the builder was too long. \| The result will be truncated." then OK. Engine: rejected on the allowed-values rule: "Choose Cash or Bank.". | PASS |
| 24 | tblPet | ParentID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblPetParent'." | PASS |
| 25 | tblAppointment | PetID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblPet'." | PASS |
| 26 | tblAppointment | VetID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblVeterinarian'." | PASS |
| 27 | tblPrescriptionLine | AppointmentID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblAppointment'." | PASS |
| 28 | tblPrescriptionLine | MedicationID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblMedication'." | PASS |
| 29 | tblCashReceipt | ParentID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblPetParent'." | PASS |
| 30 | tblCashReceipt | AccountID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblCashAccount'." | PASS |
| 31 | tblCashReceipt | CollectedByVetID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblVeterinarian'." | PASS |
| 32 | tblReceiptAllocation | ReceiptID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblCashReceipt'." | PASS |
| 33 | tblReceiptAllocation | AppointmentID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblAppointment'." | PASS |
| 34 | tblMedicationInteraction | MedicationAID | Non-existent parent key -999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblMedication'." | PASS |
| 35 | tblMedicationInteraction | MedicationBID | Non-existent parent key 999 | Engine (DAO/SQL UPDATE) | "You cannot add or change a record because a related record is required in table 'tblMedication'." | PASS |
| 36 | tblPet | BirthDate | Cleared (Null) | Datasheet UI (pilot) + engine | "You must enter a value in the 'tblPet.BirthDate' field." | PASS |
| 37 | tblCashReceipt | ReceiptDate | Cleared (Null) | Engine (DAO/SQL UPDATE) | "You must enter a value in the 'tblCashReceipt.ReceiptDate' field." | PASS |
| 38 | tblAppointment | AppointmentDate | 30/02/2026 (non-existent calendar date) | Datasheet UI + engine | UI: no dialog, cell did not accept the value (kept the previous date). Engine: date literal rejected - "Syntax error in date in query expression '#2026-02-30'." | PASS |
| 39 | tblAppointment | DurationMin | 1441 | Engine (DAO/SQL UPDATE) | "Enter whole minutes from 1 to 1440." | PASS |
| 40 | tblAppointment | WeightKg | cleared (Null) | Engine (DAO/SQL UPDATE) | "You must enter a value in the 'tblAppointment.WeightKg' field." | PASS |
| 41 | tblAppointment | AppointmentFee | 100.001 | Engine (DAO/SQL UPDATE) | "Enter a non-negative amount with at most two decimal places." | PASS |
| 42 | tblMedication | ListPrice | 100.001 | Datasheet UI + engine | UI: validation dialog in the datasheet: "Enter a non-negative amount with at most two decimal places.". Engine: identical text. | PASS |
| 43 | tblPrescriptionLine | Quantity | 100001 | Engine (DAO/SQL UPDATE) | "Enter whole units from 1 to 100000." | PASS |
| 44 | tblPrescriptionLine | UnitPriceCharged | 100.001 | Engine (DAO/SQL UPDATE) | "Enter a non-negative amount with at most two decimal places." | PASS |
| 45 | tblCashReceipt | ReceiptTotal | 100.001 | Engine (DAO/SQL UPDATE) | "Enter a positive amount with at most two decimal places." | PASS |
| 46 | tblReceiptAllocation | AppliedAmount | 100.001 | Engine (DAO/SQL UPDATE) | "Enter a positive amount with at most two decimal places." | PASS |

Count check: 7 AutoNumber + 16 text + 12 FK + 2 required + 1 date + 8 rule = **46 rows**, matching the 46 rows of `Field_3Rounds_Matrix`. 46 / 46 PASS.

### 6.1 Supplementary R3 checks (not part of the 46 rows)

| Test | Input | Observed result | Verdict |
| --- | --- | --- | --- |
| Table-level rule `[MedicationAID]<[MedicationBID]`, reverse pair | AID 3, BID 1 | "MedicationAID must be strictly less than MedicationBID to prevent self-links and duplicate reverse pairs." | PASS |
| Table-level rule, self link | AID 2, BID 2 | same message as above | PASS |
| `tblPet.BirthDate <= Date()` | 2030-01-01 | "Birth date cannot be in the future." | PASS |
| `tblCashReceipt.ReceiptDate <= Date()` | 2030-01-01 | "Receipt date cannot be in the future." | PASS |
| Currency two-decimal rule, boundary | 100.005 / 100.001 | "Enter a positive amount with at most two decimal places." / "Enter a non-negative amount with at most two decimal places." | PASS |
| Zero-length string in a text field | `""` in `tblPetParent.ParentName` | rejected by the Required + `AllowZeroLength = False` combination (`AllowZeroLength` is False on all text fields, read from the field properties) | PASS |

## 7. Comparison with M6 (R1/R2), written after the R3 run

| Topic | M6 R1/R2 record | M7 R3 observation | Comment |
| --- | --- | --- | --- |
| AutoNumber protection | typed 9876 and pasted a copy of seed ID 2; display stayed 1, no error box | Delete on the key cell: value stayed, no error box; engine says "Cannot update 'X'; field not updateable." | Same behaviour, different stimulus |
| Required message language | Chinese, e.g. 必须在字段 'x' 中输入一个值。 | English: "You must enter a value in the 'tblPet.BirthDate' field." | Same rule, different UI language; both are Access's own text. Report whichever the marking machine shows, do not edit the log to match |
| Zero-length string | two-double-quote method accepted as a ZLS test after checking Microsoft documentation | not re-run in the datasheet; the property `AllowZeroLength = False` is confirmed on all text fields and the engine rejects a zero-length value | Consistent, no contradiction |
| Validation text for rules | engine-level 46x2 sweep, all consistent | identical messages reproduced in R3 | Consistent |
| Datasheet validation dialogs | M6 saw the dialogs in the grid | on this machine the grid does not raise them (section 2) | Environment difference, not a database difference; both logs must keep their own observation |

## 8. Limitations and things NOT verified

1. **Datasheet validation dialogs were only captured for a few fields** (section 2: the automated datasheet flow often never reaches the commit point on this machine). Rows whose message text comes from the engine track are labelled as such; none of them is written up as a datasheet observation.
2. **The Zoom-paste truncation path did not commit the value in the automated flow.** The overlength message box was raised and read for 15 of the 16 text fields (`InteractionDescription` excluded, see below), but the automated read-back after dismissing the box returned the pre-edit value rather than the truncated text. The claim "nothing longer than FieldSize can be stored" is therefore supported by the engine track (stored length = FieldSize exactly), not by a UI read-back. For the same reason `tblMedicationInteraction.InteractionDescription` appears with engine evidence only.
3. **`AppointmentDate` has no future-date rule** in the blueprint and none in the database; only the invalid-calendar-date case was tested.
4. Form-level (P1) checks are out of scope for M7 this round.
5. The Relationships-window screenshots were taken after `Clear Layout`, which only changes the saved diagram positions inside the local test copy. The published database is not affected: `_Test.accdb` was restored to the baseline SHA-256 afterwards, and nothing in `workspaces/R7_Forms/Inputs/` was touched.

## 9. Side effects and housekeeping

- `_Test.accdb` had the `SubdatasheetName = [None]` property added on all 10 tables while auditing (a known workaround for Access crashes with subdatasheets). This copy is local and was reset to the baseline hash afterwards; `_Clean_Baseline.accdb` and everything under `Inputs/` were never modified.
- All automation scripts live in `_m7work/` outside the repository and are not committed.

## 10. 中文要点（可直接转发）

1. 主键：7 个单主键全是 AutoNumber；3 张联合主键表都确实是两把钥匙（tblPrescriptionLine、tblReceiptAllocation、tblMedicationInteraction）。
2. 外键：12 个全部 Long Integer 且必填，没有一个是文本或双精度。
3. 关系：12 条全部 Enforce Referential Integrity，Cascade Delete / Update 全不勾；方向全对，SOP 点名的 4 条易反的关系都是父表在 1 方。
4. Round 3：46 个字段全部 PASS。规则文案与 02 蓝图逐字一致（例如 "Enter whole minutes from 1 to 1440."、"Birth date cannot be in the future."、"MedicationAID must be strictly less than MedicationBID ..."）。
5. 唯一环境差异：本机自动化下数据表经常到不了提交点，字段级验证对话框只抓到少数几个（必填、ListPrice 两位小数、Zoom 超长），因此其余规则类原文取自引擎级 SQL，日志已逐行标注方法与限制；不得把它们写成"数据表视图实测通过"。
6. 数据库中残留数据为零：测试用库已还原为基线 SHA-256 5779B944…74127。
