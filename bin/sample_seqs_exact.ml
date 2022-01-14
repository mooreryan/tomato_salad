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
    "sample_seqs_exact\n\
     Sample sequences from a FASTA file.\n\n\
     usage: sample_seqs <infile.fa> <count> <seed> > out.fa\n\n\
     If count is > num sequences then I will abort."]

let abort_if_bad_count x =
  if Int.(x <= 0) then U.abort [%string "Count should be > 0.  Got '%{x#Int}'."]

let parse_argv () =
  match Sys.get_argv () with
  | [| _; fname; count; seed |] ->
      U.abort_unless_file_exists fname;
      let count = Int.of_string count in
      abort_if_bad_count count;
      (fname, count, Int.of_string seed)
  | _ -> U.abort ~exit_code:0 program_info

let () =
  let fname, count, seed = parse_argv () in
  Random.init seed;
  (* We want exact sampling without replacements. *)
  let records = Array.of_list @@ Fasta_in_channel.with_file_records_exn fname in
  let num_records = Array.length records in
  if count > num_records then
    U.abort
      [%string
        "Count should be <= num_seqs (%{num_records#Int}).  Got '%{count#Int}'."];
  let indices =
    List.range 0 num_records ~start:`inclusive ~stop:`exclusive |> Array.of_list
  in
  Array.permute indices;
  let indices = Array.sub ~pos:0 ~len:count indices in
  Array.iter indices ~f:(fun i ->
      print_endline @@ Bio_io.Fasta.Record.to_string @@ records.(i))
