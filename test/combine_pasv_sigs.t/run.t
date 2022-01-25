Combining sigs files.

  $ sort sigs_1.tsv sigs_2.tsv sigs_3.tsv | column -t
  s1  ABCA
  s1  ABZA
  s1  XYZA
  s2  DEFB
  s2  DEFB
  s2  Q-RB
  $ cat sigs_1.tsv sigs_2.tsv sigs_3.tsv | combine_pasv_sigs /dev/stdin
  s1	[A67_X33][B67_Y33][C33_Z67]A
  s2	[D67_Q33][-33_E67][F67_R33]B

Just one big one.

  $ combine_pasv_sigs sigs_combined.tsv
  s1	[A05_B95]B
