(* 05 — Tests for error handling *)

open OUnit2

let test_safe_div_ok _ =
  assert_equal (Ok 5) (Error_ops.safe_div 10 2)

let test_safe_div_error _ =
  match Error_ops.safe_div 10 0 with
  | Ok _ -> assert_failure "Should be Error"
  | Error msg -> assert_equal "division by zero" msg

let test_parse_int_ok _ =
  assert_equal (Ok 42) (Error_ops.parse_int "42")

let test_parse_int_error _ =
  match Error_ops.parse_int "not_a_number" with
  | Ok _ -> assert_failure "Should be Error"
  | Error msg -> assert_equal "not an integer" msg

let test_validate_positive_ok _ =
  assert_equal (Ok 5) (Error_ops.validate_positive 5)

let test_validate_positive_error _ =
  match Error_ops.validate_positive (-5) with
  | Ok _ -> assert_failure "Should be Error"
  | Error msg -> assert_equal "must be positive" msg

let test_chain_operations_success _ =
  assert_equal (Ok 30) (Error_ops.chain_operations "10" "20")

let test_chain_operations_failure _ =
  match Error_ops.chain_operations "10" "not_a_number" with
  | Ok _ -> assert_failure "Should be Error"
  | Error msg -> assert_equal "not an integer" msg

let () =
  run_test_tt_main [
    "safe_div_ok" >:: test_safe_div_ok;
    "safe_div_error" >:: test_safe_div_error;
    "parse_int_ok" >:: test_parse_int_ok;
    "parse_int_error" >:: test_parse_int_error;
    "validate_positive_ok" >:: test_validate_positive_ok;
    "validate_positive_error" >:: test_validate_positive_error;
    "chain_operations_success" >:: test_chain_operations_success;
    "chain_operations_failure" >:: test_chain_operations_failure;
  ]
