(* 09 — Lexer for tiny language *)

type token =
  | Int of int
  | Plus
  | Minus
  | Star
  | Slash
  | LParen
  | RParen
  | EOF

(* TODO:
   - Write `lex str` that converts a string into a list of tokens.
   - Handle whitespace (skip it).
   - Handle integers (parse digits).
   - Handle operators: +, -, *, /, (, ).
   - Handle EOF.
   - Return an error for unknown characters.
*)

let is_digit c = c >= '0' && c <= '9'
let is_whitespace c = c = ' ' || c = '\n' || c = '\t'

let rec lex str =
  let len = String.length str in
  let rec loop i acc =
    if i >= len then List.rev (EOF :: acc)
    else
      let c = str.[i] in
      if is_whitespace c then
        loop (i + 1) acc
      else if is_digit c then
        let j = ref i in
        let num = ref 0 in
        while !j < len && is_digit str.[!j] do
          num := !num * 10 + (Char.code str.[!j] - Char.code '0');
          incr j
        done;
        loop !j (Int !num :: acc)
      else
        let token = match c with
          | '+' -> Plus
          | '-' -> Minus
          | '*' -> Star
          | '/' -> Slash
          | '(' -> LParen
          | ')' -> RParen
          | _ -> failwith (Printf.sprintf "Unknown character: %c" c)
        in
        loop (i + 1) (token :: acc)
  in
  loop 0 []

let token_to_string = function
  | Int i -> Printf.sprintf "Int(%d)" i
  | Plus -> "Plus"
  | Minus -> "Minus"
  | Star -> "Star"
  | Slash -> "Slash"
  | LParen -> "LParen"
  | RParen -> "RParen"
  | EOF -> "EOF"

let () =
  let input = "1 + 2 * 3" in
  let tokens = lex input in
  Printf.printf "Input: %s\n" input;
  Printf.printf "Tokens: [%s]\n"
    (String.concat "; " (List.map token_to_string tokens))
