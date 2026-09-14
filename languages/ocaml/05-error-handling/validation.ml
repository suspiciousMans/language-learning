(* 05 — Validation *)

type validation_error =
  | InvalidEmail
  | InvalidAge
  | InvalidPassword

let error_to_string err =
  match err with
  | InvalidEmail -> "Invalid email format"
  | InvalidAge -> "Age must be between 0 and 150"
  | InvalidPassword -> "Password must be at least 8 characters"

(* TODO:
   - Write `validate_email email` checking for "@".
   - Write `validate_age age` checking bounds.
   - Write `validate_password pass` checking length.
   - Build a user validator combining all three.
*)

let validate_email email =
  if String.contains email '@' then Ok email else Error InvalidEmail

let validate_age age =
  if age >= 0 && age <= 150 then Ok age else Error InvalidAge

let validate_password pass =
  if String.length pass >= 8 then Ok pass else Error InvalidPassword

type user = { email: string; age: int; password: string }

let validate_user email age password =
  let open Result in
  let* e = validate_email email in
  let* a = validate_age age in
  let* p = validate_password password in
  Ok { email = e; age = a; password = p }

let () =
  match validate_user "alice@example.com" 30 "secret123" with
  | Ok user -> Printf.printf "Valid user: %s, age %d\n" user.email user.age
  | Error e -> Printf.printf "Error: %s\n" (error_to_string e)
