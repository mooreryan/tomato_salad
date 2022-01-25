Errors

  $ annotate_from_file
  usage: annotate_from_file <infile.fa> <annotation> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - You don't need all IDs in the FASTA in the annot_file.  Missing IDs will be ignored.
  $ annotate_from_file a
  usage: annotate_from_file <infile.fa> <annotation> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - You don't need all IDs in the FASTA in the annot_file.  Missing IDs will be ignored.
  $ annotate_from_file a b
  error: file 'a' does not exist
  [1]
  $ annotate_from_file seqs.fa b
  error: file 'b' does not exist
  [1]
  $ annotate_from_file a annot_file.txt
  error: file 'a' does not exist
  [1]

Good run

  $ annotate_from_file seqs.fa annot_file.txt
  >s1_new_id s1 apple pie
  ACTGactg
  >s2 is really good
  actgACTG
  >s3_new_id s3 lalala
  aaaa
