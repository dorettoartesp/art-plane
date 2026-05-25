#!/usr/bin/env python3
"""Minimal repository-local validation for AGENTS/OpenAI-style skill files."""

from __future__ import annotations

import re
import sys
from pathlib import Path


REQUIRED_FIELDS = ("name", "description")


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: validate_skill.py <skill-dir>", file=sys.stderr)
        return 2

    skill_dir = Path(sys.argv[1])
    skill_file = skill_dir / "SKILL.md"
    if not skill_file.is_file():
        print(f"missing skill file: {skill_file}", file=sys.stderr)
        return 1

    content = skill_file.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        print("skill must start with YAML front matter", file=sys.stderr)
        return 1

    try:
        _, front_matter, body = content.split("---", 2)
    except ValueError:
        print("skill front matter must be closed with ---", file=sys.stderr)
        return 1

    for field in REQUIRED_FIELDS:
        if not re.search(rf"^{field}:\s*\S", front_matter, re.MULTILINE):
            print(f"missing required front matter field: {field}", file=sys.stderr)
            return 1

    description = re.search(r"^description:\s*(.+)$", front_matter, re.MULTILINE)
    if description and len(description.group(1).strip()) > 1024:
        print("description is too long", file=sys.stderr)
        return 1

    if not body.strip():
        print("skill body is empty", file=sys.stderr)
        return 1

    print(f"Valid skill: {skill_file}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
