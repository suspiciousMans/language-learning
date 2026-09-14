(* 03 — Building data processing pipelines *)

type record = { id: int; name: string; age: int; active: bool }

let records = [
  { id = 1; name = "Alice"; age = 30; active = true };
  { id = 2; name = "Bob"; age = 25; active = true };
  { id = 3; name = "Charlie"; age = 35; active = false };
  { id = 4; name = "Diana"; age = 28; active = true };
]

(* TODO:
   - Write `is_active r` that checks if a record is active.
   - Write `get_name r` that extracts the name.
   - Write `older_than age r` that checks if a record's age exceeds the threshold.
   - Build a pipeline: filter active, map to names, join with commas.
   - Build another: filter by age, count results.
   - Understand: pipelines compose small functions into complex data transformations.
*)

let is_active r = r.active
let get_name r = r.name
let older_than age r = r.age > age

let () =
  let active_users =
    records
    |> List.filter is_active
    |> List.map get_name
  in
  Printf.printf "Active users: %s\n" (String.concat ", " active_users);
  
  let over_30_count =
    records
    |> List.filter (older_than 30)
    |> List.length
  in
  Printf.printf "Users over 30: %d\n" over_30_count
