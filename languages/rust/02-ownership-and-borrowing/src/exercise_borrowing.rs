// 02-ownership-and-borrowing — borrowing: & and &mut.
//
// Each function deliberately violates the borrow rules. Fix them so the
// tests pass.
//
// HINT: look at what the test expects — it tells you the correct signature.

/// Returns the first element of a slice.
///
/// BUG (learner fix): takes `Vec<i32>` by value (moves it).
/// Should take `&[i32]`.
pub fn first_element(v: Vec<i32>) -> Option<i32> {
    v.first().copied()
}

/// Doubles every element in the slice in place.
///
/// BUG (learner fix): takes `&[i32]` but tries to mutate. Should take `&mut [i32]`.
pub fn double_in_place(items: &[i32]) {
    for x in items {
        *x = *x * 2;
    }
}

/// Sorts the vector in place and returns the smallest element.
///
/// BUG (learner fix): borrows immutably (first) and mutably (sort) simultaneously.
/// Fix by doing the immutable borrow AFTER the mutable one.
pub fn sort_and_peek(v: &mut Vec<i32>) -> Option<i32> {
    v.sort();
    v.first().copied()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn first_element_borrowed() {
        let v = vec![3, 1, 4];
        // Once first_element takes &[i32], this works without moving:
        let first = first_element(&v);
        assert_eq!(first, Some(3));
        // v still usable
        assert_eq!(v.len(), 3);
    }

    #[test]
    fn double_in_place_mutates() {
        let mut v = vec![1, 2, 3];
        // Once double_in_place takes &mut [i32], this works:
        double_in_place(&mut v);
        assert_eq!(v, vec![2, 4, 6]);
    }

    #[test]
    fn sort_and_peek_returns_smallest() {
        let mut v = vec![5, 2, 8, 1];
        let smallest = sort_and_peek(&mut v);
        assert_eq!(smallest, Some(1));
        // v is now sorted
        assert_eq!(v, vec![1, 2, 5, 8]);
    }
}
