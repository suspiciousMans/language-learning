// 01-basics — control flow: if/else, loop, while, for

/// Return the sum of numbers from 1 to n using a `while` loop.
pub fn sum_to(n: i32) -> i32 {
    let mut total = 0;
    let mut i = 1;
    while i <= n {
        total += i;
        i += 1;
    }
    total
}

/// Return the sum of numbers from 1 to n using a `for` loop.
pub fn sum_to_for(n: i32) -> i32 {
    let mut total = 0;
    for i in 1..=n {
        total += i;
    }
    total
}

/// Run a loop that counts down from n to 0, returning the count of iterations.
pub fn count_down_iterations(start: i32) -> i32 {
    let mut count = 0;
    let mut current = start;
    loop {
        if current <= 0 {
            break;
        }
        count += 1;
        current -= 1;
    }
    count
}

/// Given a slice of i32, return the count of elements greater than threshold.
pub fn count_above(scores: &[i32], threshold: i32) -> usize {
    let mut count = 0;
    for &score in scores {
        if score > threshold {
            count += 1;
        }
    }
    count
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sum_to_ten() {
        assert_eq!(sum_to(10), 55);
    }

    #[test]
    fn sum_to_for_ten() {
        assert_eq!(sum_to_for(10), 55);
    }

    #[test]
    fn count_down_iterations_five() {
        assert_eq!(count_down_iterations(5), 5);
    }

    #[test]
    fn count_above_example() {
        let scores = [10, 20, 30, 40, 50];
        assert_eq!(count_above(&scores, 25), 3);
    }
}
