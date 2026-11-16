#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Rebuild, validate, summarize, and query CW2 append-only SQL handoff logs."""

import argparse
import re
import sqlite3
import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent
SCHEMA_FILE = BASE_DIR / "schema.sql"
ENTRIES_DIR = BASE_DIR / "entries"
CACHE_DB = BASE_DIR / "handoff_cache.sqlite3"
SUMMARY_MD = BASE_DIR / "LOG_SUMMARY.md"

REQUIRED_NON_EMPTY = (
    "entry_file",
    "created_at",
    "machine_id",
    "member_role",
    "branch_or_worktree",
    "ai_tool",
    "ai_usage_scope",
    "task_summary",
    "decision_rationale",
    "evidence_refs",
    "files_changed",
    "verification_status",
    "verification_detail",
    "next_handoff_note",
)


ALLOWED_ENTRY_ACTIONS = {
    sqlite3.SQLITE_INSERT,
    sqlite3.SQLITE_READ,
    sqlite3.SQLITE_SELECT,
    sqlite3.SQLITE_FUNCTION,
}


def entry_authorizer(action, arg1, arg2, db_name, trigger_name):
    if action == sqlite3.SQLITE_INSERT and arg1 != "agent_handoff_logs":
        return sqlite3.SQLITE_DENY
    if action in ALLOWED_ENTRY_ACTIONS:
        return sqlite3.SQLITE_OK
    return sqlite3.SQLITE_DENY


def readonly_authorizer(action, arg1, arg2, db_name, trigger_name):
    if action in {sqlite3.SQLITE_SELECT, sqlite3.SQLITE_READ, sqlite3.SQLITE_FUNCTION}:
        return sqlite3.SQLITE_OK
    return sqlite3.SQLITE_DENY


def build_db(persist_cache: bool) -> tuple[sqlite3.Connection, list[Path]]:
    conn = sqlite3.connect(":memory:")
    schema_sql = SCHEMA_FILE.read_text(encoding="utf-8-sig")
    conn.executescript(schema_sql)

    entries = sorted(ENTRIES_DIR.glob("*.sql")) if ENTRIES_DIR.exists() else []
    seen_before = 0
    conn.set_authorizer(entry_authorizer)
    try:
        for entry in entries:
            sql_text = entry.read_text(encoding="utf-8-sig").strip()
            if not sql_text:
                raise ValueError(f"Empty SQL log file: {entry.name}")
            if not re.search(r"(?is)^\s*(?:--[^\n]*\n\s*)*INSERT\s+INTO\s+agent_handoff_logs\b", sql_text):
                raise ValueError(f"{entry.name}: must begin with an INSERT INTO agent_handoff_logs statement")

            try:
                conn.executescript(sql_text)
            except sqlite3.Error as exc:
                raise ValueError(f"{entry.name}: SQLite execution/authorization error: {exc}") from exc

            total_now = conn.execute("SELECT COUNT(*) FROM agent_handoff_logs").fetchone()[0]
            if total_now != seen_before + 1:
                raise ValueError(f"{entry.name}: expected exactly 1 inserted row, got {total_now - seen_before}")
            seen_before = total_now

            row = conn.execute(
                "SELECT * FROM agent_handoff_logs WHERE log_id = (SELECT MAX(log_id) FROM agent_handoff_logs)"
            ).fetchone()
            col_names = [d[0] for d in conn.execute("SELECT * FROM agent_handoff_logs LIMIT 0").description]
            rec = dict(zip(col_names, row))
            if rec["entry_file"] != entry.name:
                raise ValueError(f"{entry.name}: entry_file column '{rec['entry_file']}' does not match filename")
            for col in REQUIRED_NON_EMPTY:
                val = str(rec[col] or "").strip()
                if not val:
                    raise ValueError(f"{entry.name}: required field '{col}' is empty")
    finally:
        conn.set_authorizer(None)

    if persist_cache:
        tmp_db = CACHE_DB.with_suffix(".tmp.sqlite3")
        if tmp_db.exists():
            tmp_db.unlink()
        disk_conn = sqlite3.connect(tmp_db)
        conn.backup(disk_conn)
        disk_conn.close()
        tmp_db.replace(CACHE_DB)

    return conn, entries


