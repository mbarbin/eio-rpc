let main =
  Command.make
    ~summary:"verify the syntactic validity of a provided key"
    ~readme:(fun () ->
      {|
This command performs a static validation of the key and does not require a
connection to a running server.
|})
    (let%map_open.Command key =
       Arg.pos ~pos:0 Param.string ~docv:"KEY" ~doc:"the key to validate"
     in
     match Keyval.Key.of_string key with
     | Ok (_ : Keyval.Key.t) -> return ()
     | Error (`Msg m) -> Or_error.error_string m)
;;
