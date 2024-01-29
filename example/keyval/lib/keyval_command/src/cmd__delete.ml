let main =
  Command.basic_or_error
    ~summary:"delete a binding"
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
         Grpc_client.unary (module Keyval_rpc.Delete) ~connection key |> Or_error.join))
;;
