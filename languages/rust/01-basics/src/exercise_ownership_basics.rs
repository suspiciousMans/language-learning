// 01-basics — ownership basics: move vs copy for scalars.

/// This function takes an i32 by value. i32 implements Copy, so the caller
/// can still use `x` after the call.
pub fn takes_copy(x: i32) -> i32 {
    x + 1
}

/// This function takes a String by value — it MOVES ownership.
/// The caller must not use `s` after the call (the compiler enforces this).
pub fn takes_ownership(s: String) -> String {
    format!("{} moved", s)
}

/// Return a String without taking ownership — the caller keeps their String.
pub fn greeting(prefix: &str, name: &str) -> String {
    format!("{}, {}!", prefix, name)
}

/// Demonstrate shadowing with a moved value: we move `s` into the function,
/// then shadow the original variable with a new String to use it again.
pub fn move_and_shadow() -> String {
    let s = String::from("hello");
    let _used = takes_ownership(s); // s moved here
    let s = String::from("world");  // shadow with a new String
    s
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn copy_still_usable_after_call() {
        let x = 10;
        let result = takes_copy(x);
        assert_eq!(result, 11);
        assert_eq!(x, 10); // x still here because i32 is Copy
    }

    #[test]
    fn ownership_move_prevents_reuse() {
        let s = String::from("data");
        let result = takes_ownership(s);
        assert_eq!(result, "data moved");
        // `s` is no longer valid here — uncommenting the next line fails:
        // println!("{}", s);
    }

    #[test]
    fn greeting_format() {
        assert_eq!(greeting("Hello", "Rust"), "Hello, Rust!");
    }

    #[test]
    fn move_and_shadow_returns_world() {
        assert_eq!(move_and_shadow(), "world");
    }
}
