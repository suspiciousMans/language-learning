(* 03 — Partial application and currying *)

(* Curried addition: takes one argument at a time *)
let add x y = x + y

(* Partially apply add by fixing the first argument *)
let add_five = add 5

(* A curried multiply function *)
let multiply x y = x * y
let multiply_by_three = multiply 3

(* TODO:
   - Write `power base exponent` and then partially apply it: `square = power ? 2`, `cube = power ? 3`.
   - Write `string_replace old new` that returns a function taking a string and doing the replacement.
   - Write `repeat n` that returns a function taking a string and repeating it n times.
   - Understand: partial application naturally falls out of currying.
   - Write `apply_to_all fns x` that applies each function in the list to x.
   - Write `call_with_default f default` that returns a function using default if the argument is None.
*)

let () =
  Printf.printf "add_five 10 = %d\n" (add_five 10);
  Printf.printf "multiply_by_three 7 = %d\n" (multiply_by_three 7);
  
  (* We can also create partials inline *)
  let add_one = add 1 in
  let add_two = add 2 in
  Printf.printf "add_one 99 = %d\n" (add_one 99);
  Printf.printf "add_two 99 = %d\n" (add_two 99)
