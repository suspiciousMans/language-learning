(* 05 — Working with Result types *)

(* TODO:
   - Write `parse_int str` that returns Ok int or Error string.
   - Write `validate_age age` that checks age >= 0 and age <= 150.
   - Write `result_map f res` that transforms Ok x to Ok (f x).
   - Write `result_bind f res` that chains operations.
   - Write `result_fold ~ok ~error res` that extracts the value.
   - Understand: result includes error information, option doesn't.
*)

let safe_div x y =
  if y = 0 then Error "division by zero" else Ok (x / y)

let result_unwrap ~default res =
  match res with
  | Ok x -> x
  | Error _ -> default

let () =
  match safe_div 10 2 with
  | Ok result -> Printf.printf "10 / 2 = %d\n" result
  | Error msg -> Printf.printf "Error: %s\n" msg;
  
  let value = result_unwrap ~default:0 (safe_div 10 0) in
  Printf.printf "With default: %d\n" value
