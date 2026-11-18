INSERT INTO agent_handoff_logs (
    entry_file, created_at, machine_id, member_role, branch_or_worktree, ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs, assumptions_added, files_changed, verification_status, verification_detail, blocking_or_open, next_handoff_note
) VALUES (
    '20261118_1527_M4_sample_data_review.sql',
    '2026-11-18T15:27:13+08:00',
    'Mac-Codex',
    'M4',
    'local-review',
    'OpenAI Codex',
    'Reviewed repository sources and authored the four-sheet Member 4 review workbook, workbook checks and this SQL record. No Access execution.',
    'Prepare M4 sample data, 11-query expected baseline, 46-field three-round matrix and T07–T20 for user review.',
    'Retain the R4 blueprint and M2 frozen schema. Keep the proposed third medication and second pair provisional under D1. Use separately isolated setup and changes for the three allocation exception cases.',
    'AGENTS.md; 00 project overview; 02 sections 4–7; 03 sections 5 and 7; 04 verification record; 05 course alignment; technical/spec.json; M2 Schema_Freeze.md; M1 and M2 SQL handoff records; origin/main 5f052f6.',
    'CNY is a working display assumption pending team confirmation. Access-generated numeric IDs are to be entered only after the actual seed is installed.',
    'workspaces/R4_SampleData/Sample_Data_Master.xlsx; handoff_logs/entries/20261118_1527_M4_sample_data_review.sql',
    'DOCS_ONLY',
    'Reopened and inspected the xlsx. Verified 21 seed rows, 15 blank AutoNumber mapping slots, 46 fields with 138 round entries and T07–T20. Matched field names/types/sizes/Required to the M2 mirror and spec. Archived query text adapted to SQLite for numeric cross-check of 11 baseline queries and T07–T11/T13–T17. Access data entry, native query execution and Excel native review remain NOT_RUN.',
    'D1 and currency confirmation open. Actual IDs and Access evidence pending. M1/M2 confirmed D3; older overview and blueprint narrative still show it as open. Awaiting user review.',
    'M3 records actual Access-generated IDs, M5 compares query outputs and M6/M7 perform designated tests on clean copies after review. AI assistance is recorded for course disclosure.'
);
