(* 07 — Async simulation with effects *)

(* Note: This is a simulation. True async requires OCaml 5.0+ *)

type 'a task = {
  name: string;
  work: unit -> 'a;
}

(* TODO:
   - Define an effect Async that yields a task.
   - Write a scheduler that collects tasks and runs them.
   - Build a simple executor.
   - Understand: effects can represent "yield to scheduler" instructions.
*)

let create_task name work =
  { name; work }

let run_task task =
  Printf.printf "Starting task: %s\n" task.name;
  let result = task.work () in
  Printf.printf "Finished task: %s\n" task.name;
  result

let () =
  let task1 = create_task "Task 1" (fun () -> 10 + 5) in
  let task2 = create_task "Task 2" (fun () -> 20 * 2) in
  let r1 = run_task task1 in
  let r2 = run_task task2 in
  Printf.printf "Results: %d, %d\n" r1 r2
