// 05-error-handling — panic vs Result

/// Return the first element of a slice, or panic if the slice is empty.
///
/// This is the "panic" path. Suitable for prototypes and tests, but in
/// production code you'd usually return Option or Result instead.
pub fn first_or_panic<T: fmt::Debug>(slice: &[T]) -> &T {
    slice.first().expect("called first_or_panic on an empty slice")
}

/// Return the first element of a slice, or None if empty.
///
/// This is the "Result/Option" path — the caller decides how to handle it.
pub fn first_or_none<T>(slice: &[T]) -> Option<&T> {
    slice.first()
}

/// A function that divides and may panic on division by zero.
///
/// PANIC path — only acceptable when the precondition (non-zero divisor)
/// is guaranteed by the caller's contract.
pub fn divide_and_panic(a: i32, b: i32) -> i32 {
    a / b // panics if b == 0
}

/// A function that divides and returns a Result.
///
/// RESULT path — the caller can handle the error gracefully.
pub fn divide_result(a: i32, b: i32) -> Result<i32, &'static str> {
    if b == 0 {
        Err("division by zero")
    } else {
        Ok(a / b)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn first_or_panic_works() {
        let v = vec![1, 2, 3];
        assert_eq!(*first_or_panic(&v), 1);
    }

    #[test]
    #[should_panic(expected = "called first_or_panic on an empty slice")]
    fn first_or_panic_panics_on_empty() {
        let empty: Vec<i32> = Vec::new();
        let _ = first_or_panic(&empty);
    }

    #[test]
    fn first_or_none_works() {
        let v = vec![1, 2, 3];
        assert_eq!(first_or_none(&v), Some(&1));
    }

    #[test]
    fn first_or_none_empty() {
        let empty: Vec<i32> = Vec::new();
        assert_eq!(first_or_none(&empty), None);
    }

    #[test]
    fn divide_result_ok() {
        assert_eq!(divide_result(10, 2), Ok(5));
    }

    #[test]
    fn divide_result_err() {
        assert_eq!(divide_result(10, 0), Err("division by zero"));
    }
}
