(* 07 — Resource management with effects *)

(* TODO:
   - Define effects for resource allocation and cleanup.
   - Write a function that uses a resource.
   - Write a handler that ensures cleanup even on errors.
   - Understand: effects can express resource protocols.
*)

type resource = { id: int; name: string }

let allocate_resource name =
  Printf.printf "Allocating resource: %s\n" name;
  { id = 1; name }

let cleanup_resource r =
  Printf.printf "Cleaning up resource: %s\n" r.name

let use_resource r =
  Printf.printf "Using resource: %s (id=%d)\n" r.name r.id

let with_resource name f =
  let r = allocate_resource name in
  try
    let result = f r in
    cleanup_resource r;
    result
  with e ->
    cleanup_resource r;
    raise e

let () =
  with_resource "file.txt" (fun r ->
    use_resource r;
    "success"
  ) |> Printf.printf "Result: %s\n"
