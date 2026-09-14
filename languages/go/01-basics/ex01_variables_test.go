package main

import "testing"

func TestConstAndVar(t *testing.T) {
	const answer int = 42
	var x int = 7
	y := 9

	if answer != 42 {
		t.Errorf("const answer = %d, want 42", answer)
	}
	if x != 7 {
		t.Errorf("var x = %d, want 7", x)
	}
	if y != 9 {
		t.Errorf("short y = %d, want 9", y)
	}
}

func TestShortDeclCanReuse(t *testing.T) {
	x := 1
	x = 2
	if x != 2 {
		t.Errorf("x = %d, want 2", x)
	}
}
