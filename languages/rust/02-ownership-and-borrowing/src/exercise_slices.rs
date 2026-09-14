// 02-ownership-and-borrowing — slices.
//
// Exercises that involve slicing and &str vs String.

/// Return the first `n` characters of a `&str` as a new `&str`.
///
/// BUG (learner fix): this allocates a new String. Should return `&str`
/// by slicing the input.
pub fn first_words(s: &str, n: usize) -> String {
    let bytes = s.as_bytes();
    let end = bytes.len().min(n);
    String::from_utf8(bytes[..end].to_vec()).unwrap()
}

/// Count the number of words in a &str (split on whitespace).
pub fn word_count(s: &str) -> usize {
    s.split_whitespace().count()
}

/// Given a Vec<i32>, return a slice covering elements from `start` to `end`
/// (exclusive). The function takes a reference to the Vec.
pub fn slice_range(v: &Vec<i32>, start: usize, end: usize) -> &[i32] {
    &v[start..end]
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn first_words_returns_slice() {
        // Once fixed, this should work without allocation
        let s = "hello world";
        let slice = first_words(s, 5);
        assert_eq!(slice, "hello");
        // slice should be a sub-slice of s, not a new allocation
    }

    #[test]
    fn word_count_basic() {
        assert_eq!(word_count("hello world"), 2);
        assert_eq!(word_count("   one   two   "), 2);
        assert_eq!(word_count(""), 0);
    }

    #[test]
    fn slice_range_returns_correct_slice() {
        let v = vec![0, 10, 20, 30, 40, 50];
        let slice = slice_range(&v, 1, 4);
        assert_eq!(slice, &[10, 20, 30]);
    }
}
