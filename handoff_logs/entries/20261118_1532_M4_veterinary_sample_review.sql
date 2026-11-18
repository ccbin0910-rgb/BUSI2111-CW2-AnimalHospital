INSERT INTO agent_handoff_logs (
    entry_file, created_at, machine_id, member_role, branch_or_worktree, ai_tool, ai_usage_scope, task_summary, decision_rationale, evidence_refs, assumptions_added, files_changed, verification_status, verification_detail, blocking_or_open, next_handoff_note
) VALUES (
    '20261118_1532_M4_veterinary_sample_review.sql',
    '2026-11-18T15:32:22+08:00',
    'Mac-Codex',
    'M4',
    'local-review',
    'OpenAI Codex',
    'Reviewed veterinary references and revised the workbook sample narrative and interaction labels. Ran local workbook and arithmetic verification.',
    'Revise M4 review fixture for clinically plausible fictional feline cases and source-supported interaction examples.',
    'Updates 20261118_1527_M4_sample_data_review.sql. Replace invented drug rules with documented oral absorption interactions. Keep the original seed structure, keys, counts, prices and allocations. Retain one interaction warning in the main case.',
    '02 blueprint sections 4–7; ABCD Chlamydia felis guideline; feline acute vomiting clinical review (PMC10829162); ACVIM GI protectants consensus statement; European Commission Veraflox product information section 4.8.',
    'Fictional cat with PCR-confirmed C. felis conjunctivitis and previously diagnosed reflux esophagitis. Billed dispensing packs and prices are illustrative. SeverityLevel is a coursework category.',
    'workspaces/R4_SampleData/Sample_Data_Master.xlsx; handoff_logs/entries/20261118_1532_M4_veterinary_sample_review.sql',
    'DOCS_ONLY',
    'Checked new medication names, interaction descriptions, matrix baselines and reference URLs in exported xlsx. Revalidated 21 seed rows, 15 ID slots, 46 fields, 138 matrix entries, T07–T20, 11 query baselines and numerical scenarios via portable checks. Microsoft Access remains NOT_RUN.',
    'D1, currency confirmation and actual Access IDs still pending. User review pending.',
    'After user review, M3 should use the revised workbook clinical seed values. M5 should expect the doxycycline–sucralfate pair in the single warning and M6/M7 still perform the designated Access tests.'
);
