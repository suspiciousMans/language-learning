(* 01-basics: pattern matching basics *)

(* TODO: use match to branch on values *)

let describe_number n =
  match n with
  | 0 -> "zero"
  | 1 -> "one"
  | _ -> "many"

(* pattern matching on a list *)
let rec sum_list lst =
  match lst with
  | [] -> 0
  | head :: tail -> head + sum_list tail

(* EXERCISE:
   - Write `message_of_int n` that returns "small" for n < 10, "medium" for 10..99, "large" otherwise.
   - Write `first_element lst` that returns the first element or 0 if the list is empty.
   - Write `is_empty lst` using pattern matching.
   - Use a when clause: write ` classify n` that returns "even" or "odd" using `when n mod 2 = 0`.
*)
