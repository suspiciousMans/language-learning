(* 05 — Error recovery *)

(* TODO:
   - Write `read_int_with_retry max_attempts` that prompts the user.
   - Write `recover_from_error fallback_fn res` that applies fallback on error.
   - Write `collect_results lst` that gathers all Ok values and stops on first Error.
   - Write `partition_results lst` that separates Ok and Error values.
*)

let divide x y =
  if y = 0 then Error "division by zero" else Ok (x / y)

let recover_from_error fallback_fn res =
  match res with
  | Ok x -> x
  | Error _e -> fallback_fn ()

let partition_results lst =
  let oks = ref [] in
  let errors = ref [] in
  List.iter (fun res ->
    match res with
    | Ok x -> oks := x :: !oks
    | Error e -> errors := e :: !errors
  ) lst;
  (List.rev !oks, List.rev !errors)

let () =
  let result = divide 10 0 in
  let value = recover_from_error (fun () -> 0) result in
  Printf.printf "Result with recovery: %d\n" value;
  
  let results = [Ok 10; Ok 20; Ok 30; Error "failure"; Ok 40] in
  let (oks, errors) = partition_results results in
  Printf.printf "Oks: %d, Errors: %d\n" (List.length oks) (List.length errors)
