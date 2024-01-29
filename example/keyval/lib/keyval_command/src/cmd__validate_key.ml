let main =
  Command.basic_or_error
    ~summary:"check that a given string is a syntactice valid key"
    ~readme:(fun () ->
      {|
This command won't connect to a running server, it only validates the key statically.
|})
    (let%map_open.Command key = anon ("KEY" %: string) in
     fun () ->
       match Keyval.Key.of_string key with
       | Ok (_ : Keyval.Key.t) -> return ()
       | Error _ as error -> error)
;;
