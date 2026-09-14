// 06-testing — a small library with inline unit tests.

/// Add two numbers.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Multiply two numbers.
pub fn multiply(a: i32, b: i32) -> i32 {
    a * b
}

/// Return the absolute value of a number.
pub fn abs_val(n: i32) -> i32 {
    if n < 0 { -n } else { n }
}

/// Compute the average of a slice. Returns None for empty slices.
pub fn average(nums: &[i32]) -> Option<f64> {
    if nums.is_empty() {
        return None;
    }
    let sum: i32 = nums.iter().sum();
    Some(sum as f64 / nums.len() as f64)
}

#[cfg(test)]
mod unit_tests {
    use super::*;

    #[test]
    fn add_works() {
        assert_eq!(add(2, 3), 5);
        assert_eq!(add(-1, 1), 0);
    }

    #[test]
    fn multiply_works() {
        assert_eq!(multiply(3, 4), 12);
        assert_eq!(multiply(-2, 3), -6);
    }

    #[test]
    fn abs_val_positive() {
        assert_eq!(abs_val(5), 5);
    }

    #[test]
    fn abs_val_negative() {
        assert_eq!(abs_val(-5), 5);
    }

    #[test]
    fn abs_val_zero() {
        assert_eq!(abs_val(0), 0);
    }

    #[test]
    fn average_non_empty() {
        assert_eq!(average(&[1, 2, 3]), Some(2.0));
    }

    #[test]
    fn average_empty() {
        assert_eq!(average(&[]), None);
    }
}
