(* 09 — Full tiny compiler *)

open Ast
open Lexer
open Parser
open Evaluator

let compile_and_run input =
  match parse input with
  | Ok (ast, [EOF]) ->
    Printf.printf "AST: %s\n" (expr_to_string ast);
    (match eval ast with
     | Ok result -> Printf.printf "Result: %d\n" result
     | Error msg -> Printf.printf "Runtime error: %s\n" msg)
  | Ok (_, _) -> Printf.printf "Parsing error: tokens remaining\n"
  | Error err -> Printf.printf "Parse error: %s\n" err.message

let () =
  Printf.printf "=== Tiny Compiler ===\n";
  Printf.printf "\nTest 1: 1 + 2\n";
  compile_and_run "1 + 2";
  
  Printf.printf "\nTest 2: 3 + 4 * 2\n";
  compile_and_run "3 + 4 * 2";
  
  Printf.printf "\nTest 3: (2 + 3) * 4\n";
  compile_and_run "(2 + 3) * 4";
  
  Printf.printf "\nTest 4: 10 / 2\n";
  compile_and_run "10 / 2"
