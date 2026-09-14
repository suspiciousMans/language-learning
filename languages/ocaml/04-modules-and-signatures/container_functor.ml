(* 04 — Container functor *)

(* A functor that takes any container module *)
module type Container = sig
  type 'a t
  val create : unit -> 'a t
  val push : 'a -> 'a t -> unit
  val pop : 'a t -> 'a option
  val is_empty : 'a t -> bool
end

module Container_stats (C : Container) = struct
  type 'a container = 'a C.t

  let push_many c items =
    List.iter (fun item -> C.push item c) items

  let pop_all c =
    let rec loop acc =
      match C.pop c with
      | None -> List.rev acc
      | Some x -> loop (x :: acc)
    in
    loop []

  let count_until_empty c =
    let count = ref 0 in
    while not (C.is_empty c) do
      match C.pop c with
      | Some _ -> incr count
      | None -> ()
    done;
    !count
end

(* TODO:
   - Instantiate the functor with Stack.
   - Instantiate the functor with Queue_impl.
   - Understand how the functor works with both implementations.
   - Write a new functor that filters a container.
*)
