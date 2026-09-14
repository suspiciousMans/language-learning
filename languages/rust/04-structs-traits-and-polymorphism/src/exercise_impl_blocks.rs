// 04-structs-traits-polymorphism — impl blocks: methods and associated functions

/// A Rectangle with width and height.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Rectangle {
    pub width: u32,
    pub height: u32,
}

impl Rectangle {
    /// Create a new Rectangle.
    pub fn new(width: u32, height: u32) -> Self {
        Rectangle { width, height }
    }

    /// Return the area of the rectangle.
    pub fn area(&self) -> u32 {
        self.width * self.height
    }

    /// Return true if the rectangle can hold another.
    pub fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }

    /// A unit struct-like associated function that returns a square.
    pub fn square(size: u32) -> Self {
        Rectangle { width: size, height: size }
    }
}

/// A Person with a name.
#[derive(Debug)]
pub struct Person {
    pub name: String,
}

impl Person {
    pub fn new(name: &str) -> Self {
        Person {
            name: name.to_string(),
        }
    }

    /// Return a greeting string.
    pub fn greet(&self) -> String {
        format!("Hello, I'm {}", self.name)
    }

    /// Consume self and return the name.
    pub fn into_name(self) -> String {
        self.name
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn area_of_rectangle() {
        let rect = Rectangle::new(3, 4);
        assert_eq!(rect.area(), 12);
    }

    #[test]
    fn can_hold_check() {
        let big = Rectangle::new(10, 10);
        let small = Rectangle::new(5, 5);
        assert!(big.can_hold(&small));
        assert!(!small.can_hold(&big));
    }

    #[test]
    fn square_is_a_rectangle() {
        let sq = Rectangle::square(5);
        assert_eq!(sq.width, 5);
        assert_eq!(sq.height, 5);
    }

    #[test]
    fn person_greet() {
        let person = Person::new("Alice");
        assert_eq!(person.greet(), "Hello, I'm Alice");
    }

    #[test]
    fn person_into_name_consumes() {
        let person = Person::new("Bob");
        let name = person.into_name();
        assert_eq!(name, "Bob");
    }
}
