-- UNNC Animal Hospital CW2: Multi-Agent Structured Handoff & Audit Log Schema
-- Rebuilt cleanly into local temporary SQLite from append-only handoff_logs/entries/*.sql

CREATE TABLE IF NOT EXISTS agent_handoff_logs (
    log_id              INTEGER PRIMARY KEY AUTOINCREMENT,
    entry_file          TEXT NOT NULL UNIQUE,
    created_at          TEXT NOT NULL,            -- ISO-8601 timestamp, e.g. '2026-11-16T12:05:00+08:00'
    machine_id          TEXT NOT NULL,            -- e.g. 'Win-Lead', 'Mac-M1'
    member_role         TEXT NOT NULL,            -- 'SYS', 'LEAD', 'M1'..'M8'
    branch_or_worktree  TEXT NOT NULL,            -- e.g. 'main', 'role/M5-queries'
    ai_tool             TEXT NOT NULL,            -- e.g. 'Antigravity', 'ChatGPT', 'None'
    ai_usage_scope      TEXT NOT NULL,            -- Concise summary of how AI assisted (for Coversheet disclosure)
    task_summary        TEXT NOT NULL,            -- One-line summary of change
    decision_rationale  TEXT NOT NULL,            -- Concise WHY + alternatives/trade-offs (no verbose CoT)
    evidence_refs       TEXT NOT NULL,            -- Exact files, slides, queries, or command output refs
    assumptions_added   TEXT NOT NULL DEFAULT 'None',
    files_changed       TEXT NOT NULL,            -- Changed files or Access objects
    verification_status TEXT NOT NULL CHECK (
        verification_status IN ('PASS', 'FAIL', 'KNOWN_LIMITATION', 'PARTIAL', 'NOT_RUN', 'DOCS_ONLY')
    ),
    verification_detail TEXT NOT NULL,            -- Exact checks executed AND what remains untested
    blocking_or_open    TEXT NOT NULL DEFAULT 'None', -- D1-D5 or unresolved issues
    next_handoff_note   TEXT NOT NULL             -- Actionable instructions for next teammate / AI
);

CREATE VIEW IF NOT EXISTS v_latest_by_role AS
SELECT
    log_id,
    created_at,
    member_role,
    machine_id,
    branch_or_worktree,
    task_summary,
    verification_status,
    blocking_or_open
FROM agent_handoff_logs
ORDER BY created_at DESC, log_id DESC;

CREATE VIEW IF NOT EXISTS v_open_blockers_and_untested AS
SELECT
    log_id,
    created_at,
    member_role,
    task_summary,
    verification_status,
    verification_detail,
    blocking_or_open
FROM agent_handoff_logs
WHERE verification_status IN ('FAIL', 'NOT_RUN', 'PARTIAL', 'KNOWN_LIMITATION')
   OR blocking_or_open <> 'None'
ORDER BY created_at DESC, log_id DESC;

CREATE VIEW IF NOT EXISTS v_ai_coversheet_ledger AS
SELECT
    member_role,
    machine_id,
    ai_tool,
    ai_usage_scope,
    task_summary,
    created_at
FROM agent_handoff_logs
WHERE ai_tool <> 'None'
ORDER BY created_at ASC, log_id ASC;
