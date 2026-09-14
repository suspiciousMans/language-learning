(* 08 — String utility library *)

(* TODO:
   - Write `capitalize_words s` that capitalizes each word.
   - Write `split_on_char c s` that splits a string on a character.
   - Write `trim_whitespace s` that removes leading/trailing whitespace.
   - Write `to_snake_case s` that converts "HelloWorld" to "hello_world".
   - Write `reverse_string s` that reverses a string.
*)

let capitalize_words s =
  let words = String.split_on_char ' ' s in
  let capitalized = List.map String.capitalize_ascii words in
  String.concat " " capitalized

let split_on_char c s =
  String.split_on_char c s

let trim_whitespace s =
  String.trim s

let reverse_string s =
  let chars = String.to_seq s |> List.of_seq in
  List.rev chars |> List.to_seq |> String.of_seq

let to_snake_case s =
  let rec loop acc = function
    | [] -> String.concat "" (List.rev acc)
    | c :: rest when Char.uppercase_ascii c = c && acc <> [] ->
      loop (["_"; String.make 1 (Char.lowercase_ascii c)] @ acc) rest
    | c :: rest ->
      loop ([String.make 1 (Char.lowercase_ascii c)] @ acc) rest
  in
  let chars = String.to_seq s |> List.of_seq in
  loop [] chars
