(* 08 — JSON handler using Yojson *)

(* Note: Yojson would need to be installed with opam *)

type person = {
  name: string;
  age: int;
  email: string;
}

(* TODO:
   - If Yojson is installed: use it to parse/serialize JSON.
   - Otherwise: define stub functions that return example data.
   - Write `person_to_string p` that returns a JSON representation.
   - Write `parse_person_json json_str` that creates a person from JSON.
*)

let person_to_json p =
  Printf.sprintf {|{"name":"%s","age":%d,"email":"%s"}|}
    p.name p.age p.email

let person_from_json name age email =
  { name; age; email }

let () =
  let person = person_from_json "Alice" 30 "alice@example.com" in
  Printf.printf "JSON: %s\n" (person_to_json person)
