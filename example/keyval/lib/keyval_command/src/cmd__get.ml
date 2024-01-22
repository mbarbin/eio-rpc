let main =
  Command.basic_or_error
    ~summary:"get the value attached to a key"
    (let%map_open.Command connection_config = Grpc_discovery.Connection_config.param
     and key =
       flag
         "--key"
         (required (Arg_type.create Keyval.Key.v))
         ~doc:"KEY the name of the key"
     in
     fun () ->
       Eio_main.run
       @@ fun env ->
       let%bind sockaddr =
         Grpc_discovery.Connection_config.sockaddr connection_config ~env
       in
       Grpc_client.with_connection ~env ~sockaddr ~f:(fun connection ->
         let%bind value =
           Grpc_client.unary Keyval_rpc.Get.rpc ~connection key |> Or_error.join
         in
         Eio_writer.print_sexp ~env [%sexp (value : Keyval.Value.t)];
         return ()))
;;
