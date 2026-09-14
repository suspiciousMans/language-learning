"""Tests for the 04-error-handling exercises."""

import pathlib
import pytest
import sys

# Make the project folder importable: the exercises live in the same
# directory as this test file's parent (projects/04-error-handling/).
exercise_dir = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(exercise_dir))


# --- Exercise 1: Basic exceptions ---

def test_divide_happy():
    from exercise_1_basic_exceptions import divide
    assert divide(10.0, 2.0) == 5.0
    assert divide(7.0, 2.0) == 3.5


def test_divide_by_zero():
    from exercise_1_basic_exceptions import divide
    with pytest.raises(ValueError, match=".*zero.*"):
        divide(10.0, 0.0)


def test_get_element_happy():
    from exercise_1_basic_exceptions import get_element
    assert get_element([10, 20, 30], 1) == 20


def test_get_element_index_error():
    from exercise_1_basic_exceptions import get_element
    # Should not raise; should print and return None
    result = get_element([10, 20, 30], 99)
    assert result is None


def test_parse_int_happy():
    from exercise_1_basic_exceptions import parse_int
    assert parse_int("42") == 42


def test_parse_int_failure():
    from exercise_1_basic_exceptions import parse_int
    assert parse_int("hello") is None


def test_read_file_happy(tmp_path):
    from exercise_1_basic_exceptions import read_file
    p = tmp_path / "hello.txt"
    p.write_text("hello world\n")
    assert read_file(str(p)) == "hello world\n"


def test_read_file_not_found():
    from exercise_1_basic_exceptions import read_file
    assert read_file("/nonexistent/file.txt") == ""


# --- Exercise 2: Custom exceptions ---

def test_validate_user_happy():
    from exercise_2_custom_exceptions import validate_user
    result = validate_user("Alice", 30)
    assert result == {"name": "Alice", "age": 30}


def test_validate_user_empty_name():
    from exercise_2_custom_exceptions import validate_user, ValidationError
    with pytest.raises(ValidationError):
        validate_user("   ", 30)


def test_validate_user_negative_age():
    from exercise_2_custom_exceptions import validate_user, ValidationError
    with pytest.raises(ValidationError):
        validate_user("Alice", -5)


def test_bank_account_init():
    from exercise_2_custom_exceptions import BankAccount
    acct = BankAccount(100.0)
    assert acct.balance == 100.0


def test_bank_account_negative_init():
    from exercise_2_custom_exceptions import BankAccount
    with pytest.raises(ValueError):
        BankAccount(-10.0)


def test_bank_account_deposit():
    from exercise_2_custom_exceptions import BankAccount
    acct = BankAccount(100.0)
    acct.deposit(50.0)
    assert acct.balance == 150.0


def test_bank_account_withdraw():
    from exercise_2_custom_exceptions import BankAccount
    acct = BankAccount(100.0)
    acct.withdraw(30.0)
    assert acct.balance == 70.0


def test_bank_account_insufficient_funds():
    from exercise_2_custom_exceptions import BankAccount, InsufficientFundsError
    acct = BankAccount(100.0)
    with pytest.raises(InsufficientFundsError):
        acct.withdraw(200.0)


# --- Exercise 3: Context managers ---

def test_timer_runs(capsys):
    from exercise_3_context_managers import timer
    import time
    with timer("test"):
        time.sleep(0.01)
    captured = capsys.readouterr()
    assert "test" in captured.out
    assert "s" in captured.out  # seconds


def test_suppress_errors_catches():
    from exercise_3_context_managers import suppress_errors
    with suppress_errors(ZeroDivisionError):
        1 / 0  # should not propagate
    # If we get here, the exception was suppressed
    assert True


def test_suppress_errors_does_not_catch_other():
    from exercise_3_context_managers import suppress_errors

    # Use a single exception type that is NOT caught to verify
    # suppress_errors only catches the types you pass to it.
    with pytest.raises(ValueError):
        with suppress_errors(ZeroDivisionError):
            raise ValueError("this should propagate")


def test_read_lines_happy(tmp_path):
    from exercise_3_context_managers import read_lines
    p = tmp_path / "lines.txt"
    p.write_text("a\nb\nc\n")
    lines = read_lines(str(p))
    assert lines == ["a", "b", "c"]


def test_read_lines_empty(tmp_path):
    from exercise_3_context_managers import read_lines
    p = tmp_path / "empty.txt"
    p.write_text("")
    assert read_lines(str(p)) == []
