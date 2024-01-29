let main =
  Command.basic_or_error
    ~summary:"verify the syntactic validity of a provided key"
    ~readme:(fun () ->
      {|
This command performs a static validation of the key and does not require a
connection to a running server.
|})
    (let%map_open.Command key = anon ("KEY" %: string) in
     fun () ->
       match Keyval.Key.of_string key with
       | Ok (_ : Keyval.Key.t) -> return ()
       | Error _ as error -> error)
;;
