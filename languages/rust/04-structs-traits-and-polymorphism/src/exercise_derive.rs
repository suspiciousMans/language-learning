// 04-structs-traits-polymorphism — derive macros

use std::cmp::PartialEq;
use std::hash::{Hash, Hasher};

/// A Point that derives common traits.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct Point {
    pub x: i32,
    pub y: i32,
}

/// A simple enum that derives Comparison traits.
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord)]
pub enum Priority {
    Low,
    Medium,
    High,
}

/// A struct that derives all the common derives.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, PartialOrd, Ord)]
pub struct Task {
    pub id: u32,
    pub priority: Priority,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn point_clonable_and_comparable() {
        let a = Point { x: 1, y: 2 };
        let b = a.clone();
        assert_eq!(a, b);
        assert_ne!(a, Point { x: 3, y: 4 });
    }

    #[test]
    fn point_hashable() {
        use std::collections::HashSet;
        let mut set = HashSet::new();
        set.insert(Point { x: 1, y: 2 });
        assert!(set.contains(&Point { x: 1, y: 2 }));
        assert!(!set.contains(&Point { x: 3, y: 4 }));
    }

    #[test]
    fn priority_ordering() {
        assert!(Priority::Low < Priority::Medium);
        assert!(Priority::Medium < Priority::High);
        assert_eq!(Priority::High, Priority::High);
    }

    #[test]
    fn task_comparable_and_hashable() {
        let t1 = Task { id: 1, priority: Priority::High };
        let t2 = Task { id: 2, priority: Priority::Low };
        assert!(t1 > t2); // High > Low in our enum ordering
        let mut set = HashSet::new();
        set.insert(t1);
        assert!(set.contains(&t1));
    }
}
