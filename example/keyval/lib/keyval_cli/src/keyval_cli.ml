let main =
  Command.group
    ~summary:"Keyval is a key=value in-memory store served over gRPCs."
    [ "delete", Cmd__delete.main
    ; "get", Cmd__get.main
    ; "list-keys", Cmd__list_keys.main
    ; "set", Cmd__set.main
    ; "server", Cmd__server.main
    ; "validate-key", Cmd__validate_key.main
    ]
;;
