# 00 — Tooling Check

## Goals

Verify that your Python toolchain is set up correctly before starting the learning path. This project has no learning content — it's a confidence check.

## Concepts

- Python interpreter (`python3 --version`)
- Running a script from the command line
- Running tests with `pytest`
- Virtual environments (optional but recommended)

## Completion Checklist

- [ ] `python3 --version` prints 3.11 or higher
- [ ] `python3 projects/00-tooling-check/main.py` prints `toolchain ok`
- [ ] `pytest projects/00-tooling-check/test_main.py -v` passes (one test, green)

## Files

- `main.py` — the script to run
- `test_main.py` — the test that asserts the output
