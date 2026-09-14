// 04-structs-traits-polymorphism — generics with trait bounds

use std::fmt::Display;

/// Return the longer of two slices, using a generic with a Display bound
/// (the bound is not strictly needed here, but the exercise demonstrates syntax).
pub fn longer_display<T: Display>(a: &[T], b: &[T]) -> &'static str {
    // This function is intentionally simple: it just compares lengths.
    // The trait bound is to practice the syntax.
    if a.len() >= b.len() {
        "first"
    } else {
        "second"
    }
}

/// A generic function that returns the largest element in a slice,
/// requiring T: PartialOrd + Clone.
pub fn largest<T: PartialOrd + Clone>(slice: &[T]) -> Option<T> {
    if slice.is_empty() {
        return None;
    }
    let mut largest = slice[0].clone();
    for item in slice {
        if *item > largest {
            largest = item.clone();
        }
    }
    Some(largest)
}

/// A generic struct that holds a value and can be summarized.
pub struct Summarized<T> {
    pub value: T,
}

impl<T> Summarized<T> {
    pub fn new(value: T) -> Self {
        Summarized { value }
    }
}

impl<T: std::fmt::Display> Summarized<T> {
    pub fn summary(&self) -> String {
        format!("value: {}", self.value)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn longer_display_strings() {
        assert_eq!(longer_display(&["ab"], &["a"]), "first");
        assert_eq!(longer_display(&["a"], &["ab"]), "second");
    }

    #[test]
    fn largest_i32() {
        let v = vec![1, 5, 3, 9, 2];
        assert_eq!(largest(&v), Some(9));
    }

    #[test]
    fn largest_empty() {
        let v: Vec<i32> = Vec::new();
        assert_eq!(largest(&v), None);
    }

    #[test]
    fn summarized_summary() {
        let s = Summarized::new(42);
        assert_eq!(s.summary(), "value: 42");
    }
}
