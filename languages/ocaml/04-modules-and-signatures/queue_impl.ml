(* 04 — Queue implementation *)

type 'a t = {
  mutable head: 'a list;
  mutable tail: 'a list;
}

let create () = { head = []; tail = [] }

let is_empty q = q.head = [] && q.tail = []

let push x q =
  q.tail <- x :: q.tail

let pop q =
  match q.head with
  | x :: rest -> q.head <- rest; Some x
  | [] ->
    match List.rev q.tail with
    | [] -> None
    | x :: rest -> q.head <- rest; q.tail <- []; Some x

let length q = List.length q.head + List.length q.tail

(* TODO:
   - Write tests for queue operations.
   - Understand why the internal representation is hidden by queue_interface.mli.
   - Extend the signature with `peek` (return front element without removing).
   - Add a `clear` operation to empty the queue.
*)

let () =
  let q = create () in
  push 1 q;
  push 2 q;
  push 3 q;
  match pop q with
  | Some x -> Printf.printf "Popped: %d, remaining: %d\n" x (length q)
  | None -> Printf.printf "Queue is empty\n"
