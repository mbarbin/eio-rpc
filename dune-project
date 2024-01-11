(lang dune 3.12)

(name eio-rpc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/eio-rpc))

(documentation "https://mbarbin.github.io/eio-rpc/")

(package
 (name eio-rpc)
 (synopsis "Exploring RPC libraries running with an Eio backend")
 (description "Exploring RPC libraries running with an Eio backend")
 (depends
  (ocaml
   (>= 5.1))
  (dune
   (>= 3.12))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (command-unix-for-opam
   (>= 0.0.1))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (expect_test_helpers_core
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))
  (stdio
   (and
    (>= v0.16)
    (< v0.17)))))
