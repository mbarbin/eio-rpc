let main =
  Command.make
    ~summary:"print the list of all known keys"
    (let open Command.Std in
     let+ connection_config = Grpc_discovery.Connection_config.arg in
     Eio_main.run
     @@ fun env ->
     let%bind connection_config = connection_config in
     let%bind sockaddr =
       Grpc_discovery.Connection_config.sockaddr connection_config ~env
     in
     Grpc_client.with_connection ~env ~sockaddr ~f:(fun connection ->
       let%bind keys = Grpc_client.unary (module Keyval_rpc.List_keys) ~connection () in
       print_s [%sexp (keys : Set.M(Keyval.Key).t)];
       return ()))
;;
