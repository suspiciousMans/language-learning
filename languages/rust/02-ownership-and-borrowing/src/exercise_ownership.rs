// 02-ownership-and-borrowing — ownership moves.
//
// Each function below deliberately fails to compile in its current form.
// Read the compiler error, then fix the function (and update the test
// to match the fixed signature).
//
// HINT: the fix is almost always to take a reference instead of taking
// ownership. The tests below show what the FIXED API should look like —
// they won't compile until you fix the functions.

/// Returns the length of a string slice.
///
/// BUG (learner fix): takes `String` by value — moves it. Fix: take `&str`.
pub fn peak_len(s: String) -> usize {
    s.len()
}

/// Attempts to concatenate two strings.
///
/// BUG (learner fix): takes ownership of both. Fix: take `&str` references.
pub fn concat_owned(s1: String, s2: String) -> String {
    format!("{}{}", s1, s2)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn peak_len_works_on_borrowed() {
        // Once you fix `peak_len` to take `&str`, this should pass:
        let s = String::from("hello");
        let len = peak_len(&s); // <-- this line will fail until you fix the signature
        assert_eq!(len, 5);
        // s is still usable because we only borrowed it
        assert_eq!(s, "hello");
    }

    #[test]
    fn concat_owned_works_on_borrowed() {
        let a = String::from("foo");
        let b = String::from("bar");
        let result = concat_owned(&a, &b); // <-- this line will fail until you fix the signature
        assert_eq!(result, "foobar");
        assert_eq!(a, "foo");
        assert_eq!(b, "bar");
    }
}
