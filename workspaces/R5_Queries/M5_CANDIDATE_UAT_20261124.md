# M5 candidate database retest

**Status: PARTIAL.** The pinned M8 candidate runs locally in Access 16.0 and passed the checks below. This is a local retest, not cross-machine acceptance or final submission sign-off.

## Tested input and method

- Candidate: [`Group3_animalhospital.accdb`](https://github.com/ccbin0910-rgb/BUSI2111-CW2-AnimalHospital/blob/34b55876813de7dad6f653ced3c42b2884c8144b/workspaces/R8_Reports_UAT/Group3_animalhospital.accdb) from M8 commit `34b55876813de7dad6f653ced3c42b2884c8144b` on `role/M8-reports`.
- Candidate SHA-256: `02A835410FEDDE73D6762BAAF194B3FFAFFE3B35627DFA62360A8078D48F8676` (1,060,864 bytes). A fresh export from the pinned Git object matched this digest before testing.
- Environment: Microsoft Access 16.0.20430.20182, Windows, DAO via Access COM.
- All changes and query runs were performed on disposable copies. Transactional behavior tests were rolled back. The pinned Git object was not modified.

## Structure and query results

DAO reopened the candidate copy and found 10 tables, 46 fields, 46 non-empty field descriptions, 21 sample rows, 12 relationships, 11 saved queries, and 3 reports. All 11 queries opened and returned the expected row counts.

| Query | Rows |
|---|---:|
| `qry_00_AppointmentOwner` | 2 |
| `qry_01_ParentPetCount` | 2 |
| `qry_02_PrescriptionCharges` | 2 |
| `qry_02b_AppointmentMedSummary` | 1 |
| `qry_02c_AppointmentPaidSummary` | 1 |
| `qry_03_AppointmentTotal` | 2 |
| `qry_04_AppointmentBalance` | 2 |
| `qry_05_ReceiptReconciliation` | 2 |
| `qry_Ctrl_InvalidAllocations` | 0 |
| `qry_Ctrl_DrugInteractionWarnings` | 1 |
| `qry_06_PetMedicalHistory` | 3 |

Financial outputs matched the seed expectations: A1 total / paid / balance = `205 / 205 / 0`; A2 = `90 / 0 / 90`; medicine charges = `85`; both receipts reconcile to `0` unapplied; pet counts are Emily `2` and David `0`.

## Behavior checks

- Nonexistent foreign key rejected by referential integrity.
- Negative appointment fee rejected by its validation rule.
- Fractional prescription quantity rejected by its whole-unit rule.
- A valid A1 fee change from `120` to `130` flowed through `qry_03_AppointmentTotal` to `215`; rollback restored the baseline `205`.
- Changing a receipt owner inside a test transaction made `qry_Ctrl_InvalidAllocations` return one `Cross-Parent Allocation` row.
- Raising the R1 allocation to `110` made the control query return `Receipt Over-Allocated` and `Appointment Over-Paid` rows.
- After rollback, the database returned to 10 tables, 46 fields, 46 descriptions, 21 rows, 12 relationships, and 11 queries.

## Report export and visual review

Access exported each report to a one-page PDF. Page renders and the PDFs are preserved under [`Evidence/UAT_20261124`](Evidence/UAT_20261124/).

| Report | Export | Visual result |
|---|---|---|
| `rpt_00_Relationships_Report` | 1 page, 26,351 bytes | All table names and long field names are present. At page-fit size the text is very small and the page has substantial unused space; improve sizing before treating the report as presentation-ready. |
| `rpt_01_REA_Diagram` | 1 page, 160,403 bytes | Embedded diagram, relationships, arrows, and legend render fully without visible clipping. |
| `rpt_02_System_Design_Notes` | 1 page, 75,445 bytes | All six sections render without visible clipping. T21/T22 and pending cross-machine acceptance are disclosed. |

## Remaining verification

- M7 cross-machine/offline acceptance on this same candidate SHA-256 remains unverified.
- The current candidate has no newly exported Database Documenter PDF; the archived PDF points to an older database. The M8 report records that Access Disabled Mode blocked the native export.
- This retest used the candidate's 3-medication sample. No lecturer response file is attached to the repository to resolve the original “two records” wording against that sample count; M3's handoff says the lecturer confirmed the team's interpretation.
- Moodle upload, download, and reopen were not performed.
- A read-only remote ref check before publication confirmed `role/M8-reports` still points to the tested commit `34b5587`; no newer candidate commit was present.
