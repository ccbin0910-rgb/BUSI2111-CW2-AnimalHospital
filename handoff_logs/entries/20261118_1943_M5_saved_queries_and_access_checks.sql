INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261118_1943_M5_saved_queries_and_access_checks.sql','2026-11-18T19:43:33+08:00','Win-M5','M5','role/M5-queries','OpenAI Codex','Retrieved pinned inputs, created and ran saved queries via actual Access and DAO, compared outputs to the M4 workbook, and drafted the verification record.',
'Create and verify all 11 saved Access queries on the released M3 baseline copy.',
'Use one source commit for the baseline, SQL and workbook. Preserve the M3 baseline and apply Q01-Q11 in dependency order.',
'810b6031c3f4eef8cb815ee51d8e2cd3ee2adb13 M3 handoff, M4 Seed and Expected, and technical SQL. Baseline SHA-256 5779b94439854514f6b32f3badbf8b132abf8fd22cac35aecf3d000d14974127.',
'None.','workspaces/R5_Queries/v2_R5_Queries.accdb, workspaces/R5_Queries/M5_QUERY_VERIFICATION.md, and this entry.',
'PASS','Access 16.0 and DAO ran all 11 saved queries at creation and after reopening. Results matched 20 workbook checks, all 21 seed rows and 15 ID mappings. A1 charge/applied/balance 205/205/0. A2 90/0/90. Control query rows 0 and 1, history 3. Scope is the released fixture, excluding entry tests, full anomaly scenarios and merged UAT.',
'Currency label pending team confirmation. M6/M7 input tests and final merged UAT are downstream.',
'M3: import all 11 query objects from the R5 deliverable, then rerun the verification checklist in the integrated database. M6: use a separate copy for anomaly scenarios.'
);
