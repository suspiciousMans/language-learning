(* 07 — Search with effects *)

(* TODO:
   - Define an effect Choose that offers multiple options.
   - Write a search function using perform (Choose options).
   - Write a handler that explores all choices (backtracking).
   - Implement constraint checking.
   - Understand: effects can replace success/failure monad patterns.
*)

(* Simulating search without effects (for now) *)

let rec search_solutions depth max_depth =
  if depth > max_depth then []
  else
    let current = depth in
    [current] @ search_solutions (depth + 1) max_depth

let find_valid_solution () =
  let solutions = search_solutions 0 3 in
  List.filter (fun x -> x > 0 && x mod 2 = 0) solutions

let () =
  let valid = find_valid_solution () in
  Printf.printf "Found solutions: [%s]\n"
    (String.concat "; " (List.map string_of_int valid))
