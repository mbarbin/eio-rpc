# eio-rpc

[![CI Status](https://github.com/mbarbin/eio-rpc/workflows/ci/badge.svg)](https://github.com/mbarbin/eio-rpc/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/eio-rpc/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/eio-rpc?branch=main)

eio-rpc is a collection of opinionated libraries designed to build RPC clients
and servers with `eio`.

It currently relies on the following dependencies:

- Concurrency library: [eio](https://github.com/ocaml-multicore/eio)
- RPC transport and runtime: [ocaml-grpc](https://github.com/dialohq/ocaml-grpc)
- Serialization: [ocaml-protoc](https://github.com/mransan/ocaml-protoc)

## Relationship to ocaml-grpc

`ocaml-grpc` is a modular library that provides the building blocks for gRPC
functionality. It supports various use cases and works with `lwt`, `async`, and
`eio` clients/servers. It also supports various libraries implementing the
protobuf serialization (`ocaml-protoc` and `ocaml_protoc_plugin`). As such, it
offers a generic set of tools without recommending a specific choice. This opens
the door for more specialized libraries, like `eio-rpc`, that focus on a
particular combination of dependencies and offer a more streamlined interface.

## Goals

The primary goal of eio-rpc is to provide a reference implementation and
examples that demonstrate a specific (and opinionated) approach to structuring
an application that involves a networked RPC interface and a CLI client.

While the stability and usability of the overall interface are important, and I
plan to use the libraries defined here in personal projects, I do not guarantee
the choice of the underlying building blocks. These may change in future
updates, potentially in breaking ways. As a result, I currently do not recommend
this library for inclusion in a public opam package. However, by making this
repo public, I can reference this code in discussions, issues, and PRs with
other developers on GitHub.

## Code Documentation

The code documentation of the latest release is built with `odoc` and published
to `GitHub` pages [here](https://mbarbin.github.io/eio-rpc).

## Build

This repo depends on unreleased packages that are published to a custom
[opam-repository](https://github.com/mbarbin/opam-repository.git), which must be
added to the opam switch used to build the project.

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
