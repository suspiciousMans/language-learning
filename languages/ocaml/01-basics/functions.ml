(* 01-basics: functions *)

(* TODO: define functions and call them *)

(* A simple function: takes an int, returns an int *)
let double x = x * 2

(* A function with two arguments *)
let add a b = a + b

(* A recursive function — factorial *)
let rec fact n =
  if n <= 1 then 1
  else n * fact (n - 1)

(* EXERCISE:
   - Write `square x` that returns x * x.
   - Write `is_even n` that returns true if n is even.
   - Write `gcd a b` using Euclid's algorithm (recursive).
   - Write a function `compose f g x` that returns f (g x).
*)
