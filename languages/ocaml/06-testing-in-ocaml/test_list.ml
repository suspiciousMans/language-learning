(* 06 — Tests for list functions *)

open OUnit2

let test_remove_duplicates_basic _ =
  assert_equal [1; 2; 3] (List_functions.remove_duplicates [1; 1; 2; 2; 3])

let test_remove_duplicates_no_dups _ =
  assert_equal [1; 2; 3] (List_functions.remove_duplicates [1; 2; 3])

let test_remove_duplicates_empty _ =
  assert_equal [] (List_functions.remove_duplicates [])

let test_flatten_one _ =
  assert_equal [1; 2; 3; 4]
    (List_functions.flatten_one [[1; 2]; [3; 4]])

let test_flatten_one_empty _ =
  assert_equal [] (List_functions.flatten_one [])

let test_intersperse _ =
  assert_equal [1; 0; 2; 0; 3]
    (List_functions.intersperse 0 [1; 2; 3])

let test_intersperse_single _ =
  assert_equal [1] (List_functions.intersperse 0 [1])

let test_intersperse_empty _ =
  assert_equal [] (List_functions.intersperse 0 [])

let test_take _ =
  assert_equal [1; 2; 3] (List_functions.take 3 [1; 2; 3; 4; 5])

let test_take_more_than_length _ =
  assert_equal [1; 2] (List_functions.take 5 [1; 2])

let test_take_zero _ =
  assert_equal [] (List_functions.take 0 [1; 2; 3])

let test_drop _ =
  assert_equal [3; 4; 5] (List_functions.drop 2 [1; 2; 3; 4; 5])

let test_drop_more_than_length _ =
  assert_equal [] (List_functions.drop 5 [1; 2])

let test_drop_zero _ =
  assert_equal [1; 2; 3] (List_functions.drop 0 [1; 2; 3])

let suite = [
  "remove_duplicates_basic" >:: test_remove_duplicates_basic;
  "remove_duplicates_no_dups" >:: test_remove_duplicates_no_dups;
  "remove_duplicates_empty" >:: test_remove_duplicates_empty;
  "flatten_one" >:: test_flatten_one;
  "flatten_one_empty" >:: test_flatten_one_empty;
  "intersperse" >:: test_intersperse;
  "intersperse_single" >:: test_intersperse_single;
  "intersperse_empty" >:: test_intersperse_empty;
  "take" >:: test_take;
  "take_more_than_length" >:: test_take_more_than_length;
  "take_zero" >:: test_take_zero;
  "drop" >:: test_drop;
  "drop_more_than_length" >:: test_drop_more_than_length;
  "drop_zero" >:: test_drop_zero;
]

let () = run_test_tt_main suite
