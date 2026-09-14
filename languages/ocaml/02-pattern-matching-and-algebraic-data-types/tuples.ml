(* 02 — Tuple types *)

(* Tuples are anonymous products. Access with fst/snd or pattern matching. *)

let swap (a, b) = (b, a)

let add_coords (x1, y1) (x2, y2) = (x1 +. x2, y1 +. y2)

(* EXERCISE:
   - Write `divmod a b` that returns (quotient, remainder) using / and mod.
   - Write `norm (x, y)` that returns sqrt(x*x + y*y).
   - Write `scale k (x, y)` that returns (k*x, k*y).
   - Write `zip a b` that takes two lists and returns a list of pairs (stops at the shorter list).
   - Write `unzip lst` that takes a list of pairs and returns two lists.
   - Write `sorted_pair (a, b)` that returns (min, max).
   - Write a function that takes a (string * int * bool) triple and formats it.
*)