def format_table(headers: list[str], rows: list[tuple]) -> str:
    if not rows:
        return "(0 rows)"
    widths = [len(str(h)) for h in headers]
    str_rows = []
    for r in rows:
        sr = [str(c).replace("\r\n", " ").replace("\n", " ") for c in r]
        str_rows.append(sr)
        for i, v in enumerate(sr):
            widths[i] = max(widths[i], min(len(v), 70))

    def cut(s: str, w: int) -> str:
        return s if len(s) <= w else s[: max(0, w - 3)] + "..."

    line_fmt = " | ".join(f"{{:<{w}}}" for w in widths)
    sep = "-+-".join("-" * w for w in widths)
    out = [line_fmt.format(*(cut(str(h), w) for h, w in zip(headers, widths))), sep]
    for sr in str_rows:
        out.append(line_fmt.format(*(cut(v, w) for v, w in zip(sr, widths))))
    return "\n".join(out)


def write_summary_md(conn: sqlite3.Connection) -> None:
    cols = [
        "log_id",
        "created_at",
        "member_role",
        "machine_id",
        "branch_or_worktree",
        "task_summary",
        "verification_status",
        "blocking_or_open",
        "next_handoff_note",
    ]
    rows = conn.execute(
        f"SELECT {', '.join(cols)} FROM agent_handoff_logs ORDER BY created_at DESC, log_id DESC"
    ).fetchall()
    ai_rows = conn.execute(
        "SELECT member_role, ai_tool, ai_usage_scope, created_at FROM v_ai_coversheet_ledger"
    ).fetchall()

    md = [
        "# Multi-Agent Handoff & Verification Log Summary (Generated Locally)",
        "",
        "> Auto-generated by `python -X utf8 handoff_logs/query_logs.py --summary` from `handoff_logs/entries/*.sql`. Do not edit manually; ignore in Git to prevent merge conflicts.",
        "",
        f"Total entries indexed: **{len(rows)}**",
        "",
        "## Recent Entries (Newest First)",
        "",
        "| ID | Time | Role | Machine | Branch/WT | Summary | Status | Open Blockers | Next Handoff |",
        "|---:|---|---|---|---|---|---|---|---|",
    ]
    for r in rows:
        escaped = [str(c).replace("\r\n", " ").replace("\n", " ").replace("|", "\\|") for c in r]
        md.append("| " + " | ".join(escaped) + " |")

    md.extend(
        [
            "",
            "## AI Usage Ledger (For Coversheet Transparency)",
            "",
            "| Role | AI Tool | Usage Scope | Timestamp |",
            "|---|---|---|---|",
        ]
    )
    for r in ai_rows:
        escaped = [str(c).replace("\r\n", " ").replace("\n", " ").replace("|", "\\|") for c in r]
        md.append("| " + " | ".join(escaped) + " |")

    SUMMARY_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate and query CW2 append-only SQL handoff logs.")
    parser.add_argument("--check", action="store_true", help="Validate schema and all entries/*.sql files")
    parser.add_argument("--summary", action="store_true", help="Rebuild local SQLite cache and LOG_SUMMARY.md")
    parser.add_argument("--sql", type=str, help="Run a custom SQL SELECT query against the compiled logs")
    args = parser.parse_args()

    if not (args.check or args.summary or args.sql):
        args.check = True
        args.summary = True

    conn, entries = build_db(persist_cache=args.summary or bool(args.sql))
    if args.check:
        print(f"[OK] Validated {len(entries)} SQL handoff log entries against {SCHEMA_FILE.name}.")
    if args.summary:
        write_summary_md(conn)
        print(f"[OK] Updated {CACHE_DB.name} and {SUMMARY_MD.name}.")
    if args.sql:
        conn.set_authorizer(readonly_authorizer)
        try:
            cur = conn.execute(args.sql)
            headers = [d[0] for d in cur.description] if cur.description else []
            rows = cur.fetchall()
            print(format_table(headers, rows))
        finally:
            conn.set_authorizer(None)
    return 0


if __name__ == "__main__":
    sys.exit(main())
