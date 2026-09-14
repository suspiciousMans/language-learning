package main

import "testing"

func TestBasicTypes(t *testing.T) {
	var i int = 42
	var f float64 = 3.14
	var s string = "hello"
	var b bool = true

	if i != 42 {
		t.Errorf("int %d != 42", i)
	}
	if f != 3.14 {
		t.Errorf("float %f != 3.14", f)
	}
	if s != "hello" {
		t.Errorf("string %q != hello", s)
	}
	if b != true {
		t.Errorf("bool %v != true", b)
	}

	// Explicit conversion required
	i2 := int(f)
	if i2 != 3 {
		t.Errorf("int(3.14) = %d, want 3", i2)
	}
}

func TestZeroValues(t *testing.T) {
	var zInt int
	var zFloat float64
	var zString string
	var zBool bool

	if zInt != 0 || zFloat != 0.0 || zString != "" || zBool != false {
		t.Errorf("zero values not as expected")
	}
}
