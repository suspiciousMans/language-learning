(* 01-basics: recursion vs tail recursion *)

(* A basic recursive factorial — not tail recursive *)
let rec fact n =
  if n <= 1 then 1
  else n * fact (n - 1)

(* The same function, tail recursive, using an accumulator *)
let fact_tail n =
  let rec aux n acc =
    if n <= 1 then acc
    else aux (n - 1) (n * acc)
  in
  aux n 1

(* EXERCISE:
   - Write `fib n` recursively (naive, exponential).
   - Write `fib_tail n` in tail-recursive form (linear).
   - Write `sum_range a b` that sums integers from a to b (inclusive), tail recursively.
   - Write `power base exp` that computes base^exp, tail recursively.
   - Write `mult a b` that multiplies a * b using only addition, tail recursively.
   - Benchmark: use Sys.time to compare fact 1000000 vs fact_tail 1000000 (the naive one will stack overflow).
*)
