# Schema_Freeze — UNNC Animal Hospital (CW2)

> **Deliverable:** M2 data dictionary · 10 tables / 46 fields / 12 foreign keys / 3 composite primary keys  
> **Source:** `02_最终版数据库架构蓝图与技术规范.md` (§4–§5.1) + `technical/spec.json`  
> **Decision frozen here:** D3 confirmed — every cash receipt names exactly one collecting veterinarian (`tblCashReceipt.CollectedByVetID`, required).  
> **Machine-readable twin:** `Schema_Freeze.xlsx` (4 sheets). This file is the diff-able text mirror; keep the two in sync.

## 1. Tables and fields (10 tables / 46 fields)

| Table | Field | Data type | Size / subtype | Key / index | Required | Allow zero length | Format | Validation rule | Validation text | Description |
|---|---|---|---|---|---|---|---|---|---|---|
| tblPetParent | ParentID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each pet parent |
| tblPetParent | ParentName | Short Text | 100 | Indexed (Duplicates OK) | Yes | No | - | - | - | Full name of the pet parent/customer |
| tblPetParent | Address | Short Text | 255 | No | Yes | No | - | - | - | Home mailing address of the parent |
| tblPetParent | DayPhone | Short Text | 20 | No | Yes | No | - | - | - | Daytime phone number (text preserves leading zeros) |
| tblPetParent | EveningPhone | Short Text | 20 | No | No | No | - | - | - | Evening phone number (optional) |
| tblPet | PetID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each pet |
| tblPet | ParentID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Foreign key referencing tblPetParent.ParentID |
| tblPet | PetName | Short Text | 80 | No | Yes | No | - | - | - | Pet's name |
| tblPet | Breed | Short Text | 100 | No | Yes | No | - | - | - | Pet species and breed (e.g., British Shorthair Cat) |
| tblPet | Color | Short Text | 50 | No | Yes | No | - | - | - | Coat/feather color of the pet |
| tblPet | BirthDate | Date/Time | Short Date | No | Yes | n/a | Short Date | <=Date() | Birth date cannot be in the future. | Pet's date of birth (must be on or before today) |
| tblVeterinarian | VetID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each veterinarian |
| tblVeterinarian | VetName | Short Text | 100 | Indexed (Duplicates OK) | Yes | No | - | - | - | Full name/title of the veterinarian |
| tblVeterinarian | RoleTitle | Short Text | 100 | No | Yes | No | - | - | - | Role in hospital (e.g., Co-Owner / Lead Veterinarian) |
| tblAppointment | AppointmentID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each single-pet appointment |
| tblAppointment | PetID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Foreign key referencing tblPet.PetID (one pet per visit) |
| tblAppointment | VetID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Foreign key referencing tblVeterinarian.VetID |
| tblAppointment | AppointmentDate | Date/Time | Short Date | No | Yes | n/a | Short Date | - | - | Date of the veterinary appointment |
| tblAppointment | DurationMin | Number | Double | No | Yes | n/a | General Number | >0 And <=1440 And =Int([DurationMin]) | Enter whole minutes from 1 to 1440. | Length of appointment in minutes |
| tblAppointment | WeightKg | Number | Double | No | Yes | n/a | Fixed (Decimal: 2) | >0 | Pet weight must be greater than 0 kg. | Pet weight recorded during this specific appointment (kg) |
| tblAppointment | VisitReason | Short Text | 255 | No | Yes | No | - | - | - | Reason for the appointment reported by the parent |
| tblAppointment | Diagnosis | Short Text | 255 | No | Yes | No | - | - | - | Veterinarian's clinical diagnosis |
| tblAppointment | AppointmentFee | Currency | Currency | No | Yes | n/a | Currency (Decimal: 2) | (>=0) And [AppointmentFee]=Round([AppointmentFee],2) | Enter a non-negative amount with at most two decimal places. | Base service fee charged for the appointment (excl. medicine) |
| tblMedication | MedicationID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each medication |
| tblMedication | MedicationName | Short Text | 100 | Indexed (Duplicates OK) | Yes | No | - | - | - | Display name of medication; ID identifies the catalog item |
| tblMedication | ListPrice | Currency | Currency | No | Yes | n/a | Currency (Decimal: 2) | (>=0) And [ListPrice]=Round([ListPrice],2) | Enter a non-negative amount with at most two decimal places. | Current standard catalog price per unit |
| tblPrescriptionLine | AppointmentID | Number | Long Integer | Composite PK (1/2) & FK | Yes | n/a | - | - | - | Foreign key referencing tblAppointment.AppointmentID |
| tblPrescriptionLine | MedicationID | Number | Long Integer | Composite PK (2/2) & FK | Yes | n/a | - | - | - | Foreign key referencing tblMedication.MedicationID |
| tblPrescriptionLine | Quantity | Number | Double | No | Yes | n/a | General Number | >0 And <=100000 And =Int([Quantity]) | Enter whole units from 1 to 100000. | Number of units prescribed for this medication |
| tblPrescriptionLine | UnitPriceCharged | Currency | Currency | No | Yes | n/a | Currency (Decimal: 2) | (>=0) And [UnitPriceCharged]=Round([UnitPriceCharged],2) | Enter a non-negative amount with at most two decimal places. | Actual unit price charged at the time of prescription |
| tblCashReceipt | ReceiptID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique identifier for each cash receipt |
| tblCashReceipt | ParentID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Foreign key referencing paying tblPetParent.ParentID |
| tblCashReceipt | AccountID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Cash account receiving this payment |
| tblCashReceipt | CollectedByVetID | Number | Long Integer | FK (Indexed Duplicates OK) | Yes | n/a | - | - | - | Vet who collected payment under prototype staffing assumption |
| tblCashReceipt | ReceiptDate | Date/Time | Short Date | No | Yes | n/a | Short Date | <=Date() | Receipt date cannot be in the future. | Date payment was received |
| tblCashReceipt | ReceiptTotal | Currency | Currency | No | Yes | n/a | Currency (Decimal: 2) | (>0) And [ReceiptTotal]=Round([ReceiptTotal],2) | Enter a positive amount with at most two decimal places. | Total cash amount received from parent in this payment |
| tblReceiptAllocation | ReceiptID | Number | Long Integer | Composite PK (1/2) & FK | Yes | n/a | - | - | - | Foreign key referencing tblCashReceipt.ReceiptID |
| tblReceiptAllocation | AppointmentID | Number | Long Integer | Composite PK (2/2) & FK | Yes | n/a | - | - | - | Foreign key referencing tblAppointment.AppointmentID |
| tblReceiptAllocation | AppliedAmount | Currency | Currency | No | Yes | n/a | Currency (Decimal: 2) | (>0) And [AppliedAmount]=Round([AppliedAmount],2) | Enter a positive amount with at most two decimal places. | Portion of receipt amount applied to settle this appointment |
| tblMedicationInteraction | MedicationAID | Number | Long Integer | Composite PK (1/2) & FK | Yes | n/a | - | - | - | Smaller MedicationID in the interacting pair (FK -> tblMedication) |
| tblMedicationInteraction | MedicationBID | Number | Long Integer | Composite PK (2/2) & FK | Yes | n/a | - | - | - | Larger MedicationID in the interacting pair (FK -> tblMedication) |
| tblMedicationInteraction | SeverityLevel | Short Text | 20 | No | Yes | No | - | "High" Or "Moderate" Or "Low" | Severity must be High, Moderate, or Low. | Clinical severity category of the adverse interaction |
| tblMedicationInteraction | InteractionDescription | Short Text | 255 | No | Yes | No | - | - | - | Description of adverse interaction between Medication A and B |
| tblCashAccount | AccountID | AutoNumber | Long Integer | PK | Yes | n/a | - | - | - | Unique cash account identifier |
| tblCashAccount | AccountName | Short Text | 60 | Indexed (Duplicates OK) | Yes | No | - | - | - | Cash register or bank account name |
| tblCashAccount | AccountType | Short Text | 30 | No | Yes | No | - | "Cash" Or "Bank" | Choose Cash or Bank. | Type of cash resource |

