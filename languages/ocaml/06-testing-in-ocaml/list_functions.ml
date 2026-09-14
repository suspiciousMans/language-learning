(* 06 — List functions to test *)

(* TODO:
   - Write `remove_duplicates lst` that removes consecutive duplicates.
   - Write `flatten_one lst` that flattens one level of nesting.
   - Write `intersperse sep lst` that puts sep between elements.
   - Write `take n lst` that returns the first n elements.
   - Write `drop n lst` that skips the first n elements.
*)

let remove_duplicates lst =
  let rec loop prev = function
    | [] -> []
    | x :: rest when x = prev -> loop x rest
    | x :: rest -> x :: loop x rest
  in
  match lst with
  | [] -> []
  | x :: rest -> x :: loop x rest

let flatten_one lst =
  List.concat lst

let intersperse sep lst =
  match lst with
  | [] -> []
  | [x] -> [x]
  | x :: rest -> x :: List.concat (List.map (fun y -> [sep; y]) rest)

let take n lst =
  let rec loop n acc = function
    | _ when n = 0 -> List.rev acc
    | [] -> List.rev acc
    | x :: rest -> loop (n - 1) (x :: acc) rest
  in
  loop n [] lst

let drop n lst =
  let rec loop n = function
    | [] -> []
    | rest when n = 0 -> rest
    | _ :: rest -> loop (n - 1) rest
  in
  loop n lst
