INSERT INTO agent_handoff_logs (
    entry_file, created_at, machine_id, member_role, branch_or_worktree,
    ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs,
    assumptions_added, files_changed, verification_status, verification_detail,
    blocking_or_open, next_handoff_note
) VALUES (
    '20261120_1713_M6_correct_backup_dialog_status.sql',
    '2026-11-20T17:13:18+08:00',
    'Win-Codex-Desktop',
    'M6',
    'role/M6-controls',
    'OpenAI Codex',
    'Assisted with correcting the Access recovery evidence and append-only SQL handoff log.',
    'Corrects the dialog state recorded by 20261120_1705_M6_visible_access_recovery_partial.sql: an earlier dialog was canceled, but the final Database Backup As dialog remained open at the last observation.',
    'The final observed Access accessibility tree for window 12715224 showed Database Backup As with Save and Cancel controls. No Save action was observed. Preserve the final state as open; do not infer that a backup was created.',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; supersedes the dialog-state wording in handoff_logs/entries/20261120_1705_M6_visible_access_recovery_partial.sql without modifying that append-only entry.',
    'None',
    'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; handoff_logs/entries/20261120_1713_M6_correct_backup_dialog_status.sql',
    'PARTIAL',
    'Corrected report and evidence JSON now distinguish the earlier canceled dialog from the final dialog, which remained open; no backup was created. Visible UI matrix remains 14 of 46 fields and the remainder is not tested.',
    'CUA cannot target the minimized database window; the final Access binding shows Database Backup As still open. Remaining 32 fields and visible T01-T22 replay are unrun.',
    'After Access is restored to a targetable window, continue the visible matrix in the isolated test copy. The earlier SQL entry is append-only; this correction references it and must remain a separate entry. Re-run python -X utf8 handoff_logs/query_logs.py --check --summary after this append.'
);