> Short Text fields all use `Allow Zero Length = No`; `EveningPhone` is the only optional text field (Null allowed, empty string is not). Numbers that must be whole use `Double` plus `=Int(...)`, because Access rounds `1.5` into an Integer without an error. Currency fields use `Round(..., 2)` so `100.001` is rejected.

## 2. Relationships (12 foreign keys)

| # | Parent table (1) | Parent key | Child table (∞) | Child FK | Relationship / verb | Enforce RI | Cascade delete | Cascade update | Direction | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 1 | tblPetParent | ParentID | tblPet | ParentID | Owns ▸ (1:N) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 2 | tblPetParent | ParentID | tblCashReceipt | ParentID | Pays ▸ (1:N) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 3 | tblPet | PetID | tblAppointment | PetID | Attends ▸ (1:N) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 4 | tblVeterinarian | VetID | tblAppointment | VetID | Performs ▸ (1:N) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 5 | tblAppointment | AppointmentID | tblPrescriptionLine | AppointmentID | Prescribed in (M:N bridge, part 1) | Yes | No | No (not relied on) | 1 → ∞ correct | Composite PK (AppointmentID, MedicationID) prevents duplicate drug lines in one visit |
| 6 | tblMedication | MedicationID | tblPrescriptionLine | MedicationID | Prescribed in (M:N bridge, part 2) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 7 | tblCashReceipt | ReceiptID | tblReceiptAllocation | ReceiptID | Settled by (M:N bridge, part 1) | Yes | No | No (not relied on) | 1 → ∞ correct | Allocation may split one receipt across visits; parent must match the visit's parent (checked by qry_Ctrl_InvalidAllocations) |
| 8 | tblAppointment | AppointmentID | tblReceiptAllocation | AppointmentID | Settled by (M:N bridge, part 2) | Yes | No | No (not relied on) | 1 → ∞ correct |  |
| 9 | tblMedication | MedicationID | tblMedicationInteraction | MedicationAID | Interacts with (self M:N, side A) | Yes | No | No (not relied on) | 1 → ∞ correct | Self-relationship, side A: only the smaller ID; table rule forces AID < BID |
| 10 | tblMedication | MedicationID | tblMedicationInteraction | MedicationBID | Interacts with (self M:N, side B) | Yes | No | No (not relied on) | 1 → ∞ correct | Self-relationship, side B: only the larger ID; pair stored once |
| 11 | tblCashAccount | AccountID | tblCashReceipt | AccountID | Receives ▸ (1:N) | Yes | No | No (not relied on) | 1 → ∞ correct | Receipt must enter exactly one cash account |
| 12 | tblVeterinarian | VetID | tblCashReceipt | CollectedByVetID | Collects ▸ (1:N, D3 confirmed) | Yes | No | No (not relied on) | 1 → ∞ correct | D3 confirmed: each receipt names exactly one collecting vet; collector may differ from treating vet |

