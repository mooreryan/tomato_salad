(lang dune 2.9)

(generate_opam_files true)
(cram enable)

(name tomato_salad)

(package
 (name tomato_salad)
 (license "MIT")
 (maintainers "Ryan M. Moore")
 (authors "Ryan M. Moore")
 (homepage "https://github.com/mooreryan/tomato_salad")
 (source (github mooreryan/tomato_salad))
 (bug_reports "https://github.com/mooreryan/tomato_salad/issues")
 (synopsis "Random programs of a savory nature")
 (depends
  ; Runtime dependencies
  (bio_io (>= "0.4.0"))
  (core (>= "v0.12"))
  (ocaml (>= "4.08.0"))
  (ppx_jane (>= "v0.12"))
  ; Development dependencies
  (bisect_ppx :dev)))
