(* Simple test: run the toolchain_check executable and check its output *)

let capture_output cmd =
  let tmp = "_toolchain_tmp.out" in
  let code = Sys.command (cmd ^ " > " ^ tmp) in
  let ch = open_in tmp in
  let output = Stdlib.Lexing.from_channel ch |> fun _ ->
    (* read whole file *)
    let buf = Buffer.create 64 in
    try
      while true do
        Buffer.add_char buf (input_char ch)
      done
    with End_of_file -> Buffer.contents buf
  in
  close_in ch;
  Sys.remove tmp;
  (code, output)

let () =
  let code, output = capture_output "dune exec toolchain_check" in
  if code <> 0 then (
    Printf.eprintf "FAIL: dune exec returned %d\n" code;
    exit 1
  );
  if output <> "toolchain ok\n" then (
    Printf.eprintf "FAIL: expected 'toolchain ok\\n' but got %S\n" output;
    exit 1
  );
  print_endline "PASS: toolchain_check printed 'toolchain ok'"
