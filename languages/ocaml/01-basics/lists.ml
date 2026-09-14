(* 01-basics: lists and cons *)

(* Lists are homogeneous linked lists. [1; 2; 3] is sugar for 1 :: 2 :: 3 :: [] *)

let my_list = [1; 2; 3; 4; 5]

(* cons a value onto a list *)
let longer = 0 :: my_list   (* [0; 1; 2; 3; 4; 5] *)

(* pattern matching on lists *)
let rec length lst =
  match lst with
  | [] -> 0
  | _ :: tail -> 1 + length tail

(* EXERCISE:
   - Write `head lst` that returns the first element or 0 if empty.
   - Write `tail lst` that returns the list without its first element, or [] if empty.
   - Write `append a b` that appends two lists (without using @).
   - Write `reverse lst` recursively.
   - Write `member x lst` that returns true if x is in lst.
   - Write `take n lst` that returns the first n elements.
*)
