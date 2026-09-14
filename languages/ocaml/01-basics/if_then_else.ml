(* 01-basics: if-then-else *)

(* if-then-else is an expression — it always evaluates to a value *)

let max a b =
  if a > b then a else b

let is_positive n =
  if n > 0 then "positive"
  else if n < 0 then "negative"
  else "zero"

(* EXERCISE:
   - Write `sign n` that returns -1, 0, or 1.
   - Write `abs n` without using Pervasives.abs.
   - Write `grade score` that returns "A" for >= 90, "B" for >= 80, "C" for >= 70, "F" otherwise.
   - Write `describe_temp t` that returns "freezing" below 0, "cold" 0-15, "mild" 15-25, "warm" 25-35, "hot" above 35.
*)
