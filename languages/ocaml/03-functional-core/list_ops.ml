(* 03 — List operations: map, filter, fold *)

(* TODO:
   - Write `sum lst` using fold_left to add all elements.
   - Write `product lst` using fold_left to multiply all elements.
   - Write `reverse lst` using fold_left.
   - Write `all pred lst` that returns true if pred holds for all elements.
   - Write `any pred lst` that returns true if pred holds for any element.
   - Write `find pred lst` that returns the first element matching pred (or None).
   - Write `count pred lst` that counts elements matching pred.
   - Write `max_element lst` that returns the largest element (or raises Not_found).
*)

let sum_with_fold lst =
  List.fold_left (fun acc x -> acc + x) 0 lst

let product_with_fold lst =
  List.fold_left (fun acc x -> acc * x) 1 lst

let doubled_with_map lst =
  List.map (fun x -> x * 2) lst

let evens_with_filter lst =
  List.filter (fun x -> x mod 2 = 0) lst

let () =
  let nums = [1; 2; 3; 4; 5] in
  Printf.printf "sum [1..5] = %d\n" (sum_with_fold nums);
  Printf.printf "product [1..5] = %d\n" (product_with_fold nums);
  Printf.printf "doubled = [%s]\n"
    (String.concat ", " (List.map string_of_int (doubled_with_map nums)));
  Printf.printf "evens = [%s]\n"
    (String.concat ", " (List.map string_of_int (evens_with_filter nums)))
