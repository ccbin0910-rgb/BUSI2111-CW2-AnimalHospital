INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261122_1704_M8_integration_precheck.sql','2026-11-22T17:04:00+08:00','Win-M8','M8','role/M8-reports','OpenAI Codex',
'Access COM and DAO integration, native Relationships UI, compact and reopen, print preview and baseline comparison.',
'Accept M1 integration handoff and prepare a local precheck copy.',
'Use pinned accepted inputs and preserve original files.',
'M8_Integration_Precheck.md; M1 7922f90; M3 810b603; M5 efc7eb7; M8 785f490.',
'Group number and currency are pending.',
'M8_Integrated_Precheck.accdb and M8_Integration_Precheck.md.',
'PARTIAL',
'After compaction and reopen verified full seed values, field metadata, PK and relationships against the pinned baseline, executed 11 queries and previewed three reports. Native relationship report layout adjusted to one landscape page in a separate draft copy.',
'Final title and label layout, current candidate Documenter, naming and M7 cross-machine UAT remain pending. T21 and T22 remain KNOWN_LIMITATION.',
'Confirm naming inputs, validate the release copy, then hand its closed-file hash to M7 for UAT.'
);
