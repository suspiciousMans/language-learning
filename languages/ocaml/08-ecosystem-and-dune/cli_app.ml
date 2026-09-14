(* 08 — CLI application *)

open String_utils

let () =
  (* Use string_utils library *)
  let input = "hello world" in
  let capitalized = capitalize_words input in
  Printf.printf "Input: %s\n" input;
  Printf.printf "Capitalized: %s\n" capitalized;
  
  let words = split_on_char ' ' input in
  Printf.printf "Words: [%s]\n" (String.concat "; " words);
  
  let reversed = reverse_string input in
  Printf.printf "Reversed: %s\n" reversed;
  
  let snake = to_snake_case "HelloWorld" in
  Printf.printf "Snake case: %s\n" snake
