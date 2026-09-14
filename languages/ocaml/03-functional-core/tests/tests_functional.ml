(* 03 — Tests for functional core *)

open OUnit2

let test_sum_list _ =
  assert_equal 15 (Ops.sum_list [1; 2; 3; 4; 5])

let test_product_list _ =
  assert_equal 120 (Ops.product_list [1; 2; 3; 4; 5])

let test_all_positive _ =
  assert_bool "all positive" (Ops.all_positive [1; 2; 3]);
  assert_bool "not all positive" (not (Ops.all_positive [1; -2; 3]))

let test_find_even _ =
  assert_equal (Some 2) (Ops.find_even [1; 2; 3; 4])

let test_count_evens _ =
  assert_equal 2 (Ops.count_evens [1; 2; 3; 4; 5])

let test_reverse_list _ =
  assert_equal [5; 4; 3; 2; 1] (Ops.reverse_list [1; 2; 3; 4; 5])

let test_apply_n _ =
  let inc = fun x -> x + 1 in
  assert_equal 8 (Ops.apply_n inc 5 3)

let test_compose _ =
  let inc = fun x -> x + 1 in
  let double = fun x -> x * 2 in
  assert_equal 12 (Ops.compose double inc 5)

let () =
  run_test_tt_main [
    "sum_list" >:: test_sum_list;
    "product_list" >:: test_product_list;
    "all_positive" >:: test_all_positive;
    "find_even" >:: test_find_even;
    "count_evens" >:: test_count_evens;
    "reverse_list" >:: test_reverse_list;
    "apply_n" >:: test_apply_n;
    "compose" >:: test_compose;
  ]
