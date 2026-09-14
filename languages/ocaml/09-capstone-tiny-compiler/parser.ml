(* 09 — Parser for tiny language *)

open Ast
open Lexer

type parse_error = {
  message: string;
  token: token;
}

(* TODO:
   - Write `parse_expr tokens` that builds an AST from tokens.
   - Handle operator precedence: *, / bind tighter than +, -.
   - Handle parentheses.
   - Return a result type.
   - Write helper functions for each precedence level.
*)

let rec parse_expr tokens =
  match parse_add_expr tokens with
  | Ok (expr, rest) -> Ok (expr, rest)
  | error -> error

and parse_add_expr tokens =
  match parse_mul_expr tokens with
  | Ok (e1, Plus :: rest) ->
    (match parse_add_expr rest with
     | Ok (e2, rest) -> Ok (BinOp (e1, Add, e2), rest)
     | error -> error)
  | Ok (e1, Minus :: rest) ->
    (match parse_add_expr rest with
     | Ok (e2, rest) -> Ok (BinOp (e1, Sub, e2), rest)
     | error -> error)
  | other -> other

and parse_mul_expr tokens =
  match parse_primary tokens with
  | Ok (e1, Star :: rest) ->
    (match parse_mul_expr rest with
     | Ok (e2, rest) -> Ok (BinOp (e1, Mul, e2), rest)
     | error -> error)
  | Ok (e1, Slash :: rest) ->
    (match parse_mul_expr rest with
     | Ok (e2, rest) -> Ok (BinOp (e1, Div, e2), rest)
     | error -> error)
  | other -> other

and parse_primary = function
  | Int i :: rest -> Ok (Num i, rest)
  | LParen :: rest ->
    (match parse_expr rest with
     | Ok (expr, RParen :: rest) -> Ok (expr, rest)
     | _ -> Error { message = "expected )"; token = EOF })
  | token :: _ -> Error { message = "expected number"; token }
  | [] -> Error { message = "unexpected EOF"; token = EOF }

let parse str =
  let tokens = lex str in
  parse_expr tokens
