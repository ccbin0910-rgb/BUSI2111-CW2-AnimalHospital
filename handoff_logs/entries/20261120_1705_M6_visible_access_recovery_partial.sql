INSERT INTO agent_handoff_logs (
    entry_file, created_at, machine_id, member_role, branch_or_worktree,
    ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs,
    assumptions_added, files_changed, verification_status, verification_detail,
    blocking_or_open, next_handoff_note
) VALUES (
    '20261120_1705_M6_visible_access_recovery_partial.sql',
    '2026-11-20T17:05:45+08:00',
    'Win-Codex-Desktop',
    'M6',
    'role/M6-controls',
    'OpenAI Codex',
    'Assisted with visible Access Datasheet View attempts, evidence documentation, and append-only SQL handoff logging.',
    'Extended visible Access evidence on tblAppointment and recorded the current CUA recovery failure during tblCashAccount opening.',
    'The UI matrix remains PARTIAL because only observed, reproducible Datasheet results count. CUA lost the target database window after the table-switch attempt, so remaining fields cannot be credited as tested.',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; CUA: Accessibility state unavailable for window 5837828; refreshed inventory showed database window minimized; binding window 12715224 showed Database Backup As dialog.',
    'None',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; handoff_logs/entries/20261120_1705_M6_visible_access_recovery_partial.sql',
    'PARTIAL',
    'Visible UI interactions cover 14 of 46 fields across tblPetParent and tblAppointment. Appointment edits were visibly restored with Ctrl+Z; no post-supplement DAO restoration query was run. The current CUA recovery attempt did not reach a visible Datasheet result. The 32 other fields and visible T01-T22 replay remain unrun; ZLS entry remains unexpressed in Datasheet View.',
    'CUA state capture unavailable for window 5837828; the refreshed Access database window was minimized and the other current binding showed Database Backup As. The dialog was canceled; no backup was saved.',
    'Resume from the isolated R6_Round1-2_Test.accdb only after Access exposes a targetable Datasheet View window. Continue every NOT_RUN field in the report matrix with two visible rounds where expressible, record outcomes and restoration evidence, then run python -X utf8 handoff_logs/query_logs.py --check --summary. Do not claim the interface matrix complete until the remaining visible fields and UI scenarios have been observed.'
);
