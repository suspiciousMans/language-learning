// Tooling check — library side with a unit test.

/// Returns true when the toolchain is fine.
pub fn toolchain_ok() -> bool {
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn asserts_toolchain_ok() {
        assert!(toolchain_ok());
        assert_eq!(toolchain_ok(), true);
    }
}
