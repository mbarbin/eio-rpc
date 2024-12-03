(lang dune 3.16)

(name eio-rpc-tests)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/eio-rpc))

(documentation "https://mbarbin.github.io/eio-rpc/")

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
   (and
    (>= v0.17)
    (< v0.18)))
  (eio
   (>= 1.0))
  (grpc
   (>= 0.2.1-preview.3))
  (grpc-eio
   (>= 0.2.1-preview.3))
  (grpc-spec
   (= :version))
  (h2-eio
   (and
    (>= 0.13.0)))
  (sexplib0
   (and
    (>= v0.17)
    (< v0.18)))))

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
   (and
    (>= 0.13.0)))
  (h2-eio
   (and
    (>= 0.13.0)))))

(package
 (name grpc-discovery)
 (synopsis "A library to help discover gRPC servers running on localhost")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_yojson_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))
  (sexplib0
   (and
    (>= v0.17)
    (< v0.18)))
  (yojson
   (>= 2.1.1))))

(package
 (name grpc-test-helpers)
 (synopsis "A library to help writing tests for gRPC Eio applications")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (eio
   (>= 1.0))
  (fpath
   (>= 0.7.3))
  (grpc-client
   (= :version))))

(package
 (name grpc-quickcheck)
 (synopsis "A library to help writing expect-tests for gRPC interfaces")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (and
    (>= v0.17)
    (< v0.18)))
  (base_quickcheck
   (and
    (>= v0.17)
    (< v0.18)))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (grpc-spec
   (= :version))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
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
   (and
    (>= v0.17)
    (< v0.18)))
  (base_quickcheck
   (and
    (>= v0.17)
    (< v0.18)))
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
  (eio-writer
   (>= 0.0.3))
  (eio_main
   (>= 1.0))
  (expect_test_helpers_core
   (and
    (>= v0.17)
    (< v0.18)))
  (grpc-client
   (= :version))
  (grpc-server
   (= :version))
  (grpc-spec
   (= :version))
  (grpc-stream
   (= :version))
  (letfun
   (>= 0.0.1))
  (parsexp
   (and
    (>= v0.17)
    (< v0.18)))
  (pbrt
   (>= 3.1))
  (pbrt_services
   (>= 3.1))
  (pbrt_yojson
   (>= 3.1))
  (ppx_compare
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_enumerate
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_expect
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_hash
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_here
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)
    (< v0.18)))
  (ppx_let
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_conv
   (and
    (>= v0.17)
    (< v0.18)))
  (ppx_sexp_value
   (and
    (>= v0.17)
    (< v0.18)))
  (ppxlib
   (>= 0.33))))
