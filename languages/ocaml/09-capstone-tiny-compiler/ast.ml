(* 09 — Abstract syntax tree *)

type expr =
  | Num of int
  | BinOp of expr * op * expr
  | Var of string
  | IfThenElse of expr * expr * expr

and op =
  | Add
  | Sub
  | Mul
  | Div

let rec expr_to_string = function
  | Num i -> string_of_int i
  | BinOp (e1, op, e2) ->
    Printf.sprintf "(%s %s %s)"
      (expr_to_string e1)
      (op_to_string op)
      (expr_to_string e2)
  | Var name -> name
  | IfThenElse (cond, e1, e2) ->
    Printf.sprintf "(if %s then %s else %s)"
      (expr_to_string cond)
      (expr_to_string e1)
      (expr_to_string e2)

and op_to_string = function
  | Add -> "+"
  | Sub -> "-"
  | Mul -> "*"
  | Div -> "/"
