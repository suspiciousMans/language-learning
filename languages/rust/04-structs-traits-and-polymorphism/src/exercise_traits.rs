// 04-structs-traits-polymorphism — traits: definition, implementation, bounds

use std::fmt::Display;

/// A trait for things that can be described.
pub trait Describable {
    fn describe(&self) -> String;
}

/// A circle with a radius.
#[derive(Debug, Clone, Copy)]
pub struct Circle {
    pub radius: f64,
}

impl Describable for Circle {
    fn describe(&self) -> String {
        format!("circle with radius {}", self.radius)
    }
}

/// A square with side length.
#[derive(Debug, Clone, Copy)]
pub struct Square {
    pub side: f64,
}

impl Describable for Square {
    fn describe(&self) -> String {
        format!("square with side {}", self.side)
    }
}

/// Print a Describable thing using Display (via a bound).
pub fn print_descriptions<T: Describable>(things: &[T]) {
    for thing in things {
        println!("{}", thing.describe());
    }
}

/// A trait that requires Clone and Display.
pub trait Printable: Clone + Display {
    fn print_twice(&self) -> String;
}

impl Printable for i32 {
    fn print_twice(&self) -> String {
        format!("{}{}", self, self)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn circle_describes() {
        let c = Circle { radius: 3.0 };
        assert_eq!(c.describe(), "circle with radius 3");
    }

    #[test]
    fn square_describes() {
        let s = Square { side: 4.0 };
        assert_eq!(s.describe(), "square with side 4");
    }

    #[test]
    fn print_descriptions_collects() {
        let shapes = vec![Circle { radius: 1.0 }, Square { side: 2.0 }];
        // Just verify it compiles and doesn't panic
        let _ = print_descriptions(&shapes);
    }

    #[test]
    fn i32_print_twice() {
        assert_eq!(5_i32.print_twice(), "55");
    }
}
