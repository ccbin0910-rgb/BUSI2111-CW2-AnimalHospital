INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261122_1727_M8_fix_relationship_labels.sql','2026-11-22T17:27:00+08:00','Win-M8','M8','role/M8-reports','OpenAI Codex',
'Access COM report layout changes, compact and reopen, and render inspection.',
'Fix cropped relationship report labels on a separate candidate copy.',
'Keep the relationships on one landscape page and show the full database title, long table and field names.',
'M8_Integration_Precheck.md; prior candidate 2503c06; SHA256 02A835410FEDDE73D6762BAAF194B3FFAFFE3B35627DFA62360A8078D48F8676.',
'None.','Group3_animalhospital.accdb; M8_Integration_Precheck.md.','PARTIAL',
'Verified previously clipped labels on the rendered report, then compacted and reopened the candidate and opened 11 queries and all three reports.',
'Native Documenter export and M7 cross-machine acceptance remain pending.',
'Provide the revised fixed link and hash for independent acceptance once published.'
);
