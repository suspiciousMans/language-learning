(* 03 — Higher-order functions *)

(* A function that takes a function as an argument *)
let apply_twice f x =
  f (f x)

(* TODO:
   - Write `apply_n f x n` that applies function `f` to `x` exactly `n` times.
   - Write `compose f g` that returns a new function: compose f g x = f (g x).
   - Write `call_twice f` that returns a new function that applies `f` twice.
   - Write `filter_map f pred lst` that applies `f` only to elements where `pred` is true.
   - Write `take_while pred lst` that returns elements from the start while `pred` holds.
   - Write `drop_while pred lst` that skips elements from the start while `pred` holds.
*)

let () =
  let inc = fun x -> x + 1 in
  let result = apply_twice inc 5 in
  Printf.printf "apply_twice inc 5 = %d\n" result
