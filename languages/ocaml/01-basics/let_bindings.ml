(* 01-basics: let bindings and basic types *)

(* TODO: bind values of each basic type and print them *)

let () =
  (* int *)
  let x = 42 in
  Printf.printf "int: %d\n" x;

  (* float *)
  let f = 3.14 in
  Printf.printf "float: %f\n" f;

  (* string *)
  let s = "hello OCaml" in
  Printf.printf "string: %s\n" s;

  (* bool *)
  let b = true in
  Printf.printf "bool: %b\n" b;

  (* unit — the only value of type unit is () *)
  let u = () in
  Printf.printf "unit: %s\n" (if u = () then "()" else "nope")

(* EXERCISE:
   - Add a binding for each type.
   - Write a function `greet name` that returns "Hello, " ^ name ^ "!".
   - Call it and print the result.
*)
