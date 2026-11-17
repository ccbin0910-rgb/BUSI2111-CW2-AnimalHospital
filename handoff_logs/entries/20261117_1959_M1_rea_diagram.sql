INSERT INTO agent_handoff_logs (
 entry_file, created_at, machine_id, member_role, branch_or_worktree,
 ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs,
 assumptions_added, files_changed, verification_status, verification_detail,
 blocking_or_open, next_handoff_note
) VALUES (
 '20261117_1959_M1_rea_diagram.sql', '2026-11-17T19:59:00+08:00', 'Mac-M1', 'M1', 'main',
 'OpenAI Codex', 'Generated the editable REA diagram, PNG, English assumptions and this handoff record.',
 'Deliver the M1 conceptual REA diagram and record the group decision on receipt collection.',
 'The group confirmed D3: each receipt must identify one collecting veterinarian.',
 'Group confirmation via M1; 02 database blueprint, section 2; 03 team SOP, member 1.',
 'One collecting veterinarian per receipt; a veterinarian may collect zero or many receipts.',
 'workspaces/R1_REA/REA_Diagram.drawio; workspaces/R1_REA/REA_Diagram.png; workspaces/R1_REA/REA_Assumptions.md; handoff_logs/entries/20261117_1959_M1_rea_diagram.sql',
 'DOCS_ONLY', 'Checked the diagram XML and PNG. No Access implementation or test is claimed.',
 'None', 'M2/M3: retain required CollectedByVetID. M8: embed the PNG and verify the final report in Access.'
);
