package main

import (
	"errors"
	"testing"
)

// divide returns the quotient and remainder of a/b.
// It returns an error when b == 0.
func divide(a, b int) (quotient int, remainder int, err error) {
	if b == 0 {
		err = errors.New("division by zero")
		return
	}
	quotient = a / b
	remainder = a % b
	return
}

// swap swaps two ints in place using pointers.
func swap(a, b *int) {
	*a, *b = *b, *a
}

func TestDivide(t *testing.T) {
	tests := []struct {
		a, b        int
		wantQ, wantR int
		wantErr     bool
	}{
		{10, 3, 3, 1, false},
		{7, 2, 3, 1, false},
		{0, 5, 0, 0, false},
		{5, 0, 0, 0, true},
	}
	for _, tc := range tests {
		q, r, err := divide(tc.a, tc.b)
		if (err != nil) != tc.wantErr {
			t.Errorf("divide(%d,%d) error = %v, wantErr %v", tc.a, tc.b, err, tc.wantErr)
			continue
		}
		if q != tc.wantQ || r != tc.wantR {
			t.Errorf("divide(%d,%d) = (%d,%d), want (%d,%d)", tc.a, tc.b, q, r, tc.wantQ, tc.wantR)
		}
	}
}

func TestSwap(t *testing.T) {
	x, y := 3, 7
	swap(&x, &y)
	if x != 7 || y != 3 {
		t.Errorf("after swap: x=%d, y=%d, want x=7, y=3", x, y)
	}
}
