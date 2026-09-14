// 01-basics — variables: let, mut, shadowing

/// Return the final value after a sequence of binds and shadowing.
///
/// Sequence:
///   let a = 5;
///   let mut b = a;   // b = 5
///   b = b + 10;      // b = 15
///   let a = b;       // shadows a -> a = 15
///   a + 1            // 16
pub fn shadow_play() -> i32 {
    let a = 5;
    let mut b = a;
    b = b + 10;
    let a = b;
    a + 1
}

/// Increment a number in place using `mut`.
pub fn increment(mut x: i32) -> i32 {
    x += 1;
    x
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn shadow_play_returns_sixteen() {
        assert_eq!(shadow_play(), 16);
    }

    #[test]
    fn increment_five_returns_six() {
        assert_eq!(increment(5), 6);
    }
}
