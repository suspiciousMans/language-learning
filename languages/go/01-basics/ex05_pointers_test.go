package main

import "testing"

type Counter struct {
	value int
}

// Value receiver — gets a copy.
func (c Counter) Inc() {
	c.value++
}

// Pointer receiver — mutates the original.
func (c *Counter) IncPtr() {
	c.value++
}

// Reset via pointer receiver.
func (c *Counter) Reset() {
	c.value = 0
}

func TestValueReceiverDoesNotMutate(t *testing.T) {
	c := Counter{value: 5}
	c.Inc()
	if c.value != 5 {
		t.Errorf("value receiver Inc() did not mutate; c.value = %d, want 5", c.value)
	}
}

func TestPointerReceiverMutates(t *testing.T) {
	c := Counter{value: 5}
	c.IncPtr()
	if c.value != 6 {
		t.Errorf("pointer receiver IncPtr() mutated; c.value = %d, want 6", c.value)
	}
}

func TestNewAllocates(t *testing.T) {
	c := new(Counter)
	if c.value != 0 {
		t.Errorf("new(Counter).value = %d, want 0", c.value)
	}
	c.IncPtr()
	if c.value != 1 {
		t.Errorf("after IncPtr: c.value = %d, want 1", c.value)
	}
}
