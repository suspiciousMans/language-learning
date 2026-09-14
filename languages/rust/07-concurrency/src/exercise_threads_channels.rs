// 07-concurrency — threads + channels (std::thread, mpsc)

use std::sync::mpsc;
use std::thread;

/// Spawn a thread that sends a sequence of numbers through a channel,
/// then return the receiver so the main thread can collect them.
pub fn spawn_number_sender(count: usize) -> mpsc::Receiver<i32> {
    let (tx, rx) = mpsc::channel();
    let tx = std::sync::Arc::new(std::sync::Mutex::new(tx));
    let mut handles = Vec::new();

    for i in 0..count {
        let tx = Arc::clone(&tx);
        let handle = thread::spawn(move || {
            let tx = tx.lock().unwrap();
            tx.send(i as i32).unwrap();
        });
        handles.push(handle);
    }

    // In a real exercise the learner would collect from rx in the main thread
    // and join handles. Here we return rx and let the caller do the collection.
    rx
}

/// Collect all messages from the receiver into a Vec.
pub fn collect_from(rx: mpsc::Receiver<i32>) -> Vec<i32> {
    let mut result = Vec::new();
    while let Ok(n) = rx.recv() {
        result.push(n);
    }
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn thread_channel_delivers_numbers() {
        let rx = spawn_number_sender(5);
        let collected = collect_from(rx);
        assert_eq!(collected.len(), 5);
        assert!(collected.contains(&0));
        assert!(collected.contains(&4));
    }
}
