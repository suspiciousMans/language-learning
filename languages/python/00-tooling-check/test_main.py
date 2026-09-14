#!/usr/bin/env python3
"""Tests for the tooling-check main.py."""

from pathlib import Path
import subprocess
import sys


def test_main_prints_toolchain_ok():
    # test_main.py lives inside projects/00-tooling-check/.
    # The repo root is two levels up; main.py is in the same folder as this test.
    test_dir = Path(__file__).resolve().parent
    main_path = test_dir / "main.py"
    result = subprocess.run(
        [sys.executable, str(main_path)],
        capture_output=True,
        text=True,
        check=True,
    )
    assert result.stdout.strip() == "toolchain ok"
