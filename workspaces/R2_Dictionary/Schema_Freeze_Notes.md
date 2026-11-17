# Schema_Freeze — sources, decisions and verification boundary

## What this folder contains

| File | Role | Notes |
|---|---|---|
| `Schema_Freeze.xlsx` | The deliverable: four sheets — fields, 12 relationships, attribute trace, 3NF proof | Binary; open in Excel / Access |
| `Schema_Freeze.md` | Text mirror of the same four sections | Diff-able in Git; the 03 SOP allows `.xlsx` **or** `.md`, so both are kept in sync |
| `Schema_Freeze_Notes.md` | This file: sources, frozen decisions, what was checked and what was not | Read this before changing anything |

## Sources (in order of authority)

1. `02_最终版数据库架构蓝图与技术规范.md` §4–§5.1 — the team's single technical standard (10 tables / 46 fields / 12 FKs / 3 composite PKs / 11 queries).
2. `technical/spec.json` — machine-readable twin of the same structure; the workbook was checked against it field by field.
3. `workspaces/R1_REA/REA_Diagram.png`, `workspaces/R1_REA/REA_Diagram.drawio`, `workspaces/R1_REA/REA_Assumptions.md` — member 1's conceptual model. Its ten conceptual relationships expand to exactly the twelve foreign keys listed in sheet 2.
4. `03_八人傻瓜式分工SOP与AI_Prompt手册.md` §3 — member 2's four-sheet requirement and the six common pitfalls.

## Decisions frozen in v1.0

1. **D3 confirmed.** Every cash receipt identifies exactly one collecting veterinarian, so `tblCashReceipt.CollectedByVetID` is a required foreign key and the schema keeps **46 fields / 12 relationships** (not 45/11).
2. **No renames.** Table names, field names, key granularity and validation rules are transcribed from `02`; the dictionary does not invent or rename anything.
3. **Price vocabulary kept separate:** `ListPrice` (catalogue) ≠ `UnitPriceCharged` (charged at prescription) ≠ `LineCharge` (derived) ≠ `AppointmentFee` (visit fee) ≠ `ReceiptTotal` / `AppliedAmount` (cash).
4. **`AppointmentFee` is inferred**, not a Page 3 bullet: it is required by the prose *"Parents are charged for each appointment"* so that *Total charge* closes. Sheet 3 marks it `Inferred`.
5. **`AppointmentDate` carries Format = Short Date but no Validation Rule** — `02` defines none, and inventing one would change the frozen standard.
6. **Four sheets only**, no extra Readme sheet (owner decision); this notes file carries the metadata instead.

## What was checked

- Reopened the saved workbook with `openpyxl`: 4 sheets, **46** field rows in `spec.json` order, with type / size / required identical; **12** FK pairs identical to `spec.json`.
- No cell begins with `=` (so no rule was silently turned into a formula); no overlapping merged ranges.
- Sheet 4 keeps real rich text: `<u val="single"/>` for primary keys and `<i val="1"/>` for foreign keys.

## What was NOT checked

- **Not compared cell-by-cell with the Access base library** (`v1_Core_Seeded.accdb`), which member 3 builds on 11-20. That comparison is the acceptance test for this document.
- **Not opened in Excel**; the visual layout (row heights, print scaling) has not been reviewed by eye.
- **D1 is still open**: if the group adds a discriminator column to `tblMedicationInteraction` (to have two interaction rows with only two medications), the field count becomes 47 and the composite key becomes three columns — this document must then be revised.

## How to use it

- **Member 3 (build):** create the ten tables from sheet 1; set `tblMedicationInteraction`'s rule via `Alt+Enter ▸ Table Properties`; then diff the finished database against this file.
- **Member 7 (audit):** check 46 fields, 3 composite keys and 12 FK directions against sheet 2; the `Direction` column states the expected `1 → ∞`.
- **Anyone changing a field:** update `02`, `technical/spec.json`, the xlsx and the md together — the four files are one source of truth.

## Version

| Version | Date | Change |
|---|---|---|
| v1.0 | 2026-11-17 | Initial freeze under the confirmed D3; four sheets; checked against `spec.json` |
