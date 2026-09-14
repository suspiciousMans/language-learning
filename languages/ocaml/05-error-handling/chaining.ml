(* 05 — Chaining operations *)

(* TODO:
   - Write `parse_int str` returning result.
   - Chain parse_int with another operation using bind.
   - Write `string_of_result to_string res` to display results.
   - Understand: bind lets you avoid nested matches.
   - Understand: each step can fail and short-circuit the chain.
*)

let add x y = x + y

let parse_int str =
  try Ok (int_of_string str) with _ -> Error "not an integer"

let chain_parse_operation s1 s2 =
  match parse_int s1 with
  | Error e -> Error e
  | Ok x ->
    match parse_int s2 with
    | Error e -> Error e
    | Ok y -> Ok (add x y)

(* Better with bind *)
let chain_with_bind s1 s2 =
  let open Result in
  let* x = parse_int s1 in
  let* y = parse_int s2 in
  Ok (add x y)

let () =
  match chain_with_bind "10" "20" with
  | Ok sum -> Printf.printf "Sum: %d\n" sum
  | Error msg -> Printf.printf "Error: %s\n" msg;
  
  match chain_with_bind "10" "not_a_number" with
  | Ok sum -> Printf.printf "Sum: %d\n" sum
  | Error msg -> Printf.printf "Error: %s\n" msg
