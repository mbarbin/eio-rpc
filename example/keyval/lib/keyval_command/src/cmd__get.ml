let main =
  Command.make
    ~summary:"get the value attached to a key"
    (let%map_open.Command connection_config = Grpc_discovery.Connection_config.arg
     and key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"the name of the key"
     in
     Eio_main.run
     @@ fun env ->
     let%bind connection_config = connection_config in
     let%bind sockaddr =
       Grpc_discovery.Connection_config.sockaddr connection_config ~env
     in
     Grpc_client.with_connection ~env ~sockaddr ~f:(fun connection ->
       let%bind value =
         Grpc_client.unary (module Keyval_rpc.Get) ~connection key |> Or_error.join
       in
       Eio_writer.print_sexp ~env [%sexp (value : Keyval.Value.t)];
       return ()))
;;