# eio-rpc

:warning: This repository is now a public archive. I have stopped developping the project and will not be maintaining it forward.

This exploratory work has been an enjoyable educational experience for me. I am thankful to the authors and maintainers of the open-source upstream libraries I have been able to build upon here and learn from. Thank you!

---

[![CI Status](https://github.com/mbarbin/eio-rpc/workflows/ci/badge.svg)](https://github.com/mbarbin/eio-rpc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/eio-rpc/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/eio-rpc?branch=main)

eio-rpc is a collection of opinionated libraries designed to build RPC clients and servers with `eio`.

It currently relies on the following dependencies:

- Concurrency library: [eio](https://github.com/ocaml-multicore/eio)
- RPC transport and runtime: [ocaml-grpc](https://github.com/dialohq/ocaml-grpc)
- Serialization: [ocaml-protoc](https://github.com/mransan/ocaml-protoc)

## Relationship to ocaml-grpc

`ocaml-grpc` is a modular library that provides the building blocks for gRPC functionality. It supports various use cases and works with `lwt`, `async`, and `eio` clients/servers. It also supports various libraries implementing the protobuf serialization (`ocaml-protoc` and `ocaml_protoc_plugin`). As such, it offers a generic set of tools without recommending a specific choice. This opens the door for more specialized libraries, like `eio-rpc`, that focus on a particular combination of dependencies and offer a more streamlined interface.

## Code Documentation

The code documentation of the latest release is built with `odoc` and published to `GitHub` pages [here](https://mbarbin.github.io/eio-rpc).

## Build

This repo depends on unreleased packages that are published to a custom [opam-repository](https://github.com/mbarbin/opam-repository.git), which must be added to the opam switch used to build the project.

For example, if you use a local opam switch, this would look like this:

```sh
git clone https://github.com/mbarbin/eio-rpc.git
cd eio-rpc
opam switch create . 5.2.0 --no-install
eval $(opam env)
opam repo add mbarbin https://github.com/mbarbin/opam-repository.git
opam install . --deps-only --with-test --with-doc
```

Once this is setup, you can build with dune:

```sh
dune build @all @runtest
```
