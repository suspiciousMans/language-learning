// 03-data-structures — String vs &str

/// Take a &str, append "!" to it, and return a new String.
pub fn add_exclamation(s: &str) -> String {
    format!("{}!", s)
}

/// Return true if the string contains the substring (borrowed).
pub fn contains_substring(haystack: &str, needle: &str) -> bool {
    haystack.contains(needle)
}

/// Concatenate two &str references into a new String.
pub fn concat_str(a: &str, b: &str) -> String {
    format!("{}{}", a, b)
}

/// Given a String, return a &str slice of the first `n` bytes.
///
/// Note: this is a byte-slice, not a char-slice. For UTF-8-safe slicing,
/// the learner should consider char indices. We keep it simple here.
pub fn first_bytes(s: &String, n: usize) -> &str {
    let bytes = s.as_bytes();
    let end = bytes.len().min(n);
    std::str::from_utf8(&bytes[..end]).unwrap_or("")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_exclamation_appends() {
        assert_eq!(add_exclamation("hello"), "hello!");
    }

    #[test]
    fn contains_substring_works() {
        assert!(contains_substring("hello world", "world"));
        assert!(!contains_substring("hello world", "rust"));
    }

    #[test]
    fn concat_str_joins() {
        assert_eq!(concat_str("foo", "bar"), "foobar");
    }

    #[test]
    fn first_bytes_returns_prefix() {
        let s = String::from("hello");
        assert_eq!(first_bytes(&s, 3), "hel");
        // s is still owned by the caller
        assert_eq!(s, "hello");
    }
}
