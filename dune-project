(lang dune 3.17)

(name eio-rpc-tests)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/eio-rpc))

(documentation "https://mbarbin.github.io/eio-rpc/")

(implicit_transitive_deps false)

(package
 (name grpc-spec)
 (synopsis
  "An opinionated library to build gRPC specifications for Eio clients/servers")
 (depends
  (ocaml
   (>= 5.2))
  (grpc
   (>= 0.2.1-preview.3))
  (grpc-protoc
   (>= 0.2.1-preview.3))
  (ocaml-protoc
   (>= 3.1))
  (pbrt_services
   (>= 3.1))))

(package
 (name grpc-stream)
 (synopsis "A (temporary) library to manipulate gRPC streams")
 (depends
  (ocaml
   (>= 5.2))
  (grpc-eio
   (>= 0.2.1-preview.3))))

(package
 (name grpc-client)
 (synopsis "An opinionated library to build gRPC Eio clients")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (eio
   (>= 1.0))
  (grpc
   (>= 0.2.1-preview.3))
  (grpc-eio
   (>= 0.2.1-preview.3))
  (grpc-spec
   (= :version))
  (h2
   (>= 0.13.0))
  (h2-eio
   (>= 0.13.0))
  (sexplib0
   (>= v0.17))))

(package
 (name grpc-server)
 (synopsis "An opinionated library to build gRPC Eio servers")
 (depends
  (ocaml
   (>= 5.2))
  (eio
   (>= 1.0))
  (grpc
   (>= 0.2.1-preview.3))
  (grpc-eio
   (>= 0.2.1-preview.3))
  (grpc-spec
   (= :version))
  (h2
   (>= 0.13.0))
  (h2-eio
   (>= 0.13.0))))

(package
 (name grpc-discovery)
 (synopsis "A library to help discover gRPC servers running on localhost")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (eio
   (>= 1.0))
  (fpath
   (>= 0.7.3))
  (fpath-sexp0
   (>= 0.2.2))
  (grpc-client
   (= :version))
  (ppx_compare
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_yojson_conv
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (>= v0.17))
  (yojson
   (>= 2.1.1))))

(package
 (name grpc-test-helpers)
 (synopsis "A library to help writing tests for gRPC Eio applications")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (eio
   (>= 1.0))
  (fpath
   (>= 0.7.3))
  (grpc-client
   (= :version))
  (grpc-discovery
   (= :version))))

(package
 (name grpc-quickcheck)
 (synopsis "A library to help writing expect-tests for gRPC interfaces")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (base_quickcheck
   (>= v0.17))
  (expect_test_helpers_core
   (>= v0.17))
  (grpc-spec
   (= :version))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))))

(package
 (name eio-rpc-tests)
 (synopsis "Tests & Examples for eio-rpc")
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (base_quickcheck
   (>= v0.17))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-stdlib-runner
   (>= 0.0.9))
  (cmdlang-to-cmdliner
   (>= 0.0.9))
  (cmdliner
   (>= 1.3.0))
  (eio
   (>= 1.0))
  (eio_main
   (>= 1.0))
  (expect_test_helpers_core
   (>= v0.17))
  (fmt
   (>= 0.9.0))
  (fpath
   (>= 0.7.3))
  (grpc-client
   (= :version))
  (grpc-discovery
   (= :version))
  (grpc-quickcheck
   (= :version))
  (grpc-server
   (= :version))
  (grpc-spec
   (= :version))
  (grpc-stream
   (= :version))
  (grpc-test-helpers
   (= :version))
  (letfun
   (>= 0.0.1))
  (parsexp
   (>= v0.17))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (ppx_compare
   (>= v0.17))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (stdio
   (>= v0.17))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
