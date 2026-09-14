(* 03 — Function composition and the pipe operator *)

(* Function composition: (f << g) x = f (g x) *)
let compose f g x = f (g x)

(* Forward composition: (f >> g) x = g (f x) *)
let forward_compose f g x = g (f x)

(* TODO:
   - Write `id` the identity function.
   - Write `constant v` that returns a function ignoring its argument and returning v.
   - Write `twice f` that composes f with itself.
   - Understand how the pipe operator |> works:
     x |> f |> g is equivalent to g (f x)
     This makes left-to-right data flow more readable.
   - Rewrite the example below using |> instead of nested calls.
*)

let () =
  let inc = fun x -> x + 1 in
  let double = fun x -> x * 2 in
  
  (* Nested function calls (harder to read) *)
  let result1 = double (inc 5) in
  Printf.printf "double (inc 5) = %d\n" result1;
  
  (* Using compose *)
  let result2 = compose double inc 5 in
  Printf.printf "compose double inc 5 = %d\n" result2;
  
  (* Using pipe operator |> (most readable) *)
  let result3 = 5 |> inc |> double in
  Printf.printf "5 |> inc |> double = %d\n" result3
