(* In this test we connect to the server using tcp rather than via a unix socket. *)

let%expect_test "using tcp" =
  let%fun env = Eio_main.run in
  let%fun.F t = Grpc_test.run ~env in
  let%fun.F { server; client = keyval } =
    Grpc_test.with_server t ~config:Keyval_test.config ~sockaddr_kind:Tcp_localhost
  in
  (* First lets's store a binding to the store. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {| bar |}];
  (* Now let's start access that binding using the RPC api. *)
  let%fun.F connection = Grpc_test.Server.with_connection server in
  let data =
    Grpc_client.unary Keyval_rpc.Get.rpc ~connection (Keyval.Key.v "foo")
    |> Or_error.join
    |> Or_error.ok_exn
  in
  print_s [%sexp (data : Keyval.Value.t)];
  [%expect {| bar |}];
  ()
;;
