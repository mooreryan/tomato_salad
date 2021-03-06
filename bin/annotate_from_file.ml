open! Core

module U = Tomato_salad.Utils

let program_info =
  [%string
    "usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa\n\n\
    \  - I will create a new ID for each sequence using the data in \
     <annot_file>.\n\
    \  - <annot_file> should be two TSV columns 'old_id -> new_id'.\n\
    \  - The old ID and description will become the new description.\n\
    \  - <print|skip> should be print or skip.  It's how to handle IDs in \
     fasta that are not in annotation file."]

type handle_missing = Print | Skip

let parse_missing = function
  | "print" -> Print
  | "skip" -> Skip
  | _ -> U.abort "ERROR: <print|skip> must either be print or skip"

let parse_argv () =
  match Sys.get_argv () with
  | [| _; seqs_file; annot_file; handle_missing |] ->
      U.abort_unless_file_exists seqs_file;
      U.abort_unless_file_exists annot_file;

      (seqs_file, annot_file, parse_missing handle_missing)
  | _ -> U.abort ~exit_code:0 program_info

let read_annot_file fname =
  In_channel.with_file fname ~f:(fun ic ->
      In_channel.fold_lines ic
        ~init:(Map.empty (module String))
        ~f:(fun m l ->
          match String.split ~on:'\t' l with
          | [ old_id; new_id ] -> Map.add_exn m ~key:old_id ~data:new_id
          | _ -> U.abort [%string "ERROR: Bad line in annot_file: '%{l}'"]))

let print_with_annotation fname annot_file handle_missing =
  let id_map = read_annot_file annot_file in
  let open Bio_io.Fasta in
  In_channel.with_file_iter_records_exn fname ~f:(fun r ->
      let old_id = Record.id r in
      match Map.find id_map old_id with
      | None -> (
          match handle_missing with
          | Skip -> ()
          | Print -> print_endline @@ Record.to_string r)
      | Some new_id ->
          let old_desc = Record.desc r in
          let new_desc =
            match old_desc with
            | Some desc -> [%string "%{old_id} %{desc}"]
            | None -> old_id
          in
          let r =
            r |> Record.with_id new_id |> Record.with_desc (Some new_desc)
          in
          print_endline @@ Record.to_string r)

let () =
  let fname, annot_file, handle_missing = parse_argv () in
  print_with_annotation fname annot_file handle_missing
