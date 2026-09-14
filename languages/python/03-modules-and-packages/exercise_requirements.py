#!/usr/bin/env python3
"""Exercise: parse requirements.txt and print package names.

Reads `requirements.txt` (in the same directory), ignores comments and
blank lines, and prints the package names (everything before any version
specifier).
"""

from pathlib import Path
import re


def parse_requirements(path: Path) -> list[str]:
    """Parse a requirements.txt and return package names (no versions).

    Lines starting with # or - are ignored. Blank lines are ignored.
    Lines with environment markers (e.g. `pkg; python_version >= '3.8'`)
    keep only the package name before the first semicolon or version spec.
    """
    packages = []
    for line in path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#") or line.startswith("-"):
            continue
        # Strip inline comments
        if "#" in line:
            line = line.split("#")[0].strip()
        # Remove version specifiers and environment markers
        name = re.split(r"[><=!~;]", line)[0].strip()
        if name:
            packages.append(name)
    return packages


if __name__ == "__main__":
    req_path = Path(__file__).resolve().parent / "requirements.txt"
    for pkg in parse_requirements(req_path):
        print(pkg)
