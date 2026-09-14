package main

import (
	"testing"
)

// Rectangle represents an axis-aligned rectangle.
type Rectangle struct {
	Width  float64
	Height float64
}

// Area returns the area of the rectangle (value receiver — no mutation).
func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// Perimeter returns the perimeter (value receiver).
func (r Rectangle) Perimeter() float64 {
	return 2*r.Width + 2*r.Height
}

// Scale mutates the rectangle (pointer receiver).
func (r *Rectangle) Scale(factor float64) {
	r.Width *= factor
	r.Height *= factor
}

// Person is a simple struct.
type Person struct {
	Name string
	Age  int
}

// Greeting returns a greeting string (value receiver).
func (p Person) Greeting() string {
	return "Hello, I'm " + p.Name
}

// HaveBirthday increments age (pointer receiver — mutates).
func (p *Person) HaveBirthday() {
	p.Age++
}

func TestRectangleArea(t *testing.T) {
	r := Rectangle{Width: 3, Height: 4}
	if got := r.Area(); got != 12 {
		t.Errorf("Area() = %f, want 12", got)
	}
}

func TestRectanglePerimeter(t *testing.T) {
	r := Rectangle{Width: 3, Height: 4}
	if got := r.Perimeter(); got != 14 {
		t.Errorf("Perimeter() = %f, want 14", got)
	}
}

func TestRectangleScale(t *testing.T) {
	r := Rectangle{Width: 2, Height: 3}
	r.Scale(2)
	if r.Width != 4 || r.Height != 6 {
		t.Errorf("after Scale(2): Width=%f Height=%f, want 4,6", r.Width, r.Height)
	}
}

func TestRectangleZeroValue(t *testing.T) {
	var r Rectangle
	if r.Area() != 0 || r.Perimeter() != 0 {
		t.Error("zero-value rectangle should have area/perimeter 0")
	}
}

func TestPersonGreeting(t *testing.T) {
	p := Person{Name: "Alice", Age: 30}
	if got := p.Greeting(); got != "Hello, I'm Alice" {
		t.Errorf("Greeting() = %q, want %q", got, "Hello, I'm Alice")
	}
}

func TestPersonHaveBirthday(t *testing.T) {
	p := Person{Name: "Bob", Age: 25}
	p.HaveBirthday()
	if p.Age != 26 {
		t.Errorf("after HaveBirthday: Age = %d, want 26", p.Age)
	}
}

func TestStructLiteral(t *testing.T) {
	// Positional literal
	r1 := Rectangle{3, 4}
	if r1.Area() != 12 {
		t.Error("positional literal failed")
	}
	// Named literal
	r2 := Rectangle{Height: 5, Width: 2}
	if r2.Area() != 10 {
		t.Error("named literal failed")
	}
	// Partial literal — missing fields get zero values
	r3 := Rectangle{Width: 7}
	if r3.Height != 0 {
		t.Errorf("missing field Height = %f, want 0", r3.Height)
	}
}

func TestStructComparison(t *testing.T) {
	r1 := Rectangle{Width: 1, Height: 2}
	r2 := Rectangle{Width: 1, Height: 2}
	if r1 != r2 {
		t.Error("structs with same field values should be equal")
	}
}

func TestStructCannotHaveNil(t *testing.T) {
	// structs are value types; they cannot be nil
	var r Rectangle
	// zero-value struct equals Rectangle{} — compare fields explicitly
	if r.Width != 0 || r.Height != 0 {
		t.Error("zero-value struct should have zero fields")
	}
}
