(lang dune 3.13)

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
   (>= 3.0.2-preview.2))
  (pbrt_services
   (>= 3.0.2-preview.2))
  (ppx_js_style
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
   (>= 0.13))
  (grpc
   (>= 0.2.0-preview.2))
  (grpc-eio
   (>= 0.2.0-preview.2))
  (grpc-spec
   (= :version))
  (h2-eio
   (>= 0.11.0))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
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
   (>= 0.13))
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
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
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
  (command-unix-for-opam
   (>= 0.0.1))
  (core
   (and
    (>= v0.16)
    (< v0.17)))
  (core_unix
   (and
    (>= v0.16)
    (< v0.17)))
  (eio
   (>= 0.13))
  (eio-writer
   (>= 0.0.3))
  (eio_main
   (>= 0.13))
  (expect_test_helpers_core
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
  (pbrt
   (>= 3.0.2-preview.2))
  (pbrt_services
   (>= 3.0.2-preview.2))
  (ppx_jane
   (and
    (>= v0.16)
    (< v0.17)))
  (ppx_js_style
   (and
    (>= v0.16)
    (< v0.17)))))
