(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let () =
  match
    Cmdliner.Cmd.eval_value'
      (Cmdlang_to_cmdliner.Translate.command
         Keyval_cli.main
         ~name:"keyval"
         ~version:"%%VERSION%%")
  with
  | `Ok (Ok ()) -> ()
  | `Exit code -> Stdlib.exit code
  | `Ok (Error err) ->
    prerr_endline (Base.Error.to_string_hum err);
    Stdlib.exit 1
;;
