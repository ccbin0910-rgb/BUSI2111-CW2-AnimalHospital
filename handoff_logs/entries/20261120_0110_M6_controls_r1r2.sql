INSERT INTO agent_handoff_logs (
entry_file,created_at,machine_id,member_role,branch_or_worktree,ai_tool,ai_usage_scope,task_summary,decision_rationale,evidence_refs,assumptions_added,files_changed,verification_status,verification_detail,blocking_or_open,next_handoff_note
) VALUES (
'20261120_0110_M6_controls_r1r2.sql','2026-11-20T01:10:26+08:00','Win-Desktop-Codex','M6','role/M6-controls','OpenAI Codex',
'OpenAI Codex assisted Access COM/DAO test automation, evidence capture and report/log drafting. Results were captured from Microsoft Access 16.0. The visible Datasheet workflow was not verified.',
'Completed the M6 Round 1–2 field matrix and T01–T22 on an isolated Access test copy.',
'Fixed inputs were verified by SHA-256; each scenario was reset from the clean baseline. Access 16.0 COM/DAO exercised table rules, referential integrity and saved queries. Overall status is PARTIAL because visible Datasheet typing, keyboard actions and dialogs were not validated; T21/T22 are confirmed known limitations.',
'workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; fixed input snapshots and hashes in the report; local-only workspaces/R6_ControlTestLog/R6_Round1-2_Test.accdb',
'D3 CollectedByVetID required treated as confirmed per M1/M2 handoff; no new schema assumptions.',
'workspaces/R6_ControlTestLog/Inputs/v1_Core_Seeded.accdb; workspaces/R6_ControlTestLog/Inputs/Sample_Data_Master.xlsx; workspaces/R6_ControlTestLog/Inputs/v2_R5_Queries.accdb; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2.md; workspaces/R6_ControlTestLog/Control_Test_Log_R1R2_Evidence.json; local-only R6_Round1-2_Test.accdb and Clean_Baseline.accdb; this SQL entry.',
'PARTIAL',
'Microsoft Access 16.0 via COM/DAO: imported 11 saved M5 queries; confirmed baseline balances A1=0 and A2=90, invalid allocations=0 and drug interaction warnings=1; 92/92 R1/R2 cases matched expected outcomes; T01–T20 subcases matched expected results; T21 and T22 reproduced and are marked KNOWN_LIMITATION; test copy was reset and left clean. The handoff_logs query_logs.py --check --summary validator was run after appending this entry. Not verified: visible Datasheet input, keyboard/paste behavior or error dialogs; Round 3 and relationship direction audit remain M7 scope.',
'Visible Datasheet workflow untested; T21 owner history and T22 cross-table date are known limitations; D1 status conflicts between the 2026-11-18 M3 handoff and fixed M4 workbook; Round 3 and 12 relationship directions pending M7.',
'M3: reconcile D1 against the lecturer decision and fixed workbook status. M7: use the fixed base and query inputs to make a separate clean copy, run the Round 3 blind field matrix and independently verify all 12 relationship directions. Do not merge the M6 test database.'
);