### 2.1 Composite primary keys (3)

| # | Table | Composite key | Fields in key | Why composite |
|---|---|---|---|---|
| 1 | tblPrescriptionLine | AppointmentID + MedicationID | 2 | One row = one drug on one visit. A single-column key would allow only one drug per visit (or one visit per drug). |
| 2 | tblReceiptAllocation | ReceiptID + AppointmentID | 2 | One row = how much of one receipt settles one visit. A single-column key would block split payments or split allocations. |
| 3 | tblMedicationInteraction | MedicationAID + MedicationBID | 2 | One row = one unordered drug pair. A single-column key would allow the same pair twice or a self-link. |

### 2.2 Table-level validation rule (1)

| # | Table | Validation rule | Validation text | Where to set | Why |
|---|---|---|---|---|---|
| 1 | tblMedicationInteraction | [MedicationAID] < [MedicationBID] | MedicationAID must be strictly less than MedicationBID to prevent self-links and duplicate reverse pairs. | Table Design ▸ Alt+Enter ▸ Table Properties | Keeps the M:N bridge to one row per unordered pair; a field-level rule cannot reference two columns and Access rejects it. |

> Set the rule with **Alt+Enter ▸ Property Sheet ▸ Table Properties**. A field-level rule cannot reference two columns and Access rejects it.

