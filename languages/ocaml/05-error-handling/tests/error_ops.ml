(* 05 — Error operations module *)

let safe_div x y =
  if y = 0 then Error "division by zero" else Ok (x / y)

let parse_int str =
  try Ok (int_of_string str) with _ -> Error "not an integer"

let validate_positive x =
  if x > 0 then Ok x else Error "must be positive"

let chain_operations s1 s2 =
  let open Result in
  let* x = parse_int s1 in
  let* y = parse_int s2 in
  let* _ = validate_positive x in
  let* _ = validate_positive y in
  Ok (x + y)
