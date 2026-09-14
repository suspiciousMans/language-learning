(* 02 — Exercise operations module (for tests) *)

type shape =
  | Circle of float
  | Rectangle of float * float
  | Triangle of float * float * float

type 'a tree =
  | Leaf
  | Node of 'a * 'a tree * 'a tree

let area s =
  match s with
  | Circle r -> Float.pi *. r *. r
  | Rectangle (w, h) -> w *. h
  | Triangle (a, b, c) ->
    let s = (a +. b +. c) /. 2. in
    sqrt (s *. (s -. a) *. (s -. b) *. (s -. c))

let classify_int n =
  match n with
  | n when n < 0 -> "negative"
  | 0 -> "zero"
  | n when n mod 2 = 0 -> "positive even"
  | _ -> "positive odd"

let rec flatten t =
  match t with
  | Leaf -> []
  | Node (v, Leaf, Leaf) -> [v]
  | Node (v, left, right) -> flatten left @ [v] @ flatten right

let rec tree_height t =
  match t with
  | Leaf -> 0
  | Node (_, left, right) -> 1 + max (tree_height left) (tree_height right)

let rec tree_mem x t =
  match t with
  | Leaf -> false
  | Node (v, left, right) ->
    if x = v then true
    else tree_mem x left || tree_mem x right

let rec tree_insert x t =
  match t with
  | Leaf -> Node (x, Leaf, Leaf)
  | Node (v, left, right) ->
    if x < v then Node (v, tree_insert x left, right)
    else if x > v then Node (v, left, tree_insert x right)
    else t