## 3. Attribute trace (Page 2–3 attributes → field or query)

| # | Source | Original attribute / requirement | Stored in / derived by | Kind | Why it sits here | Evidence |
|---|---|---|---|---|---|---|
| 1 | Page 2 | Parent name | tblPetParent.ParentName | Stored | Parent master data stored once; visits reach the parent through the pet | Official |
| 2 | Page 2 | Address | tblPetParent.Address | Stored | Same rationale; no repetition on each visit | Official |
| 3 | Page 2 | Day phone | tblPetParent.DayPhone | Stored | Short Text keeps leading zeros and separators | Official |
| 4 | Page 2 | Evening phone | tblPetParent.EveningPhone | Stored (optional) | Nullable; empty string is not used as a substitute for Null | Official |
| 5 | Page 2 | Pet name | tblPet.PetName | Stored | Pet master data | Official |
| 6 | Page 2 | Breed | tblPet.Breed | Stored | Pet master data (species may be included, e.g. British Shorthair (Cat)) | Official |
| 7 | Page 2 | Color | tblPet.Color | Stored | Pet master data | Official |
| 8 | Page 2 | Birth date | tblPet.BirthDate | Stored | Date/Time with rule <= Date() | Official |
| 9 | Page 2 | Dr. Nottingham and three other veterinarians | tblVeterinarian (VetID, VetName, RoleTitle) | Stored | Internal agent; 2 representative vets sampled under the two-record rule | Official |
| 10 | Page 2 | pet's weight | tblAppointment.WeightKg | Stored | Varies per visit; on tblPet the latest value would overwrite earlier ones (update anomaly) | Official |
| 11 | Page 2 | reason for the appointment | tblAppointment.VisitReason | Stored | Visit-specific attribute | Official |
| 12 | Page 2 | doctor's diagnosis | tblAppointment.Diagnosis | Stored | Visit-specific attribute | Official |
| 13 | Page 3 prose | Parents are charged for each appointment | tblAppointment.AppointmentFee | Stored | Fee field implied by the prose so that Total charge = fee + medicines; not listed as a bullet | Inferred |
| 14 | Page 3 #1 | Number of pets owned by each parent | qry_01_ParentPetCount | Derived | LEFT JOIN + Count(PetID); keeps parents with zero pets and avoids a stale count | Official |
| 15 | Page 3 #2 | Price of each specific medicine prescribed | tblPrescriptionLine.UnitPriceCharged + qry_02_PrescriptionCharges.LineCharge | Stored + derived | Actual unit price at prescription time; line subtotal computed | Official |
| 16 | Page 3 #3 | Total charge for the appointment | qry_03_AppointmentTotal.TotalAppointmentCharge | Derived | AppointmentFee + Nz(TotalMedCharge, 0); storing it would need maintenance on every change | Official |
| 17 | Page 3 #4 | Quantity of each specific medicine prescribed | tblPrescriptionLine.Quantity | Stored | Whole units 1..100000; Double + =Int() rejects 1.5 | Official |
| 18 | Page 3 #5 | Price charged for each medication | tblPrescriptionLine.UnitPriceCharged | Stored | Decoupled from ListPrice so later catalogue changes do not rewrite history | Official |
| 19 | Page 3 #6 | Medication list price | tblMedication.ListPrice | Stored | Current catalogue price only | Official |
| 20 | Page 3 #7 | Medication name | tblMedication.MedicationName | Stored | ID identifies the item; names may repeat | Official |
| 21 | Page 3 #8 | Adverse medication interactions with other medications | tblMedicationInteraction | Stored (M:N bridge) | Undirected pair stored once; AID < BID blocks self-links and (2,1) duplicates | Official |
| 22 | Page 3 #9 | Total cash receipt amount | tblCashReceipt.ReceiptTotal | Stored | Total of one receipt | Official |
| 23 | Page 3 #10 | Appointment date | tblAppointment.AppointmentDate | Stored | Date/Time | Official |
| 24 | Page 3 #11 | Cash receipt amount applied to a specific appointment | tblReceiptAllocation.AppliedAmount | Stored | Allocation row linking one receipt to one visit | Official |
| 25 | Page 3 #12 | Appointment length | tblAppointment.DurationMin | Stored | Whole minutes 1..1440 | Official |

