(* 02 — Tests for ADTs *)

open OUnit2

let test_area_circle _ =
  assert_equal 314.1592653589793 (Ops.area (Circle 10.)) ~printer:(fun f -> Printf.sprintf "%f" f)

let test_area_rectangle _ =
  assert_equal 20. (Ops.area (Rectangle (4., 5.)))

let test_classify_negative _ =
  assert_equal "negative" (Ops.classify_int (-5))

let test_classify_zero _ =
  assert_equal "zero" (Ops.classify_int 0)

let test_classify_even _ =
  assert_equal "positive even" (Ops.classify_int 4)

let test_classify_odd _ =
  assert_equal "positive odd" (Ops.classify_int 7)

let test_flatten_empty _ =
  assert_equal [] (Ops.flatten Leaf)

let test_flatten_single _ =
  assert_equal [1] (Ops.flatten (Node (1, Leaf, Leaf)))

let test_flatten_tree _ =
  let t = Node (2, Node (1, Leaf, Leaf), Node (3, Leaf, Leaf)) in
  assert_equal [1; 2; 3] (Ops.flatten t)

let test_tree_height_empty _ =
  assert_equal 0 (Ops.tree_height Leaf)

let test_tree_height_small _ =
  let t = Node (1, Leaf, Leaf) in
  assert_equal 1 (Ops.tree_height t)

let test_tree_mem_found _ =
  let t = Node (2, Node (1, Leaf, Leaf), Node (3, Leaf, Leaf)) in
  assert_bool "mem 2" (Ops.tree_mem 2 t);
  assert_bool "mem 1" (Ops.tree_mem 1 t)

let test_tree_mem_not_found _ =
  let t = Node (2, Node (1, Leaf, Leaf), Node (3, Leaf, Leaf)) in
  assert_bool "not mem 4" (not (Ops.tree_mem 4 t))

let test_tree_insert _ =
  let t = Ops.tree_insert 2 Leaf in
  let t = Ops.tree_insert 1 t in
  let t = Ops.tree_insert 3 t in
  assert_bool "mem 1 after insert" (Ops.tree_mem 1 t);
  assert_bool "mem 2 after insert" (Ops.tree_mem 2 t);
  assert_bool "mem 3 after insert" (Ops.tree_mem 3 t)

let () =
  run_test_tt_main [
    "area_circle" >:: test_area_circle;
    "area_rectangle" >:: test_area_rectangle;
    "classify_negative" >:: test_classify_negative;
    "classify_zero" >:: test_classify_zero;
    "classify_even" >:: test_classify_even;
    "classify_odd" >:: test_classify_odd;
    "flatten_empty" >:: test_flatten_empty;
    "flatten_single" >:: test_flatten_single;
    "flatten_tree" >:: test_flatten_tree;
    "tree_height_empty" >:: test_tree_height_empty;
    "tree_height_small" >:: test_tree_height_small;
    "tree_mem_found" >:: test_tree_mem_found;
    "tree_mem_not_found" >:: test_tree_mem_not_found;
    "tree_insert" >:: test_tree_insert;
  ]
