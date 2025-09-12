(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

(* In this test we demonstrate that we can use the OCaml rpc library in tests in
   addition to the cli. *)

let%expect_test "with_connection" =
  let& env = Eio_main.run in
  let&- t = Grpc_test_helpers.run ~env in
  let&- { server; client = keyval } =
    Grpc_test_helpers.with_server t ~config:Keyval_test.config
  in
  (* First lets's store a binding to the store. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {| bar |}];
  (* Now let's start access that binding using the RPC api. *)
  let&- connection = Grpc_test_helpers.Server.with_connection server in
  let data =
    Grpc_client.unary (module Keyval_rpc.Get) ~connection (Keyval.Key.v "foo")
    |> Or_error.join
    |> Or_error.ok_exn
  in
  print_s [%sexp (data : Keyval.Value.t)];
  [%expect {| bar |}];
  ()
;;
