(lang dune 3.15)

(name eio-rpc)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin")

(source
 (github mbarbin/eio-rpc))

(documentation "https://mbarbin.github.io/eio-rpc/")

(package
 (name grpc-spec)
 (synopsis
  "An opinionated library to build gRPC specifications for Eio clients/servers")
 (description
  "An opinionated library to build gRPC specifications Eio clients/servers")
 (depends
  (ocaml
   (>= 5.1))
  (grpc
   (>= 0.2.0-preview.2))
  (grpc-protoc
   (>= 0.2.0-preview.2))
  (ocaml-protoc
   (>= 3.0.2-preview.4))
  (pbrt_services
   (>= 3.0.2-preview.4))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))))

(package
 (name grpc-stream)
 (synopsis "A (temporary) library to manipulate gRPC streams")
 (depends
  (ocaml
   (>= 5.1))
  (grpc-eio
   (>= 0.2.0-preview.2))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))))

(package
 (name grpc-client)
 (synopsis "An opinionated library to build gRPC Eio clients")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 1.0))
  (grpc
   (>= 0.2.0-preview.2))
  (grpc-eio
   (>= 0.2.0-preview.2))
  (grpc-spec
   (= :version))
  (h2-eio
   (>= 0.11.0))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))))

(package
 (name grpc-server)
 (synopsis "An opinionated library to build gRPC Eio servers")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 1.0))
  (grpc
   (>= 0.2.0-preview.2))
  (grpc-eio
   (>= 0.2.0-preview.2))
  (grpc-spec
   (= :version))
  (h2
   (>= 0.11.0))
  (h2-eio
   (>= 0.11.0))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))))

(package
 (name grpc-discovery)
 (synopsis "A library to help discover gRPC servers running on localhost")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 1.0))
  (fpath
   (>= 0.7.3))
  (fpath-base
   (>= 0.0.9))
  (grpc-client
   (= :version))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_yojson_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (yojson
   (>= 2.1.1))))

(package
 (name grpc-test)
 (synopsis "A library to help writting tests for gRPC Eio applications")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 1.0))
  (fpath
   (>= 0.7.3))
  (grpc-client
   (= :version))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))))

(package
 (name grpc-quickcheck)
 (synopsis "A library to help writting expect-tests for gRPC interfaces")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (base_quickcheck
   (and
    (>= v0.16)
    (< v0.17)))
  (expect-test-helpers
   (and
    (>= v0.16)
    (< v0.17)))
  (grpc-spec
   (= :version))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    :with-test
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))))

(package
 (name eio-rpc)
 (synopsis "Tests & Examples for eio-rpc")
 (depends
  (ocaml
   (>= 5.1))
  (base
   (and
    (>= v0.16)
    (< v0.17)))
  (base_quickcheck
   (and
    (>= v0.16)
    (< v0.17)))
  (bisect_ppx
   (and
    :dev
    (>= 2.8.3)))
  (command-unix-for-opam
   (>= 0.0.2))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (core_unix
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 1.0))
  (eio-writer
   (>= 0.0.3))
  (eio_main
   (>= 1.0))
  (expect-test-helpers
   (and
    (>= v0.16)
    (< v0.17)))
  (grpc-client
   (= :version))
  (grpc-server
   (= :version))
  (grpc-spec
   (= :version))
  (grpc-stream
   (= :version))
  (ocamlformat
   (and
    :with-test
    (= 0.26.1)))
  (parsexp
   (and
    (>= v0.16)
    (< v0.17)))
  (pbrt
   (>= 3.0.2-preview.4))
  (pbrt_quickcheck
   (>= 3.0.2-preview.4))
  (pbrt_services
   (>= 3.0.2-preview.4))
  (ppx-let-fun
   (>= 0.0.2))
  (ppx_compare
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_deriving
   (>= 5.2.1))
  (ppx_deriving_qcheck
   (>= 0.4.1))
  (ppx_enumerate
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_expect
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_hash
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_here
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    :dev
    (>= v0.16)
    (< v0.17)))
  (ppx_let
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_conv
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_sexp_value
   (and
    (>= v0.16)
    (< v0.17)))
  (qcheck
   (>= 0.21.3))))
