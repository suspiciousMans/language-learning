#!/bin/sh
# Compile, run, and assert that the output contains "toolchain ok".
# Exit 0 on success, 1 on failure.

set -e

cd "$(dirname "$0")"

# Build
make clean >/dev/null 2>&1 || true
make CC="${CC:-gcc}" CFLAGS="${CFLAGS:-}" || {
    echo "BUILD FAILED"
    exit 1
}

# Run and capture output
OUTPUT=$(./toolchain_check 2>&1) || {
    echo "RUN FAILED"
    exit 1
}

# Assert
case "$OUTPUT" in
    *toolchain\ ok*) echo "PASS: got '$OUTPUT'" ;;
    *) echo "FAIL: unexpected output '$OUTPUT'"; exit 1 ;;
esac
