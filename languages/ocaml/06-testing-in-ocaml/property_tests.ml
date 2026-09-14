(* 06 — Property-based tests *)

(* TODO:
   - Write property tests using QCheck.
   - Property: square of x is always >= 0.
   - Property: take n + drop n = original list.
   - Property: remove_duplicates never grows the list.
   - Property: flatten_one distributes over concatenation.
   - Run: dune build @all
*)

let () =
  Printf.printf "Property-based tests with QCheck would go here.\n";
  Printf.printf "Install qcheck and qcheck-ounit to enable them.\n"
