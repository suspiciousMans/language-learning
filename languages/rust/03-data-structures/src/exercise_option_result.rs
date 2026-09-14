// 03-data-structures — Option and Result

/// Return the second element of a slice, or None if there isn't one.
pub fn second_element<T>(slice: &[T]) -> Option<&T> {
    slice.get(1)
}

/// Safely divide two numbers. Return Err if the divisor is zero.
pub fn safe_divide(a: i32, b: i32) -> Result<i32, &'static str> {
    if b == 0 {
        Err("division by zero")
    } else {
        Ok(a / b)
    }
}

/// Apply a function that returns Result, and if it errors, return a default.
pub fn unwrap_or_default<T, F, E>(f: F, default: T) -> T
where
    F: FnOnce() -> Result<T, E>,
{
    f().unwrap_or(default)
}

/// Given an Option<i32>, return the value squared if present, else 0.
pub fn square_or_zero(opt: Option<i32>) -> i32 {
    opt.map(|x| x * x).unwrap_or(0)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn second_element_some() {
        let v = vec![1, 2, 3];
        assert_eq!(second_element(&v), Some(&2));
    }

    #[test]
    fn second_element_none() {
        let v = vec![1];
        assert_eq!(second_element(&v), None);
    }

    #[test]
    fn safe_divide_ok() {
        assert_eq!(safe_divide(10, 2), Ok(5));
    }

    #[test]
    fn safe_divide_err() {
        assert_eq!(safe_divide(10, 0), Err("division by zero"));
    }

    #[test]
    fn unwrap_or_default_on_error() {
        let result: Result<i32, &str> = Err("oops");
        assert_eq!(unwrap_or_default(|| result, 42), 42);
    }

    #[test]
    fn square_or_zero_some() {
        assert_eq!(square_or_zero(Some(5)), 25);
    }

    #[test]
    fn square_or_zero_none() {
        assert_eq!(square_or_zero(None), 0);
    }
}
