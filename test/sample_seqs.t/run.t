Basic usage

  $ sample_seqs
  sample_seqs
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <percent> <seed> > out.fa
  $ sample_seqs seqs.fa
  sample_seqs
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <percent> <seed> > out.fa
  $ sample_seqs seqs.fa 50
  sample_seqs
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <percent> <seed> > out.fa
  $ sample_seqs seqs.fa -100 1234
  Percent should be between 0 and 100.  Got '-100.'.
  [1]
  $ sample_seqs seqs.fa 1000 1234
  Percent should be between 0 and 100.  Got '1000.'.
  [1]
  $ sample_seqs seqs.fa 50 1234
  >s2
  c
  >s3
  g
  $ sample_seqs seqs.fa 50 1234
  >s2
  c
  >s3
  g
  $ sample_seqs seqs.fa 50 12341234
  >s4
  t

Gzipped works too

  $ gunzip -c seqs.fa.gz | sample_seqs /dev/stdin 50 12341234
  >s4
  t
