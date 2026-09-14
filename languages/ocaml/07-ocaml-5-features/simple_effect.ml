(* 07 — Simple effect *)

(* Define an effect that asks for a number *)
effect Ask_int : int

(* TODO:
   - Write a function that uses perform Ask_int.
   - Write a handler that catches Ask_int.
   - Call the function with the handler.
   - Extend: define Ask_string effect.
   - Understand: effects are like throwing, but the handler can resume.
*)

let ask_for_number () =
  let n = perform Ask_int in
  Printf.printf "Got number: %d\n" n;
  n * 2

let run_with_handler () =
  match ask_for_number () with
  | effect Ask_int k ->
    (* k is the continuation; calling it resumes with a value *)
    let answer = 42 in
    continue k answer
  | n -> Printf.printf "Result: %d\n" n

let () = run_with_handler ()
