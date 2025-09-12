(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Grpc_discovery
open! Cmdlang

module type Argable = sig
  type t [@@deriving equal, sexp_of]

  val arg : t Or_error.t Command.Arg.t
  val to_args : t -> string list
end

let test_roundtrip (type a) ~(inputs : a list) (module A : Argable with type t = a) =
  List.iter inputs ~f:(fun t ->
    let args = A.to_args t in
    let t' =
      match
        let cmd = Command.make A.arg ~summary:"Return the args." in
        Cmdlang_stdlib_runner.eval cmd ~argv:(Array.of_list ("./main.exe" :: args))
      with
      | Ok (Ok a) -> a
      | Error (`Help _ | `Bad _) | Ok (Error _) -> assert false
    in
    require_equal [%here] (module A) t t')
;;

let%expect_test "connection_config" =
  let inputs =
    Connection_config.
      [ Tcp { host = `Localhost; port = 1234 }
      ; Unix { path = Fpath.v "/tmp/foo" }
      ; Discovery_file { path = Fpath.v "/tmp/foo" }
      ]
  in
  test_roundtrip ~inputs (module Connection_config);
  [%expect {||}];
  ()
;;

let%expect_test "listening_config" =
  let inputs =
    Listening_config.
      [ { specification = Tcp { port = `Chosen_by_OS }; discovery_file = None }
      ; { specification = Tcp { port = `Supplied 1234 }; discovery_file = None }
      ; { specification = Unix { path = Fpath.v "/tmp/foo" }; discovery_file = None }
      ; { specification = Tcp { port = `Chosen_by_OS }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ; { specification = Tcp { port = `Supplied 1234 }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ; { specification = Unix { path = Fpath.v "/tmp/foo" }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ]
  in
  test_roundtrip ~inputs (module Listening_config);
  [%expect {||}];
  ()
;;
