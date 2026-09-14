(* 09 — Evaluator for tiny language *)

open Ast

(* TODO:
   - Write `eval expr` that computes the value of an AST.
   - Handle division by zero gracefully (return error).
   - Support variables (store in a map).
   - Support if/then/else (truthy: non-zero).
*)

let rec eval expr =
  match expr with
  | Num i -> Ok i
  | BinOp (e1, op, e2) ->
    (match eval e1, eval e2 with
     | Ok i1, Ok i2 ->
       (match op with
        | Add -> Ok (i1 + i2)
        | Sub -> Ok (i1 - i2)
        | Mul -> Ok (i1 * i2)
        | Div ->
          if i2 = 0 then Error "division by zero"
          else Ok (i1 / i2))
     | Error e, _ | _, Error e -> Error e)
  | Var _ -> Error "undefined variable"
  | IfThenElse (cond, e1, e2) ->
    (match eval cond with
     | Ok i -> if i <> 0 then eval e1 else eval e2
     | Error e -> Error e)

let () =
  let ast = BinOp (Num 3, Add, BinOp (Num 4, Mul, Num 2)) in
  match eval ast with
  | Ok result -> Printf.printf "Evaluation: %d\n" result
  | Error msg -> Printf.printf "Error: %s\n" msg
