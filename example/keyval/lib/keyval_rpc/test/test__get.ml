(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "rountrip" =
  Grpc_quickcheck.run_exn
    [%here]
    (module Keyval_rpc.Get)
    ~requests:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ];
  [%expect {||}];
  ()
;;