> All 12 Page 3 bullet attributes are covered. `#1 Number of pets` and `#3 Total charge` are derived by queries; `#2 Price` is split into a stored `UnitPriceCharged` and a derived `LineCharge`. `AppointmentFee` is not a bullet on Page 3 — it is inferred from the prose *“Parents are charged for each appointment”*.

## 4. Text schemas and normalization proof

Notation: `_underline_` = primary key, `*italic*` = foreign key, `_*both*_` = composite key that is also a foreign key.

```text
tblPetParent (_ParentID_, ParentName, Address, DayPhone, EveningPhone)
tblPet (_PetID_, *ParentID*, PetName, Breed, Color, BirthDate)
tblVeterinarian (_VetID_, VetName, RoleTitle)
tblAppointment (_AppointmentID_, *PetID*, *VetID*, AppointmentDate, DurationMin, WeightKg, VisitReason, Diagnosis, AppointmentFee)
tblMedication (_MedicationID_, MedicationName, ListPrice)
tblPrescriptionLine (_*AppointmentID*_, _*MedicationID*_, Quantity, UnitPriceCharged)
tblCashAccount (_AccountID_, AccountName, AccountType)
tblCashReceipt (_ReceiptID_, *ParentID*, *AccountID*, *CollectedByVetID*, ReceiptDate, ReceiptTotal)
tblReceiptAllocation (_*ReceiptID*_, _*AppointmentID*_, AppliedAmount)
tblMedicationInteraction (_*MedicationAID*_, _*MedicationBID*_, SeverityLevel, InteractionDescription)
```

### 4.1 Normalization proof (1NF → 2NF → 3NF)

All ten relations are in first normal form: every attribute is atomic and no repeating group remains. The three many-to-many relationships of the conceptual model are resolved into bridge relations — tblPrescriptionLine, tblReceiptAllocation and tblMedicationInteraction — whose keys are (AppointmentID, MedicationID), (ReceiptID, AppointmentID) and (MedicationAID, MedicationBID). Each row therefore holds exactly one value per column.

Second normal form holds because every non-key attribute depends on the whole key. In tblPrescriptionLine, Quantity and UnitPriceCharged describe one appointment together with one medication, not either column alone; AppliedAmount and SeverityLevel/InteractionDescription behave the same way. Relations whose key is a single AutoNumber are trivially in 2NF.

Third normal form holds because no non-key attribute determines another. WeightKg is stored on tblAppointment, not on tblPet: keeping it on the pet would overwrite the weight recorded at earlier visits (update anomaly) and destroy the clinical history. UnitPriceCharged is stored on the prescription line instead of being read from ListPrice, so a catalogue price change cannot rewrite historical charges (update anomaly). NumberOfPets and TotalAppointmentCharge are not stored at all; they are computed by queries, so inserting a pet or a prescription cannot leave a stale total (insertion and update anomalies). Deleting a prescription line removes only that line, never the visit or the medication (deletion anomaly).

### 4.2 Anomalies avoided — one concrete example each

- **Insertion anomaly:** If prescriptions were stored as repeating columns on the visit row, adding a second drug would require duplicating the whole visit. The bridge table adds one row instead.
- **Update anomaly:** If weight lived on tblPet, recording today's weight would erase last visit's weight. Storing WeightKg per appointment keeps every measurement.
- **Deletion anomaly:** If a drug were stored inside the visit row, deleting the drug would delete the visit. Separate relations let either one be removed without the other.

---

*Generated from `Schema_Freeze.xlsx`. If a field, key or relationship changes, update `02`, `technical/spec.json`, the xlsx and this file together.*
