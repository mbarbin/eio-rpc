let main =
  Command.basic_or_error
    ~summary:"set a binding key=value"
    (let%map_open.Command key =
       flag
         "--key"
         (required (Arg_type.create Keyval.Key.v))
         ~doc:"KEY the name of the key"
     and value =
       flag
         "--value"
         (required (Arg_type.create Keyval.Value.of_string))
         ~doc:"VALUE the desired value"
     in
     fun () ->
       Eio_main.run
       @@ fun env ->
       Eio.Switch.run
       @@ fun sw ->
       Grpc_client.with_connection ~env ~sw ~addr:Connection.addr ~f:(fun connection ->
         Grpc_client.unary Keyval_rpc.Set_.rpc ~connection { key; value }))
;;
