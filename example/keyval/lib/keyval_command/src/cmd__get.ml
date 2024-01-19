let main =
  Command.basic_or_error
    ~summary:"get the value attached to a key"
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
         let%bind value =
           Grpc_client.unary Keyval_rpc.Get.rpc ~connection key |> Or_error.join
         in
         Eio_writer.print_sexp ~env [%sexp (value : Keyval.Value.t)];
         return ()))
;;
