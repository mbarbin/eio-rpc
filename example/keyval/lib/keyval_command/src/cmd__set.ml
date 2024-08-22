let main =
  Command.make
    ~summary:"set a binding key=value"
    (let%map_open.Command connection_config = Grpc_discovery.Connection_config.arg
     and key =
       Arg.named
         [ "key" ]
         (Param.validated_string (module Keyval.Key))
         ~docv:"KEY"
         ~doc:"the name of the key"
     and value =
       Arg.named
         [ "value" ]
         (Param.stringable (module Keyval.Value))
         ~docv:"VALUE"
         ~doc:"the desired value"
     in
     let%bind connection_config = connection_config in
     Eio_main.run
     @@ fun env ->
     let%bind sockaddr =
       Grpc_discovery.Connection_config.sockaddr connection_config ~env
     in
     Grpc_client.with_connection ~env ~sockaddr ~f:(fun connection ->
       Grpc_client.unary (module Keyval_rpc.Set_) ~connection { key; value }))
;;
