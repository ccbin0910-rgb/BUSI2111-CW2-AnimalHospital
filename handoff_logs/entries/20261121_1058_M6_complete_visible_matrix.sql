INSERT INTO agent_handoff_logs (
    entry_file, created_at, machine_id, member_role, branch_or_worktree, ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs, assumptions_added, files_changed, verification_status, verification_detail, blocking_or_open, next_handoff_note
) VALUES (
    '20261121_1058_M6_complete_visible_matrix.sql',
    '2026-11-21T10:58:23+08:00',
    'Win-Codex-Desktop',
    'M6',
    'role/M6-controls',
    'OpenAI Codex',
    'Assisted visible Windows Access keyboard tests, recovery, read-only baseline comparison, evidence consolidation and SQL ledger validation.',
    'Merge both visible testing runs: all 46 fields have R1/R2 outcomes; preserve engine T01-T22 results and distinguish nine visible supplements from 13 unrun visible scenarios.',
    'Corrects coverage and zero-length-input interpretation in 20261120_1534_M6_visible_datasheet_supplement.sql and supersedes partial coverage/recovery checkpoints in 20261120_1705_M6_visible_access_recovery_partial.sql and 20261120_1713_M6_correct_backup_dialog_status.sql. Historical entries remain unchanged. Microsoft documents two double quotes as Datasheet zero-length entry; all 14 text R2 attempts raised named zero-length rejection. Safe mode plus SubdatasheetName=[None] enabled continuation; crash cause remains a hypothesis.',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; CUA screenshots/accessibility output in conversation (no screenshot files saved); https://support.microsoft.com/en-us/access/ways-to-add-edit-and-delete-records',
    'None. Seeded-row versus new-row method difference is disclosed; no fixed workbook or frozen database schema changes.',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; handoff_logs/entries/20261121_1058_M6_complete_visible_matrix.sql',
    'KNOWN_LIMITATION',
    'Visible R1-R2: 46 fields, 92 unique slots, 92 expected results (91 invalid inputs blocked; optional EveningPhone Null accepted/restored). Nine visible scenario supplements: T01-T06,T12,T19,T20. Engine T01-T20 expected; T21/T22 known limitations. Final read-only UIFlat comparison with clean baseline matched all saved values (10 tables/21 rows), field types/sizes/Required/AllowZeroLength/validation, table validation, relationship names/tables/attributes and 11 query names/SQL. AutoNumber gaps and display settings are outside this equality claim; indexes not compared. Structural evidence checks and both protected-source SHA-256 checks passed. Historical R3 65-check prototype acceptance not rerun. query_logs.py --check --summary validated all 19 entries and rebuilt local summary/cache; git diff --check passed.',
    'Full visible scenarios T07-T11,T13-T18,T21,T22 NOT_RUN. C01-C04 and VBA V01-V09 NOT_RUN. T21 mutable owner history; T22 pre-birth appointment date accepted. D1 fixed-workbook status conflict and its zero-length entry instruction need M3/M4 reconciliation. M7 Round3 remains independent.',
    'M3: review limitations and coordinate M4 workbook corrections; do not merge local test databases. M7: use separate clean fixed input copy for blind Round3 before reading results. Deliver receipt/evidence/log on role/M6-controls using a pinned commit link; user already authorized commit and push.'
);
