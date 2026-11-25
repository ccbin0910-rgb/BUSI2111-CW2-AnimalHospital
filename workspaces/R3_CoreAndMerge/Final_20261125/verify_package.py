"""Check the pinned CW2 deliverables and recorded local acceptance results."""
from pathlib import Path
import hashlib
import json


ROOT = Path(__file__).resolve().parent


def main():
    manifest = json.loads((ROOT / "Submission_Manifest.json").read_text(encoding="utf-8"))
    for name, expected in manifest.items():
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        if actual != expected:
            raise ValueError(f"File digest differs: {name}")
    expected_database = manifest["Group3_animalhospital.accdb"]
    acceptance = json.loads((ROOT / "Local_Final_Acceptance.json").read_text(encoding="utf-8"))
    controls = json.loads((ROOT / "T_Scenarios_Final.json").read_text(encoding="utf-8"))
    for evidence in (acceptance, controls):
        if evidence["source_sha256"] != expected_database:
            raise ValueError("Evidence targets a different database")
    if len(acceptance["checks"]) != 21 or any(c["status"] != "PASS" for c in acceptance["checks"]):
        raise ValueError("Local acceptance checks are incomplete or failed")
    if len(controls["tests"]) != 42:
        raise ValueError("Control regression evidence is incomplete")
    limits = [c for c in controls["tests"] if c["status"] == "KNOWN_LIMITATION"]
    if len(limits) != 2 or any(c["status"] not in ("PASS", "KNOWN_LIMITATION") for c in controls["tests"]):
        raise ValueError("Unexpected control regression status")
    pages = json.loads((ROOT / "PDF_Text_Verification.json").read_text(encoding="utf-8"))
    if len(pages) != 11 or not all(p["text_matches_after_removing_terminal_glyph"] for p in pages):
        raise ValueError("PDF text comparison is incomplete")
    correction = json.loads((ROOT / "PDF_Correction.json").read_text(encoding="utf-8"))
    if correction["pdf_sha256"] != manifest["Group3_Table_Definitions_Final.pdf"]:
        raise ValueError("PDF correction evidence targets another file")
    repo = ROOT.parents[2]
    protected = json.loads((repo / "revision_manifest.json").read_text(encoding="utf-8-sig"))["protected_sources"]
    for name, expected in protected.items():
        if hashlib.sha256((repo / name).read_bytes()).hexdigest() != expected:
            raise ValueError(f"Protected source changed: {name}")
    print("Package digests, recorded 21 local checks, 42 control checks, 11 PDF pages and protected sources verified.")
    print("Known limits remain T21/T22. This check does not perform UI or second-machine acceptance.")


if __name__ == "__main__":
    main()
