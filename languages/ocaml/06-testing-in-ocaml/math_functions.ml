(* 06 — Math functions to test *)

(* TODO:
   - Write `square x` that returns x * x.
   - Write `is_prime n` that checks if n is prime.
   - Write `gcd a b` using Euclidean algorithm.
   - Write `factorial n` that returns n!.
*)

let square x = x * x

let is_prime n =
  if n < 2 then false
  else if n = 2 then true
  else if n mod 2 = 0 then false
  else
    let rec check i =
      if i * i > n then true
      else if n mod i = 0 then false
      else check (i + 2)
    in
    check 3

let rec gcd a b =
  if b = 0 then a else gcd b (a mod b)

let factorial n =
  if n < 0 then raise (Invalid_argument "factorial of negative")
  else
    let rec loop n acc =
      if n = 0 then acc else loop (n - 1) (n * acc)
    in
    loop n 1
