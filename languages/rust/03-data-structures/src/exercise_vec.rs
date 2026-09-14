// 03-data-structures — Vec<T>

/// Return a Vec containing the numbers 1 through n.
pub fn one_through(n: usize) -> Vec<u32> {
    (1..=n as u32).collect()
}

/// Push all elements of `extra` onto `base` and return the new Vec.
pub fn push_all(base: Vec<i32>, extra: Vec<i32>) -> Vec<i32> {
    let mut result = base;
    result.extend(extra);
    result
}

/// Return the sum of all elements in the Vec.
pub fn sum_vec(nums: &[i32]) -> i32 {
    nums.iter().sum()
}

/// Return a new Vec containing only the even numbers from the input.
pub fn evens(nums: &[i32]) -> Vec<i32> {
    nums.iter().filter(|&&x| x % 2 == 0).copied().collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn one_through_five() {
        assert_eq!(one_through(5), vec![1, 2, 3, 4, 5]);
    }

    #[test]
    fn push_all_concatenates() {
        let base = vec![1, 2];
        let extra = vec![3, 4];
        assert_eq!(push_all(base, extra), vec![1, 2, 3, 4]);
    }

    #[test]
    fn sum_vec_basic() {
        assert_eq!(sum_vec(&[1, 2, 3, 4]), 10);
        assert_eq!(sum_vec(&[]), 0);
    }

    #[test]
    fn evens_filters_correctly() {
        assert_eq!(evens(&[1, 2, 3, 4, 5, 6]), vec![2, 4, 6]);
        assert_eq!(evens(&[1, 3, 5]), Vec::<i32>::new());
    }
}
