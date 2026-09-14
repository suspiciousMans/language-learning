(* 09 — Test module for tiny compiler *)

open OUnit2
open Ast
open Lexer
open Parser
open Evaluator

let test_lex_simple _ =
  let tokens = lex "1 + 2" in
  assert_equal (Int 1 :: Plus :: Int 2 :: [EOF])
    (List.filter (fun t -> t <> EOF) tokens @ [EOF])

let test_lex_operators _ =
  let tokens = lex "3 * 4 / 5" in
  assert_bool "contains Star" (List.mem Star tokens);
  assert_bool "contains Slash" (List.mem Slash tokens)

let test_parse_simple _ =
  match parse "2 + 3" with
  | Ok (ast, _) ->
    assert_equal (BinOp (Num 2, Add, Num 3)) ast
  | Error _ -> assert_failure "parse failed"

let test_parse_precedence _ =
  match parse "2 + 3 * 4" with
  | Ok (ast, _) ->
    let expected = BinOp (Num 2, Add, BinOp (Num 3, Mul, Num 4)) in
    assert_equal expected ast
  | Error _ -> assert_failure "parse failed"

let test_parse_parens _ =
  match parse "(2 + 3) * 4" with
  | Ok (ast, _) ->
    let expected = BinOp (BinOp (Num 2, Add, Num 3), Mul, Num 4) in
    assert_equal expected ast
  | Error _ -> assert_failure "parse failed"

let test_eval_add _ =
  assert_equal (Ok 5) (eval (BinOp (Num 2, Add, Num 3)))

let test_eval_mul _ =
  assert_equal (Ok 6) (eval (BinOp (Num 2, Mul, Num 3)))

let test_eval_div _ =
  assert_equal (Ok 2) (eval (BinOp (Num 4, Div, Num 2)))

let test_eval_div_by_zero _ =
  match eval (BinOp (Num 4, Div, Num 0)) with
  | Error "division by zero" -> ()
  | _ -> assert_failure "expected division by zero error"

let test_eval_complex _ =
  (* 3 + 4 * 2 = 3 + 8 = 11 *)
  let ast = BinOp (Num 3, Add, BinOp (Num 4, Mul, Num 2)) in
  assert_equal (Ok 11) (eval ast)

let suite = [
  "lex_simple" >:: test_lex_simple;
  "lex_operators" >:: test_lex_operators;
  "parse_simple" >:: test_parse_simple;
  "parse_precedence" >:: test_parse_precedence;
  "parse_parens" >:: test_parse_parens;
  "eval_add" >:: test_eval_add;
  "eval_mul" >:: test_eval_mul;
  "eval_div" >:: test_eval_div;
  "eval_div_by_zero" >:: test_eval_div_by_zero;
  "eval_complex" >:: test_eval_complex;
]

let () = run_test_tt_main suite
