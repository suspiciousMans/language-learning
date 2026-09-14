// 03-data-structures — HashMap<K, V> and HashSet<T>

use std::collections::{HashMap, HashSet};

/// Build a HashMap from a Vec of (key, value) pairs.
pub fn build_map(pairs: Vec<(&str, i32)>) -> HashMap<String, i32> {
    pairs.into_iter().map(|(k, v)| (k.to_string(), v)).collect()
}

/// Look up a key in the map. Return Some(value) if present, else None.
pub fn lookup(map: &HashMap<String, i32>, key: &str) -> Option<i32> {
    map.get(key).copied()
}

/// Return the set of all unique values present in the HashMap.
pub fn unique_values(map: &HashMap<String, i32>) -> HashSet<i32> {
    map.values().copied().collect()
}

/// Given two slices, return the intersection of their elements as a HashSet.
pub fn intersection(a: &[i32], b: &[i32]) -> HashSet<i32> {
    a.iter().copied().collect::<HashSet<_>>().intersection(&b.iter().copied().collect::<HashSet<_>>()).copied().collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn build_map_and_lookup() {
        let map = build_map(vec![("a", 1), ("b", 2), ("c", 3)]);
        assert_eq!(lookup(&map, "b"), Some(2));
        assert_eq!(lookup(&map, "z"), None);
    }

    #[test]
    fn unique_values_returns_set() {
        let map = build_map(vec![("a", 1), ("b", 2), ("c", 1)]);
        let uniq = unique_values(&map);
        assert!(uniq.contains(&1));
        assert!(uniq.contains(&2));
        assert_eq!(uniq.len(), 2);
    }

    #[test]
    fn intersection_of_two_slices() {
        let a = vec![1, 2, 3, 4];
        let b = vec![3, 4, 5, 6];
        let inter = intersection(&a, &b);
        assert!(inter.contains(&3));
        assert!(inter.contains(&4));
        assert_eq!(inter.len(), 2);
    }
}
