// 08-ecosystem-and-crates — serde + serde_json exercise.

use serde::{Deserialize, Serialize};

/// A simple user struct that we'll serialize and deserialize.
#[derive(Debug, Serialize, Deserialize, PartialEq)]
pub struct User {
    pub id: u32,
    pub name: String,
    pub email: String,
}

/// Serialize a User to a JSON string.
pub fn serialize_user(user: &User) -> String {
    serde_json::to_string(user).unwrap()
}

/// Deserialize a User from a JSON string.
pub fn deserialize_user(json: &str) -> Result<User, serde_json::Error> {
    serde_json::from_str(json)
}

/// Serialize a Vec<User> to a JSON array string.
pub fn serialize_users(users: &[User]) -> String {
    serde_json::to_string(users).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn serialize_and_deserialize_roundtrip() {
        let user = User {
            id: 1,
            name: "Alice".to_string(),
            email: "alice@example.com".to_string(),
        };
        let json = serialize_user(&user);
        let deserialized = deserialize_user(&json).unwrap();
        assert_eq!(user, deserialized);
    }

    #[test]
    fn serialize_users_array() {
        let users = vec![
            User { id: 1, name: "A".to_string(), email: "a@b.com".to_string() },
            User { id: 2, name: "B".to_string(), email: "b@c.com".to_string() },
        ];
        let json = serialize_users(&users);
        let parsed: Vec<User> = serde_json::from_str(&json).unwrap();
        assert_eq!(parsed.len(), 2);
    }

    #[test]
    fn deserialize_invalid_json_returns_err() {
        let result = deserialize_user("not json");
        assert!(result.is_err());
    }
}
