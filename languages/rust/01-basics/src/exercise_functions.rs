// 01-basics — functions: parameters, return values, expressions vs statements

/// Add two numbers and return the result.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Return the larger of two numbers using a conditional expression.
pub fn max_of(a: i32, b: i32) -> i32 {
    if a > b { a } else { b }
}

/// Return the factorial of n (n >= 0).
pub fn factorial(n: u32) -> u32 {
    if n <= 1 {
        1
    } else {
        n * factorial(n - 1)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_works() {
        assert_eq!(add(2, 3), 5);
        assert_eq!(add(-1, 1), 0);
    }

    #[test]
    fn max_of_works() {
        assert_eq!(max_of(3, 7), 7);
        assert_eq!(max_of(7, 3), 7);
        assert_eq!(max_of(4, 4), 4);
    }

    #[test]
    fn factorial_works() {
        assert_eq!(factorial(0), 1);
        assert_eq!(factorial(1), 1);
        assert_eq!(factorial(5), 120);
    }
}
