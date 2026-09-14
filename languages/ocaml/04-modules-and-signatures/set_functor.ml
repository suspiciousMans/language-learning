(* 04 — Set functor *)

(* Signature for comparable types *)
module type Comparable = sig
  type t
  val compare : t -> t -> int
  val to_string : t -> string
end

(* Functor that builds a Set from a comparable type *)
module Make_set (C : Comparable) = struct
  type elem = C.t
  type t = C.t list (* Invariant: sorted, no duplicates *)

  let create () = []

  let rec add x s =
    match s with
    | [] -> [x]
    | y :: rest ->
      let cmp = C.compare x y in
      if cmp < 0 then x :: s
      else if cmp = 0 then s
      else y :: add x rest

  let rec mem x s =
    match s with
    | [] -> false
    | y :: rest ->
      let cmp = C.compare x y in
      if cmp = 0 then true
      else if cmp < 0 then false
      else mem x rest

  let rec remove x s =
    match s with
    | [] -> []
    | y :: rest ->
      let cmp = C.compare x y in
      if cmp = 0 then rest
      else if cmp < 0 then s
      else y :: remove x rest

  let to_string s =
    "{" ^ String.concat ", " (List.map C.to_string s) ^ "}"
end

(* TODO:
   - Create an IntComparable module.
   - Instantiate Make_set with IntComparable.
   - Test adding, removing, and checking membership.
   - Create a StringComparable module and test it.
*)
