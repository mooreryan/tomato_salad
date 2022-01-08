Bad input

  $ add_annotation
  add_annotation
  I will create a new ID for each sequence of the form <annotation>_<idx>.
  The old ID and description will become the new description.
  
  usage: add_annotation <infile.fa> <annotation> > out.fa
  $ add_annotation seqs.fa
  add_annotation
  I will create a new ID for each sequence of the form <annotation>_<idx>.
  The old ID and description will become the new description.
  
  usage: add_annotation <infile.fa> <annotation> > out.fa
  $ add_annotation apple pie
  error: file 'apple' does not exist
  [1]

Normal usage

  $ add_annotation seqs.fa apple-pie
  >apple-pie___1 s1 apple pie
  ACTGactg
  >apple-pie___2 s2 is really good
  actgACTG

Spaces in the ID raise an error.

  $ add_annotation seqs.fa apple pie
  add_annotation
  I will create a new ID for each sequence of the form <annotation>_<idx>.
  The old ID and description will become the new description.
  
  usage: add_annotation <infile.fa> <annotation> > out.fa
  $ add_annotation seqs.fa 'apple pie'
  Annotation must not contain a space.  Got 'apple pie'.
  [1]

