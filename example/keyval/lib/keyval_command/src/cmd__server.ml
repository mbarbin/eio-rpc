let run_cmd =
  Command.make
    ~summary:"run the server"
    (let%map_open.Command listening_config = Grpc_discovery.Listening_config.arg
     and verbose = Arg.flag [ "verbose" ] ~doc:"be more verbose" in
     let%bind listening_config = listening_config in
     Eio_main.run
     @@ fun env ->
     let net = Eio.Stdenv.net env in
     Eio.Switch.run
     @@ fun sw ->
     let server = Keyval_server.create () in
     let grpc_server = Keyval_server.implement_rpcs server in
     let listening_socket =
       Eio.Net.listen
         net
         ~sw
         ~reuse_addr:true
         ~reuse_port:true
         ~backlog:5
         (Grpc_discovery.Listening_config.sockaddr listening_config)
     in
     Grpc_discovery.Listening_config.advertize listening_config ~env ~sw ~listening_socket;
     if verbose
     then
       Eio.traceln
         "Listening for connections on %a"
         Eio.Net.Sockaddr.pp
         (Eio.Net.listening_addr listening_socket) [@coverage off];
     let stop, stop_u = Eio.Promise.create () in
     Stdlib.Sys.set_signal
       Stdlib.Sys.sigterm
       (Signal_handle (fun (_ : int) -> Eio.Promise.resolve stop_u ()));
     Eio.Net.run_server
       listening_socket
       (Grpc_server.connection_handler grpc_server ~sw)
       ~stop
       ~on_error:(Eio.traceln "Error handling connection: %a" Fmt.exn)
       ~max_connections:1000;
     return ())
;;

let main = Command.group ~summary:"manage the server" [ "run", run_cmd ]
