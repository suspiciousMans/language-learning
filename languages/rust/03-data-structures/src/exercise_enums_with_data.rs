// 03-data-structures — enums with data

/// A simple enum representing a web event.
#[derive(Debug, PartialEq)]
pub enum WebEvent {
    PageLoad,
    KeyPress(char),
    Click { x: i32, y: i32 },
}

/// Return the character pressed, or None if it's not a KeyPress.
pub fn key_pressed(event: &WebEvent) -> Option<char> {
    match event {
        WebEvent::KeyPress(c) => Some(*c),
        _ => None,
    }
}

/// Return the x coordinate of a click, or None.
pub fn click_x(event: &WebEvent) -> Option<i32> {
    match event {
        WebEvent::Click { x, y: _ } => Some(*x),
        _ => None,
    }
}

/// A more complex enum: an expression tree.
#[derive(Debug, PartialEq)]
pub enum Expr {
    Literal(i32),
    Add(Box<Expr>, Box<Expr>),
    Mul(Box<Expr>, Box<Expr>),
}

/// Evaluate an expression tree.
pub fn eval(expr: &Expr) -> i32 {
    match expr {
        Expr::Literal(n) => *n,
        Expr::Add(l, r) => eval(l) + eval(r),
        Expr::Mul(l, r) => eval(l) * eval(r),
    }
}

/// Return a human-readable representation of the expression.
pub fn expr_to_string(expr: &Expr) -> String {
    match expr {
        Expr::Literal(n) => n.to_string(),
        Expr::Add(l, r) => format!("({} + {})", expr_to_string(l), expr_to_string(r)),
        Expr::Mul(l, r) => format!("({} * {})", expr_to_string(l), expr_to_string(r)),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn key_pressed_extracted() {
        let event = WebEvent::KeyPress('a');
        assert_eq!(key_pressed(&event), Some('a'));
        let click = WebEvent::Click { x: 10, y: 20 };
        assert_eq!(key_pressed(&click), None);
    }

    #[test]
    fn click_x_extracted() {
        let click = WebEvent::Click { x: 42, y: 7 };
        assert_eq!(click_x(&click), Some(42));
    }

    #[test]
    fn eval_add() {
        let expr = Expr::Add(Box::new(Expr::Literal(2)), Box::new(Expr::Literal(3)));
        assert_eq!(eval(&expr), 5);
    }

    #[test]
    fn eval_mul() {
        let expr = Expr::Mul(Box::new(Expr::Literal(4)), Box::new(Expr::Literal(5)));
        assert_eq!(eval(&expr), 20);
    }

    #[test]
    fn eval_nested() {
        let expr = Expr::Add(
            Box::new(Expr::Literal(1)),
            Box::new(Expr::Mul(Box::new(Expr::Literal(2)), Box::new(Expr::Literal(3)))),
        );
        // 1 + (2 * 3) = 7
        assert_eq!(eval(&expr), 7);
    }

    #[test]
    fn expr_to_string_add() {
        let expr = Expr::Add(Box::new(Expr::Literal(1)), Box::new(Expr::Literal(2)));
        assert_eq!(expr_to_string(&expr), "(1 + 2)");
    }
}
