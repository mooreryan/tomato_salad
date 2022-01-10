open! Core

module U = Tomato_salad.Utils

(** Custom fast version of Fasta.In_channel. Does not "clean" the
    sequences...prints them as they are in the file. This is the same code as
    the original except no clean_sequence function. *)
module Fasta_in_channel : sig
  include Bio_io.Record_in_channel.S with type record := Bio_io.Fasta.Record.t
end = struct
  module T = struct
    open Bio_io

    include Private.Peekable_in_channel
    type record = Fasta.Record.t

    let input_record_exn chan =
      let rec loop thing =
        match (peek_char chan, thing) with
        | None, None -> None
        | None, Some (header, seq) | Some '>', Some (header, seq) ->
            let r = Fasta.Record.of_header_exn header in
            let seq = String.concat ~sep:"" @@ List.rev seq in
            Some (Fasta.Record.with_seq seq r)
        | Some '>', None ->
            let line = input_line_exn ~fix_win_eol:true chan in
            loop (Some (line, []))
        | Some _, None ->
            failwith "Not at a header line, but not currently in a sequence"
        | Some _, Some (header, seq) ->
            let line = input_line_exn ~fix_win_eol:true chan in
            loop (Some (header, line :: seq))
      in
      loop None
  end

  include T
  include Bio_io.Record_in_channel.Make (T)
end

let program_info =
  [%string
    "sample_seqs\n\
     Sample sequences from a FASTA file.\n\n\
     usage: sample_seqs <infile.fa> <percent> <seed> > out.fa"]

let abort_if_bad_percent x =
  if Float.(x <= 0.0 || x >= 100.0) then
    U.abort [%string "Percent should be between 0 and 100.  Got '%{x#Float}'."]

let parse_argv () =
  match Sys.get_argv () with
  | [| _; fname; percent; seed |] ->
      U.abort_unless_file_exists fname;
      let percent = Float.of_string percent in
      abort_if_bad_percent percent;
      (fname, percent, Int.of_string seed)
  | _ -> U.abort ~exit_code:0 program_info

let () =
  let fname, percent, seed = parse_argv () in
  Random.init seed;
  Fasta_in_channel.with_file_iter_records_exn fname ~f:(fun r ->
      let x = Random.float_range 0. 100. in
      if Float.(x < percent) then
        print_endline @@ Bio_io.Fasta.Record.to_string r)
