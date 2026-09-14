// 05-error-handling — custom error types via enums

use std::fmt;

/// A custom error type for our application.
#[derive(Debug)]
pub enum AppError {
    NotFound(String),
    InvalidInput(String),
    IoError(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            AppError::NotFound(msg) => write!(f, "not found: {}", msg),
            AppError::InvalidInput(msg) => write!(f, "invalid input: {}", msg),
            AppError::IoError(msg) => write!(f, "io error: {}", msg),
        }
    }
}

impl std::error::Error for AppError {}

/// A function that returns a Result with our custom error type.
pub fn find_user(id: u32) -> Result<String, AppError> {
    if id == 0 {
        return Err(AppError::InvalidInput("id must be positive".to_string()));
    }
    if id > 100 {
        return Err(AppError::NotFound(format!("user {}", id)));
    }
    Ok(format!("user-{}", id))
}

/// A function that may produce an IO-like error (simulated).
pub fn read_file_simulated(path: &str) -> Result<String, AppError> {
    if path.is_empty() {
        return Err(AppError::IoError("empty path".to_string()));
    }
    if path.contains("forbidden") {
        return Err(AppError::NotFound(format!("cannot access {}", path)));
    }
    Ok(format!("contents of {}", path))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn find_user_valid() {
        let result = find_user(5);
        assert!(result.is_ok());
        assert_eq!(result.unwrap(), "user-5");
    }

    #[test]
    fn find_user_zero_is_invalid() {
        let err = find_user(0).unwrap_err();
        assert!(matches!(err, AppError::InvalidInput(_)));
    }

    #[test]
    fn find_user_too_large_is_not_found() {
        let err = find_user(200).unwrap_err();
        assert!(matches!(err, AppError::NotFound(_)));
    }

    #[test]
    fn read_file_simulated_empty_path() {
        let err = read_file_simulated("").unwrap_err();
        assert!(matches!(err, AppError::IoError(_)));
    }

    #[test]
    fn read_file_simulated_forbidden() {
        let err = read_file_simulated("/forbidden/data").unwrap_err();
        assert!(matches!(err, AppError::NotFound(_)));
    }

    #[test]
    fn read_file_simulated_ok() {
        let content = read_file_simulated("/etc/hosts").unwrap();
        assert!(content.contains("/etc/hosts"));
    }
}
