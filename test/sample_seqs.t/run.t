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

Exact sampling

  $ sample_seqs_exact
  sample_seqs_exact
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <count> <seed> > out.fa
  
  If count is > num sequences then I will abort.
  $ sample_seqs_exact seqs.fa
  sample_seqs_exact
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <count> <seed> > out.fa
  
  If count is > num sequences then I will abort.
  $ sample_seqs_exact seqs.fa 2
  sample_seqs_exact
  Sample sequences from a FASTA file.
  
  usage: sample_seqs <infile.fa> <count> <seed> > out.fa
  
  If count is > num sequences then I will abort.
  $ sample_seqs_exact seqs.fa -100 1234
  Count should be > 0.  Got '-100'.
  [1]
  $ sample_seqs_exact seqs.fa 1000 1234
  Count should be <= num_seqs (4).  Got '1000'.
  [1]
  $ sample_seqs_exact seqs.fa 2 1234
  >s2
  c
  >s1
  a
  $ sample_seqs_exact seqs.fa 2 1234
  >s2
  c
  >s1
  a
  $ sample_seqs_exact seqs.fa 2 123412345
  >s2
  c
  >s4
  t
  $ gunzip -c seqs.fa.gz | sample_seqs_exact /dev/stdin 2 123412345
  >s2
  c
  >s4
  t
  $ sample_seqs_exact seqs.fa 1 1234
  >s2
  c
  $ sample_seqs_exact seqs.fa 2 1234
  >s2
  c
  >s1
  a
  $ sample_seqs_exact seqs.fa 3 1234
  >s2
  c
  >s1
  a
  >s3
  g
  $ sample_seqs_exact seqs.fa 4 1234
  >s2
  c
  >s1
  a
  >s3
  g
  >s4
  t
  $ sample_seqs_exact seqs.fa 1 12345
  >s3
  g
  $ sample_seqs_exact seqs.fa 2 12345
  >s3
  g
  >s4
  t
  $ sample_seqs_exact seqs.fa 3 12345
  >s3
  g
  >s4
  t
  >s2
  c
  $ sample_seqs_exact seqs.fa 4 12345
  >s3
  g
  >s4
  t
  >s2
  c
  >s1
  a
