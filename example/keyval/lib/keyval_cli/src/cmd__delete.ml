let main =
  Command.make
    ~summary:"Delete a binding."
    (let open Command.Std in
     let+ connection_config = Grpc_discovery.Connection_config.arg
     and+ key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"The name of the key to delete."
     in
     Eio_main.run
     @@ fun env ->
     let%bind connection_config = connection_config in
     let%bind sockaddr =
       Grpc_discovery.Connection_config.sockaddr connection_config ~env
     in
     Grpc_client.with_connection ~env ~sockaddr ~f:(fun connection ->
       Grpc_client.unary (module Keyval_rpc.Delete) ~connection key |> Or_error.join))
;;
