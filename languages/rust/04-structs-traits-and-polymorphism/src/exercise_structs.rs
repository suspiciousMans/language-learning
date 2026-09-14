// 04-structs-traits-polymorphism — struct definitions

/// A 2D point with x and y coordinates.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

/// Create a new Point at the origin.
pub fn origin() -> Point {
    Point { x: 0.0, y: 0.0 }
}

/// A tuple struct representing a color (R, G, B).
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Color(u8, u8, u8);

/// Create a red Color.
pub fn red() -> Color {
    Color(255, 0, 0)
}

/// A unit struct (no fields).
#[derive(Debug)]
pub struct Marker;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn origin_is_zero() {
        let p = origin();
        assert_eq!(p.x, 0.0);
        assert_eq!(p.y, 0.0);
    }

    #[test]
    fn point_debug_printable() {
        let p = Point { x: 1.0, y: 2.0 };
        let debug = format!("{:?}", p);
        assert!(debug.contains("1"));
    }

    #[test]
    fn color_red_is_correct() {
        let c = red();
        assert_eq!(c, Color(255, 0, 0));
    }

    #[test]
    fn marker_is_debug_printable() {
        let _m = Marker;
        // Marker implements Debug because we derived it
        let _ = format!("{:?}", Marker);
    }
}
