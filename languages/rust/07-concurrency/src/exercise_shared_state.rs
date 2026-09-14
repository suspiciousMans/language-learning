// 07-concurrency — shared state with Arc<Mutex<T>>

use std::sync::{Arc, Mutex};
use std::thread;

/// Create a shared counter, spawn several threads that each increment it,
/// then return the final count.
pub fn shared_counter(num_threads: usize, increments_per_thread: usize) -> usize {
    let counter = Arc::new(Mutex::new(0usize));
    let mut handles = Vec::new();

    for _ in 0..num_threads {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            for _ in 0..increments_per_thread {
                let mut c = counter.lock().unwrap();
                *c += 1;
            }
        });
        handles.push(handle);
    }

    for handle in handles {
        handle.join().unwrap();
    }

    *counter.lock().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn shared_counter_counts_correctly() {
        let total = shared_counter(4, 100);
        assert_eq!(total, 400);
    }

    #[test]
    fn shared_counter_single_thread() {
        let total = shared_counter(1, 50);
        assert_eq!(total, 50);
    }

    #[test]
    fn shared_counter_zero_threads() {
        let total = shared_counter(0, 100);
        assert_eq!(total, 0);
    }
}
