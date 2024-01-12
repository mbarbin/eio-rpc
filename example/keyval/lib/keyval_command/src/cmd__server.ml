let run_cmd =
  Command.basic
    ~summary:"run the server"
    (let%map_open.Command () = return () in
     fun () ->
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
           Connection.addr
       in
       Eio.traceln "Listening for connections";
       Eio.Net.run_server
         listening_socket
         (Grpc_server.connection_handler grpc_server ~sw)
         ~on_error:(Eio.traceln "Error handling connection: %a" Fmt.exn)
         ~max_connections:1000)
;;

let main = Command.group ~summary:"manage the server" [ "run", run_cmd ]
