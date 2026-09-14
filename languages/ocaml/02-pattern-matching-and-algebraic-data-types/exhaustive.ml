(* 02 — Exhaustive pattern matching, when clauses, nested patterns *)

type shape =
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float * float

type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

(* exhaustive match on shape *)
let area s =
  match s with
  | Circle r -> Float.pi *. r *. r
  | Rectangle (w, h) -> w *. h
  | Triangle (a, b, c) ->
    let s = (a +. b +. c) /. 2. in
    sqrt (s *. (s -. a) *. (s -. b) *. (s -. c))

(* when clause *)
let classify_int n =
  match n with
  | n when n < 0 -> "negative"
  | 0 -> "zero"
  | n when n mod 2 = 0 -> "positive even"
  | _ -> "positive odd"

(* nested patterns *)
let rec flatten t =
  match t with
  | Leaf -> []
  | Node (v, Leaf, Leaf) -> [v]
  | Node (v, left, right) -> flatten left @ [v] @ flatten right

(* EXERCISE:
   - Add a Square of float constructor to shape; update area.
   - Write `is_circle s` using a pattern.
   - Write `describe_shape s` that returns a string description.
   - Write `tree_height t` that returns the height of a tree.
   - Write `tree_mem x t` that returns true if x is in the tree.
   - Write `tree_insert x t` for a BST (assume int tree).
   - Write a function that matches on (shape * int) and returns a string.
   - Write a function with a when clause that returns true only for positive even numbers > 10.
*)
