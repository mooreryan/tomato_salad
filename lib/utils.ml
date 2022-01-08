open! Core

let abort ?(exit_code = 1) msg =
  let () = eprintf "%s\n" msg in
  Caml.exit exit_code

let file_exists fname =
  match Sys.is_file ~follow_symlinks:true fname with
  | `Yes -> true
  | `No | `Unknown -> false

let abort_unless_file_exists fname =
  if not (file_exists fname) then
    abort [%string "error: file '%{fname}' does not exist"]
