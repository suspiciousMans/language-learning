(* 04 — Tests for modules *)

open OUnit2

let test_stack_push_pop _ =
  let s = Module_ops.Stack_ops.create () in
  Module_ops.Stack_ops.push 1 s;
  Module_ops.Stack_ops.push 2 s;
  assert_equal (Some 2) (Module_ops.Stack_ops.pop s)

let test_stack_length _ =
  let s = Module_ops.Stack_ops.create () in
  Module_ops.Stack_ops.push 10 s;
  Module_ops.Stack_ops.push 20 s;
  assert_equal 2 (Module_ops.Stack_ops.length s)

let test_queue_fifo _ =
  let q = Module_ops.Queue_ops.create () in
  Module_ops.Queue_ops.push 1 q;
  Module_ops.Queue_ops.push 2 q;
  Module_ops.Queue_ops.push 3 q;
  assert_equal (Some 1) (Module_ops.Queue_ops.pop q);
  assert_equal (Some 2) (Module_ops.Queue_ops.pop q)

let test_queue_length _ =
  let q = Module_ops.Queue_ops.create () in
  Module_ops.Queue_ops.push 5 q;
  Module_ops.Queue_ops.push 6 q;
  assert_equal 2 (Module_ops.Queue_ops.length q)

let () =
  run_test_tt_main [
    "stack_push_pop" >:: test_stack_push_pop;
    "stack_length" >:: test_stack_length;
    "queue_fifo" >:: test_queue_fifo;
    "queue_length" >:: test_queue_length;
  ]
