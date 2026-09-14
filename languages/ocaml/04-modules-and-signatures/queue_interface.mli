(* 04 — Queue interface *)

type 'a t

val create : unit -> 'a t
val push : 'a -> 'a t -> unit
val pop : 'a t -> 'a option
val is_empty : 'a t -> bool
val length : 'a t -> int
