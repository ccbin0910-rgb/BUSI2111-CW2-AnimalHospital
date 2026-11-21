INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261121_1540_M3_manual_merge_plan.sql','2026-11-21T15:40:00+08:00','Win-Lead','M3','role/M3-review','OpenAI Codex','Updated merge responsibilities, pinned inputs, and acceptance sequence.',
'Record that member 3 personally performs final Access integration.',
'Member 8 prepares reports in parallel and independently verifies the same final candidate after member 3 integrates it.',
'810b603 baseline, efc7eb7 M5 delivery, cf861c3 M6 evidence and 752bd68 M7 handoff. SOP sections 4 and 9.',
'None.','R3 M3_Merge_Checklist.md and this entry.','DOCS_ONLY',
'Checked branch state and pinned project sources. This update changes the workflow document only. Final Access integration and UAT remain NOT_RUN.',
'M7 Round 3 receipt, M8 report delivery, official integration and cross-machine UAT pending.',
'Share checklist on M3 branch after approval. M8 can prepare reports, and M3 will merge and release a single candidate.'
);
