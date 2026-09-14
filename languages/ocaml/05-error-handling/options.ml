(* 05 — Working with Option types *)

(* TODO:
   - Write `safe_head lst` that returns the first element or None.
   - Write `safe_nth n lst` that safely accesses the nth element.
   - Write `map_option f opt` that transforms Some x to Some (f x).
   - Write `option_to_string f opt` that converts Some x to string f x, None to "None".
   - Write `flatten_option opt_opt` that converts Some (Some x) to Some x, etc.
   - Understand: option is for optional values, not for errors.
*)

let safe_div x y =
  if y = 0 then None else Some (x / y)

let option_unwrap ~default opt =
  match opt with
  | Some x -> x
  | None -> default

let () =
  match safe_div 10 2 with
  | Some result -> Printf.printf "10 / 2 = %d\n" result
  | None -> Printf.printf "Division by zero\n";
  
  let value = option_unwrap ~default:0 (safe_div 10 0) in
  Printf.printf "With default: %d\n" value
