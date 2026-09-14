package main

import "testing"

func TestArrayBasics(t *testing.T) {
	var arr [3]int
	arr[0] = 10
	arr[1] = 20
	arr[2] = 30

	if len(arr) != 3 || cap(arr) != 3 {
		t.Errorf("array len=%d cap=%d, want 3,3", len(arr), cap(arr))
	}

	sum := 0
	for _, v := range arr {
		sum += v
	}
	if sum != 60 {
		t.Errorf("sum = %d, want 60", sum)
	}
}

func TestSliceMakeAndAppend(t *testing.T) {
	s := make([]int, 2, 5)
	s[0] = 1
	s[1] = 2

	if len(s) != 2 || cap(s) != 5 {
		t.Errorf("slice len=%d cap=%d, want 2,5", len(s), cap(s))
	}

	s = append(s, 3, 4, 5)
	if len(s) != 5 {
		t.Errorf("after append len=%d, want 5", len(s))
	}
	if s[4] != 5 {
		t.Errorf("s[4] = %d, want 5", s[4])
	}

	// capacity doubles when exceeded
	s = append(s, 6)
	if cap(s) != 10 {
		t.Logf("note: cap after doubling = %d (implementation may vary)", cap(s))
	}
}

func TestSlicingSharesUnderlyingArray(t *testing.T) {
	arr := []int{0, 1, 2, 3, 4, 5}
	sub := arr[1:4] // [1,2,3]
	if len(sub) != 3 {
		t.Errorf("sub len = %d, want 3", len(sub))
	}
	sub[0] = 99
	if arr[1] != 99 {
		t.Errorf("underlying array not shared: arr[1] = %d, want 99", arr[1])
	}
}

func TestNilSlice(t *testing.T) {
	var s []int
	if s != nil {
		t.Errorf("nil slice is not nil")
	}
	if len(s) != 0 || cap(s) != 0 {
		t.Errorf("nil slice len=%d cap=%d, want 0,0", len(s), cap(s))
	}
	s = append(s, 1)
	if len(s) != 1 || s[0] != 1 {
		t.Errorf("appending to nil slice: len=%d s[0]=%d, want 1,1", len(s), s[0])
	}
}
