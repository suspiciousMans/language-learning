package main

import "testing"

func absoluteValue(x int) int {
	if x < 0 {
		return -x
	}
	return x
}

func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	prev, curr := 0, 1
	for i := 2; i <= n; i++ {
		prev, curr = curr, prev+curr
	}
	return curr
}

func isPrime(n int) bool {
	switch {
	case n < 2:
		return false
	case n == 2:
		return true
	case n%2 == 0:
		return false
	default:
		for i := 3; i*i <= n; i += 2 {
			if n%i == 0 {
				return false
			}
		}
		return true
	}
}

func TestAbsoluteValue(t *testing.T) {
	tests := []struct{ in, want int }{
		{0, 0}, {-5, 5}, {5, 5}, {-1, 1},
	}
	for _, tc := range tests {
		if got := absoluteValue(tc.in); got != tc.want {
			t.Errorf("absoluteValue(%d) = %d, want %d", tc.in, got, tc.want)
		}
	}
}

func TestFibonacci(t *testing.T) {
	seq := []int{0, 1, 1, 2, 3, 5, 8, 13, 21}
	for i, want := range seq {
		if got := fibonacci(i); got != want {
			t.Errorf("fibonacci(%d) = %d, want %d", i, got, want)
		}
	}
}

func TestIsPrime(t *testing.T) {
	primes := map[int]bool{2: true, 3: true, 5: true, 7: true, 11: true, 13: true}
	nonPrimes := map[int]bool{0: true, 1: true, 4: true, 6: true, 9: true, 15: true}
	for n := range primes {
		if got := isPrime(n); got != true {
			t.Errorf("isPrime(%d) = %v, want true", n, got)
		}
	}
	for n := range nonPrimes {
		if got := isPrime(n); got != false {
			t.Errorf("isPrime(%d) = %v, want false", n, got)
		}
	}
}
