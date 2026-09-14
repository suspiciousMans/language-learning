// 01-basics — scalar types: integers, floats, bool, char

/// Return the result of a small arithmetic expression using different scalar types.
pub fn scalar_mix() -> (i32, f64, bool, char) {
    let an_int: i32 = 7;
    let a_float: f64 = 2.5;
    let is_big = an_int > 5;
    let letter = 'R';
    (an_int, a_float, is_big, letter)
}

/// Cast an i32 to an f64.
pub fn int_to_float(x: i32) -> f64 {
    x as f64
}

/// Return true if the char is an ASCII uppercase letter.
pub fn is_uppercase_ascii(c: char) -> bool {
    c.is_ascii_uppercase()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn scalar_mix_values() {
        let (i, f, b, c) = scalar_mix();
        assert_eq!(i, 7);
        assert!((f - 2.5).abs() < 1e-12);
        assert!(b);
        assert_eq!(c, 'R');
    }

    #[test]
    fn int_to_float_twenty() {
        assert_eq!(int_to_float(20), 20.0);
    }

    #[test]
    fn is_uppercase_ascii_detects_upper() {
        assert!(is_uppercase_ascii('A'));
        assert!(!is_uppercase_ascii('a'));
        assert!(!is_uppercase_ascii('7'));
    }
}
