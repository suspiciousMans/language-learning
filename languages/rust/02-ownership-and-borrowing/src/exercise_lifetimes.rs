// 02-ownership-and-borrowing — lifetimes basics: elision + common patterns.
//
// These exercises introduce explicit lifetimes only where elision fails.
// Most functions below should work with elision alone — the learner should
// NOT add lifetimes everywhere. Only add them where the compiler demands it.

/// Return the longer of two string slices.
///
/// This needs explicit lifetimes because there are two input references
/// and one output reference — elision cannot determine which input the
/// output is tied to. Add `<'a>` and tie both inputs + output to it.
pub fn longer(a: &str, b: &str) -> &str {
    if a.len() >= b.len() { a } else { b }
}

/// Return a reference to the first element of a slice, or None.
///
/// This should work with elision (one input reference, one output).
pub fn first<T>(slice: &[T]) -> Option<&T> {
    slice.first()
}

/// Return a pair of references: the first and last elements of a slice.
///
/// This needs explicit lifetimes because there are two output references
/// tied to one input — explicit helps the learner see the pattern.
pub fn first_and_last<T>(slice: &[T]) -> Option<(&T, &T)> {
    if let (Some(first), Some(last)) = (slice.first(), slice.last()) {
        Some((first, last))
    } else {
        None
    }
}

/// A struct that holds a reference. Needs a lifetime parameter.
pub struct BorrowedView<'a> {
    data: &'a str,
}

impl<'a> BorrowedView<'a> {
    pub fn new(data: &'a str) -> Self {
        BorrowedView { data }
    }

    pub fn as_str(&self) -> &str {
        self.data
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn longer_returns_longer() {
        assert_eq!(longer("ab", "abc"), "abc");
        assert_eq!(longer("abcd", "ef"), "abcd");
    }

    #[test]
    fn first_returns_first() {
        let v = vec![10, 20, 30];
        assert_eq!(first(&v), Some(&10));
    }

    #[test]
    fn first_and_last_returns_ends() {
        let v = vec![1, 2, 3, 4];
        let (f, l) = first_and_last(&v).unwrap();
        assert_eq!(*f, 1);
        assert_eq!(*l, 4);
    }

    #[test]
    fn first_and_last_empty_returns_none() {
        let v: Vec<i32> = Vec::new();
        assert_eq!(first_and_last(&v), None);
    }

    #[test]
    fn borrowed_view_holds_reference() {
        let view = BorrowedView::new("hello");
        assert_eq!(view.as_str(), "hello");
    }
}
