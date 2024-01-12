let main =
  Command.basic_or_error
    ~summary:"delete a binding"
    (let%map_open.Command key =
       flag
         "--key"
         (required (Arg_type.create Keyval.Key.v))
         ~doc:"KEY the name of the key"
     in
     fun () ->
       Eio_main.run
       @@ fun env ->
       Eio.Switch.run
       @@ fun sw ->
       Grpc_client.with_connection ~env ~sw ~addr:Connection.addr ~f:(fun connection ->
         Grpc_client.unary Keyval_rpc.Delete.rpc ~connection key |> Or_error.join))
;;
