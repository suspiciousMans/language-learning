(* 02 — Variant types *)

(* A small expression language AST *)
type expr =
  | Int of int
  | Float of float
  | Add of expr * expr
  | Mul of expr * expr
  | Neg of expr

(* TODO: write an evaluator for this expression language *)

let rec eval e =
  match e with
  | Int n -> n
  | Float f -> int_of_float f
  | Add (a, b) -> eval a + eval b
  | Mul (a, b) -> eval a * eval b
  | Neg e -> -(eval e)

(* EXERCISE:
   - Add a `Bool of bool` and `Eq of expr * expr` constructor.
   - Add a `If of expr * expr * expr` (conditional) constructor.
   - Extend eval to handle the new constructors.
   - Write a function `expr_to_string e` that pretty-prints an expression.
   - Write `contains_var e` — for now, always false; later you'll add variables.
*)
