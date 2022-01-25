Errors

  $ annotate_from_file
  usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - <print|skip> should be print or skip.  It's how to handle IDs in fasta that are not in annotation file.
  $ annotate_from_file a
  usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - <print|skip> should be print or skip.  It's how to handle IDs in fasta that are not in annotation file.
  $ annotate_from_file a b
  usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - <print|skip> should be print or skip.  It's how to handle IDs in fasta that are not in annotation file.
  $ annotate_from_file a b apple
  error: file 'a' does not exist
  [1]
  $ annotate_from_file a b print
  error: file 'a' does not exist
  [1]
  $ annotate_from_file a b skip
  error: file 'a' does not exist
  [1]
  $ annotate_from_file seqs.fa b
  usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - <print|skip> should be print or skip.  It's how to handle IDs in fasta that are not in annotation file.
  $ annotate_from_file a annot_file.txt
  usage: annotate_from_file <infile.fa> <annotation> <print|skip> > out.fa
  
    - I will create a new ID for each sequence using the data in <annot_file>.
    - <annot_file> should be two TSV columns 'old_id -> new_id'.
    - The old ID and description will become the new description.
    - <print|skip> should be print or skip.  It's how to handle IDs in fasta that are not in annotation file.
  $ annotate_from_file seqs.fa annot_file.txt pie
  ERROR: <print|skip> must either be print or skip
  [1]

Good run

  $ annotate_from_file seqs.fa annot_file.txt print
  >s1_new_id s1 apple pie
  ACTGactg
  >s2 is really good
  actgACTG
  >s3_new_id s3 lalala
  aaaa
  $ annotate_from_file seqs.fa annot_file.txt skip
  >s1_new_id s1 apple pie
  ACTGactg
  >s3_new_id s3 lalala
  aaaa
