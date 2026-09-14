// 05-error-handling — error propagation with the ? operator

use std::num::ParseIntError;

/// Parse a file path-like string and return the "line count" as an i32.
///
/// This simulates parsing a string that has the form "lines:<N>".
/// If the string doesn't match or the number is invalid, return an error.
pub fn parse_line_count(input: &str) -> Result<i32, String> {
    let prefix = "lines:";
    if !input.starts_with(prefix) {
        return Err(format!("expected prefix '{}'", prefix));
    }
    let num_str = &input[prefix.len()..];
    let n: i32 = num_str.parse().map_err(|e| e.to_string())?;
    if n < 0 {
        return Err("line count must be non-negative".to_string());
    }
    Ok(n)
}

/// A helper that may fail — returns Result.
fn read_number_from_stdin(s: &str) -> Result<i32, String> {
    s.parse::<i32>().map_err(|e| e.to_string())
}

/// Use ? to propagate errors from two helpers.
pub fn sum_two_inputs(a: &str, b: &str) -> Result<i32, String> {
    let x = read_number_from_stdin(a)?;
    let y = read_number_from_stdin(b)?;
    Ok(x + y)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_line_count_valid() {
        assert_eq!(parse_line_count("lines:42"), Ok(42));
    }

    #[test]
    fn parse_line_count_negative() {
        assert_eq!(parse_line_count("lines:-1"), Err("line count must be non-negative".to_string()));
    }

    #[test]
    fn parse_line_count_bad_prefix() {
        assert_eq!(parse_line_count("count:42"), Err("expected prefix 'lines:'".to_string()));
    }

    #[test]
    fn parse_line_count_bad_number() {
        assert_eq!(parse_line_count("lines:abc"), Err("".to_string())); // parse error message
    }

    #[test]
    fn sum_two_inputs_valid() {
        assert_eq!(sum_two_inputs("10", "20"), Ok(30));
    }

    #[test]
    fn sum_two_inputs_one_invalid() {
        assert!(sum_two_inputs("10", "abc").is_err());
    }
}
