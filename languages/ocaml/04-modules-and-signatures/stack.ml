(* 04 — Stack implementation *)

type 'a t = 'a list ref

let create () = ref []

let push x s = s := x :: !s

let pop s =
  match !s with
  | [] -> None
  | x :: rest -> s := rest; Some x

let peek s =
  match !s with
  | [] -> None
  | x :: _ -> Some x

let is_empty s = !s = []

let length s = List.length !s

(* TODO:
   - Test stack operations.
   - Compare the stack and queue implementations.
   - Understand how the signature hides the `ref` type.
   - Write a function that works generically with any module implementing stack_sig.
*)

let () =
  let s = create () in
  push 10 s;
  push 20 s;
  push 30 s;
  match pop s with
  | Some x -> Printf.printf "Popped: %d, remaining: %d\n" x (length s)
  | None -> Printf.printf "Stack is empty\n"
