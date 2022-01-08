open! Core

module U = Tomato_salad.Utils

let program_info =
  [%string
    "add_annotation\n\
     I will create a new ID for each sequence of the form <annotation>_<idx>.\n\
     The old ID and description will become the new description.\n\n\
     usage: add_annotation <infile.fa> <annotation> > out.fa"]

let abort_if_bad_annotation s =
  if String.contains s ' ' then
    U.abort [%string "Annotation must not contain a space.  Got '%{s}'."]

let parse_argv () =
  match Sys.get_argv () with
  | [| _; fname; annotation |] ->
      U.abort_unless_file_exists fname;
      abort_if_bad_annotation annotation;
      (fname, annotation)
  | _ -> U.abort ~exit_code:0 program_info

let print_with_annotation fname annotation =
  let open Bio_io.Fasta in
  In_channel.with_file_iteri_records_exn fname ~f:(fun i r ->
      let old_id = Record.id r in
      let old_desc = Record.desc r in
      let i = i + 1 in
      let new_id = [%string "%{annotation}___%{i#Int}"] in
      let new_desc =
        match old_desc with
        | Some desc -> [%string "%{old_id} %{desc}"]
        | None -> old_id
      in
      let r = r |> Record.with_id new_id |> Record.with_desc (Some new_desc) in
      Stdio.print_endline @@ Record.to_string r)

let () =
  let fname, annotation = parse_argv () in
  print_with_annotation fname annotation
