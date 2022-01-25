open! Core

module U = Tomato_salad.Utils

module Cli = struct
  open Cmdliner

  type opts = { sigs : string; regex_out : bool }
  let make_opts sigs regex_out = { sigs; regex_out }

  let sigs_term =
    let doc = "Path to signatures file (ID [tab] SIG)" in
    Arg.(
      required
      & pos 0 (some non_dir_file) None
      & info [] ~docv:"SIGNATURES" ~doc)

  let regex_out_term =
    let doc = "Print output signature like a regex" in
    Arg.(value & flag & info [ "regex-out" ] ~doc)

  let info =
    let doc = "Combine PASV signatures into an easy to read format" in
    let man =
      [
        `S Manpage.s_description;
        `P
          "You need to 'cut' the file so that the input is sequence ID [tab] \
           signature.  Generally, you will want to combine multiple PASV \
           signature files as well, so that you can view the variation in the \
           signatures.";
        `S Manpage.s_examples;
        `Pre
          "  \\$ cut -f1,9 */class_iii_sigs.tsv | combine_pasv_sigs /dev/stdin \
           > sigs.tsv";
      ]
    in
    Term.info "combine_pasv_sigs" ~doc ~man

  let term = Term.(const make_opts $ sigs_term $ regex_out_term)

  let program = (term, info)

  let parse () =
    match Term.eval program with
    | `Ok opts ->
        U.abort_unless_file_exists opts.sigs;
        `Run opts
    | `Help | `Version -> `Exit 0
    | `Error _ -> `Exit 1
end

let read_sigs fname =
  let handle_signature sigs ~id ~signature =
    let signature = String.to_array signature in
    Map.update sigs id ~f:(function
      | None -> [ signature ]
      | Some sigs -> signature :: sigs)
  in
  U.with_file_fold_lines fname
    ~init:(Map.empty (module String))
    ~f:(fun sigs l ->
      match String.split ~on:'\t' l with
      | [ id; signature ] -> handle_signature sigs ~id ~signature
      | _ -> U.abort [%string "ERROR: bad line in sigs file: '%{l}'"])

(* We can't use any weird characters that won't come through in the alignment or
   tree software. *)
let tally_to_string tally ~total ~regex_out =
  match Map.length tally with
  | 0 -> failwith "empty map"
  | 1 -> (
      match Map.keys tally with
      | [ item ] -> Char.to_string item
      | _ -> assert false)
  | _ ->
      let sep = if regex_out then "" else "_" in
      let s =
        String.concat ~sep
        @@ List.map ~f:(fun (item, count) ->
               if regex_out then Char.to_string item
               else
                 let frac = Float.(of_int count / of_int total * 100.) in
                 sprintf "%c%02.0f" item frac)
        @@ Map.to_alist ~key_order:`Increasing tally
      in
      "[" ^ s ^ "]"

let f sig_map ~regex_out =
  Map.iteri sig_map ~f:(fun ~key:id ~data:sigs ->
      (* sigs will normally be a small list of short strings *)
      (* each "sig" is a char array (eg like a c-string, but not lol), and sigs
         is an array of those...one entry for each sig present *)
      let sigs = Array.of_list sigs in
      let nsigs = Array.length sigs in
      (* This is the number of alignment colunms. *)
      let _ncols = Array.length sigs.(0) in

      (* This will raise if the arrays are not all the same length. *)

      (* char array array... *)
      let sig_cols = Array.transpose_exn sigs in
      (* Now, each entry of sig_cols is a single column in an signature. *)
      (* For each sig col, we need to tally the counts of residues per column. *)
      let column_tallies =
        Array.map sig_cols ~f:(U.tally ~comp:(module Char) ~fold:Array.fold)
      in
      let column_tally_strings =
        Array.map column_tallies ~f:(tally_to_string ~total:nsigs ~regex_out)
      in
      print_string (id ^ "\t");
      print_endline @@ String.concat ~sep:"" @@ Array.to_list
      @@ column_tally_strings)

let () =
  let opts : Cli.opts =
    match Cli.parse () with `Run file -> file | `Exit code -> exit code
  in
  f ~regex_out:opts.regex_out @@ read_sigs opts.sigs
