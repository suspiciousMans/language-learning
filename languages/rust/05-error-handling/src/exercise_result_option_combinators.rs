// 05-error-handling — Result/Option combinators: map, and_then, unwrap_or, ?

use std::num::ParseIntError;

/// Parse a string to i32, then double it using combinators.
///
/// Return Err if parsing fails. Use `?` for propagation.
pub fn parse_and_double(s: &str) -> Result<i32, ParseIntError> {
    let n: i32 = s.parse()?;
    Ok(n * 2)
}

/// Take an Option<i32>, and if it's Some, double it; otherwise return 0.
pub fn double_or_zero(opt: Option<i32>) -> i32 {
    opt.map(|x| x * 2).unwrap_or(0)
}

/// Chain two Result-returning operations with and_then.
///
/// First parse a string to i32, then divide 100 by it.
pub fn parse_then_divide(s: &str) -> Result<i32, String> {
    let n: i32 = s.parse().map_err(|e| e.to_string())?;
    if n == 0 {
        return Err("cannot divide by zero".to_string());
    }
    Ok(100 / n)
}

/// Given a Result<String, &str>, return the string length or a default.
pub fn length_or_default(result: Result<String, &str>, default: usize) -> usize {
    result.map(|s| s.len()).unwrap_or(default)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_and_double_valid() {
        assert_eq!(parse_and_double("5"), Ok(10));
    }

    #[test]
    fn parse_and_double_invalid() {
        assert!(parse_and_double("abc").is_err());
    }

    #[test]
    fn double_or_zero_some() {
        assert_eq!(double_or_zero(Some(5)), 10);
    }

    #[test]
    fn double_or_zero_none() {
        assert_eq!(double_or_zero(None), 0);
    }

    #[test]
    fn parse_then_divide_valid() {
        assert_eq!(parse_then_divide("5"), Ok(20));
    }

    #[test]
    fn parse_then_divide_zero() {
        assert_eq!(parse_then_divide("0"), Err("cannot divide by zero".to_string()));
    }

    #[test]
    fn parse_then_divide_invalid() {
        assert!(parse_then_divide("xyz").is_err());
    }

    #[test]
    fn length_or_default_ok() {
        assert_eq!(length_or_default(Ok("hello".to_string()), 0), 5);
    }

    #[test]
    fn length_or_default_err() {
        assert_eq!(length_or_default(Err("oops"), 10), 10);
    }
}
