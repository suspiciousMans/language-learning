(* 01-basics: basic tests *)

open OUnit2

let test_double _ =
  assert_equal 10 (Ops.double 5)

let test_add _ =
  assert_equal 7 (Ops.add 3 4)

let test_fact _ =
  assert_equal 120 (Ops.fact 5)

let test_fact_tail _ =
  assert_equal 120 (Ops.fact_tail 5)

let test_length _ =
  assert_equal 3 (Ops.length [1; 2; 3]);
  assert_equal 0 (Ops.length [])

let test_sum_list _ =
  assert_equal 6 (Ops.sum_list [1; 2; 3])

let test_describe_number _ =
  assert_equal "zero" (Ops.describe_number 0);
  assert_equal "one" (Ops.describe_number 1);
  assert_equal "many" (Ops.describe_number 99)

let test_if_max _ =
  assert_equal 7 (Ops.max 3 7);
  assert_equal 7 (Ops.max 7 3)

let test_sign _ =
  assert_equal -1 (Ops.sign (-5));
  assert_equal 0 (Ops.sign 0);
  assert_equal 1 (Ops.sign 5)

let () =
  run_test_tt_main [
    "double" >:: test_double;
    "add" >:: test_add;
    "fact" >:: test_fact;
    "fact_tail" >:: test_fact_tail;
    "length" >:: test_length;
    "sum_list" >:: test_sum_list;
    "describe_number" >:: test_describe_number;
    "max" >:: test_if_max;
    "sign" >:: test_sign;
  ]
