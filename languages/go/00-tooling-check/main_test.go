package main

import (
	"os/exec"
	"testing"
)

func TestPrintsToolchainOk(t *testing.T) {
	out, err := exec.Command("go", "run", "main.go").Output()
	if err != nil {
		t.Fatalf("go run failed: %v", err)
	}
	if string(out) != "toolchain ok\n" {
		t.Errorf("expected 'toolchain ok\\n', got %q", string(out))
	}
}
