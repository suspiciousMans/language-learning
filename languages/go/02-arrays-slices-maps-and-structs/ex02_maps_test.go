package main

import (
	"sort"
	"strings"
	"testing"
)

// WordCount returns a map of word frequencies for the given text.
// Words are lowercased and split on whitespace.
func WordCount(text string) map[string]int {
	words := strings.Fields(strings.ToLower(text))
	m := make(map[string]int)
	for _, w := range words {
		m[w]++
	}
	return m
}

// TopWords returns the n most frequent words sorted by count descending.
func TopWords(m map[string]int, n int) []string {
	type wc struct {
		word  string
		count int
	}
	var sorted []wc
	for w, c := range m {
		sorted = append(sorted, wc{w, c})
	}
	sort.Slice(sorted, func(i, j int) bool {
		if sorted[i].count != sorted[j].count {
			return sorted[i].count > sorted[j].count
		}
		return sorted[i].word < sorted[j].word
	})
	result := make([]string, 0, n)
	for i := 0; i < n && i < len(sorted); i++ {
		result = append(result, sorted[i].word)
	}
	return result
}

func TestWordCount(t *testing.T) {
	text := "go is great go is fun"
	want := map[string]int{"go": 2, "is": 2, "great": 1, "fun": 1}
	got := WordCount(text)
	if len(got) != len(want) {
		t.Errorf("word count map size %d != %d", len(got), len(want))
	}
	for w, c := range want {
		if got, ok := got[w]; !ok || got != c {
			t.Errorf("WordCount[%q] = %d, want %d", w, got, c)
		}
	}
}

func TestTopWords(t *testing.T) {
	m := map[string]int{"a": 5, "b": 3, "c": 5, "d": 1}
	top := TopWords(m, 2)
	if len(top) != 2 {
		t.Fatalf("top len = %d, want 2", len(top))
	}
	// "a" and "c" tie at 5; alphabetical tiebreak => "a" first
	if top[0] != "a" || top[1] != "c" {
		t.Errorf("top 2 = %v, want [a c]", top)
	}
}

func TestMapZeroValue(t *testing.T) {
	var m map[string]int
	if m != nil {
		t.Error("nil map should be nil")
	}
	// Reading from nil map is safe (returns zero value)
	if v := m["missing"]; v != 0 {
		t.Errorf("reading from nil map: got %d, want 0", v)
	}
	// Writing to nil map panics — we don't test that here.
}

func TestMapDelete(t *testing.T) {
	m := map[string]int{"a": 1, "b": 2}
	delete(m, "a")
	if _, ok := m["a"]; ok {
		t.Error("deleted key still present")
	}
	if v, ok := m["b"]; !ok || v != 2 {
		t.Errorf("key b: ok=%v v=%d, want ok=true v=2", ok, v)
	}
}
