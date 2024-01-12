let main =
  Command.basic_or_error
    ~summary:"print the list of all known keys"
    (let%map_open.Command () = return () in
     fun () ->
       Eio_main.run
       @@ fun env ->
       Eio.Switch.run
       @@ fun sw ->
       Grpc_client.with_connection ~env ~sw ~addr:Connection.addr ~f:(fun connection ->
         let%bind keys = Grpc_client.unary Keyval_rpc.List_keys.rpc ~connection () in
         print_s [%sexp (keys : Set.M(Keyval.Key).t)];
         return ()))
;;
