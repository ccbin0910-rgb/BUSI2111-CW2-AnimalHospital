INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261122_1712_M8_group3_candidate.sql','2026-11-22T17:12:00+08:00','Win-M8','M8','role/M8-reports','OpenAI Codex',
'Access COM and DAO naming, compact and reopen, and report preview verification.',
'Create the named Group 3 candidate and record CNY.',
'Group 3 confirmed by M8 from Moodle and CNY adopted from M4 sample records.',
'M8_Integration_Precheck.md; AF22A4B58809B5C29EB51993DA368F9EFB4930723F6A8DEBB4459AC231E2DD28.',
'None.',
'Group3_animalhospital.accdb and M8_Integration_Precheck.md.',
'PARTIAL',
'Reopened named compact copy, verified 10 tables, 46 descriptions, 21 samples, 12 relationships, 11 queries and three single-page previews. Relationship title matches and REA image remains embedded.',
'Some relationship labels truncate. Current candidate Documenter and M7 cross-machine UAT remain pending.',
'Recheck relationship layout and export Documenter, then use the same final hash for M7 verification.'
);
