(* Ops module: functions implemented in the exercises *)

let double x = x * 2

let add a b = a + b

let rec fact n =
  if n <= 1 then 1
  else n * fact (n - 1)

let fact_tail n =
  let rec aux n acc =
    if n <= 1 then acc
    else aux (n - 1) (n * acc)
  in
  aux n 1

let rec length lst =
  match lst with
  | [] -> 0
  | _ :: tail -> 1 + length tail

let rec sum_list lst =
  match lst with
  | [] -> 0
  | head :: tail -> head + sum_list tail

let describe_number n =
  match n with
  | 0 -> "zero"
  | 1 -> "one"
  | _ -> "many"

let max a b =
  if a > b then a else b

let sign n =
  if n < 0 then -1
  else if n > 0 then 1
  else 0
