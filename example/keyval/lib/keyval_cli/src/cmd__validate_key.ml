(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let main =
  Command.make
    ~summary:"Verify the syntactic validity of a provided key."
    ~readme:(fun () ->
      "This command performs a static validation of the key and does not require a \
       connection to a running server.")
    (let open Command.Std in
     let+ key = Arg.pos ~pos:0 Param.string ~docv:"KEY" ~doc:"The key to validate." in
     match Keyval.Key.of_string key with
     | Ok (_ : Keyval.Key.t) -> return ()
     | Error (`Msg m) -> Or_error.error_string m)
;;
