(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let executable = "./keyval.exe"

let config =
  Grpc_test_helpers.Config.grpc_discovery
    ~run_server_command:{ executable; args = [ "server"; "run" ] }
    ~run_client_command:{ executable; args = [] }
;;
