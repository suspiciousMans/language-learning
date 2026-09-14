// 06-testing — integration tests against the public API.

use rust_06_testing::{add, multiply, abs_val, average};

#[test]
fn add_returns_sum() {
    assert_eq!(add(10, 20), 30);
}

#[test]
fn multiply_returns_product() {
    assert_eq!(multiply(6, 7), 42);
}

#[test]
fn abs_val_positive_stays_same() {
    assert_eq!(abs_val(42), 42);
}

#[test]
fn abs_val_negative_flips() {
    assert_eq!(abs_val(-42), 42);
}

#[test]
fn average_of_evens() {
    assert_eq!(average(&[2, 4, 6, 8]), Some(5.0));
}

#[test]
fn average_of_empty_is_none() {
    assert_eq!(average(&[]), None);
}
