(* 07 — Logging with effects *)

effect Log : string -> unit

(* TODO:
   - Write a function that logs intermediate steps.
   - Write a handler that collects all logs.
   - Understand: the handler controls where logs go (file, console, etc.).
*)

let process_value x =
  perform (Log (Printf.sprintf "Processing %d" x));
  let y = x * 2 in
  perform (Log (Printf.sprintf "Doubled to %d" y));
  y

let run_with_logging () =
  let logs = ref [] in
  match process_value 5 with
  | effect (Log msg) k ->
    logs := msg :: !logs;
    continue k ()
  | result ->
    Printf.printf "Result: %d\n" result;
    Printf.printf "Logs:\n";
    List.rev !logs |> List.iter (Printf.printf "  - %s\n")

let () = run_with_logging ()
