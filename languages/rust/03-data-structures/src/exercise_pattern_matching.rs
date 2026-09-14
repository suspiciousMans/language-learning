// 03-data-structures — pattern matching: match, if let, while let

/// Classify an Option<i32> using match.
pub fn classify_opt(opt: Option<i32>) -> &'static str {
    match opt {
        Some(n) if n > 0 => "positive",
        Some(n) if n < 0 => "negative",
        Some(_) => "zero",
        None => "nothing",
    }
}

/// Try to get the first element as an Option; use if let to handle it.
pub fn first_or_default<T: Clone>(slice: &[T], default: T) -> T {
    if let Some(first) = slice.first() {
        first.clone()
    } else {
        default
    }
}

/// Compute the sum of a slice using while let over an iterator.
pub fn sum_while_let(nums: &[i32]) -> i32 {
    let mut total = 0;
    let mut iter = nums.iter();
    while let Some(&n) = iter.next() {
        total += n;
    }
    total
}

/// Match on an enum with data and return a description.
#[derive(Debug)]
pub enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

pub fn describe_message(msg: &Message) -> String {
    match msg {
        Message::Quit => "quit".to_string(),
        Message::Move { x, y } => format!("move to ({}, {})", x, y),
        Message::Write(text) => format!("write: {}", text),
        Message::ChangeColor(r, g, b) => format!("color ({}, {}, {})", r, g, b),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn classify_opt_variants() {
        assert_eq!(classify_opt(Some(5)), "positive");
        assert_eq!(classify_opt(Some(-3)), "negative");
        assert_eq!(classify_opt(Some(0)), "zero");
        assert_eq!(classify_opt(None), "nothing");
    }

    #[test]
    fn first_or_default_works() {
        let v = vec![10, 20, 30];
        assert_eq!(first_or_default(&v, 0), 10);
        let empty: Vec<i32> = Vec::new();
        assert_eq!(first_or_default(&empty, 99), 99);
    }

    #[test]
    fn sum_while_let_on_vec() {
        assert_eq!(sum_while_let(&[1, 2, 3, 4]), 10);
        assert_eq!(sum_while_let(&[]), 0);
    }

    #[test]
    fn describe_message_variants() {
        assert_eq!(describe_message(&Message::Quit), "quit");
        assert_eq!(describe_message(&Message::Move { x: 1, y: 2 }), "move to (1, 2)");
        assert_eq!(describe_message(&Message::Write("hi".to_string())), "write: hi");
        assert_eq!(describe_message(&Message::ChangeColor(255, 0, 0)), "color (255, 0, 0)");
    }
}
