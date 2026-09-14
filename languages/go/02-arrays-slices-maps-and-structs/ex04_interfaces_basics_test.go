package main

import (
	"fmt"
	"testing"
)

// Stringer is a simplified version of fmt.Stringer.
type Stringer interface {
	String() string
}

// Point represents a 2D point.
type Point struct {
	X, Y int
}

// String implements Stringer.
func (p Point) String() string {
	return fmt.Sprintf("(%d,%d)", p.X, p.Y)
}

// Circle represents a circle.
type Circle struct {
	Radius int
}

// String implements Stringer.
func (c Circle) String() string {
	return fmt.Sprintf("circle(r=%d)", c.Radius)
}

// Describe uses the interface.
func Describe(s Stringer) string {
	return "shape: " + s.String()
}

func TestPointSatisfiesStringer(t *testing.T) {
	p := Point{3, 4}
	if got := Describe(p); got != "shape: (3,4)" {
		t.Errorf("Describe(Point) = %q, want %q", got, "shape: (3,4)")
	}
}

func TestCircleSatisfiesStringer(t *testing.T) {
	c := Circle{Radius: 5}
	if got := Describe(c); got != "shape: circle(r=5)" {
		t.Errorf("Describe(Circle) = %q, want %q", got, "shape: circle(r=5)")
	}
}

// AnyContainer demonstrates the empty interface (any).
type AnyContainer struct {
	items []any
}

func (ac *AnyContainer) Add(item any) {
	ac.items = append(ac.items, item)
}

func (ac *AnyContainer) Items() []any {
	return ac.items
}

func TestEmptyInterfaceHoldsVariousTypes(t *testing.T) {
	c := &AnyContainer{}
	c.Add(42)
	c.Add("hello")
	c.Add(Point{1, 2})

	items := c.Items()
	if len(items) != 3 {
		t.Fatalf("items len = %d, want 3", len(items))
	}
	if items[0] != 42 {
		t.Errorf("items[0] = %v, want 42", items[0])
	}
	if items[1] != "hello" {
		t.Errorf("items[1] = %v, want hello", items[1])
	}
	pointOneTwo := Point{X: 1, Y: 2}
	if items[2] != pointOneTwo {
		t.Errorf("items[2] = %v, want (1,2)", items[2])
	}
}

func TestTypeAssertion(t *testing.T) {
	var x any = Point{10, 20}
	p, ok := x.(Point)
	if !ok {
		t.Error("type assertion to Point should succeed")
	}
	// Struct literal comparison
	target := Point{X: 10, Y: 20}
	if p != target {
		t.Errorf("asserted point = %v, want (10,20)", p)
	}

	// Failed assertion
	_, ok = x.(Circle)
	if ok {
		t.Error("type assertion to Circle should fail")
	}

	// Panic on bad assertion without ok
	defer func() {
		if r := recover(); r == nil {
			t.Error("should have panicked")
		}
	}()
	_ = x.(Circle)
}
