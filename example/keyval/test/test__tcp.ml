(* In this test we connect to the server using tcp rather than via a unix socket. *)

let%expect_test "using tcp" =
  let& env = Eio_main.run in
  let&- t = Grpc_test.run ~env in
  let&- { server; client = keyval } =
    Grpc_test.with_server t ~config:Keyval_test.config ~sockaddr_kind:Tcp_localhost
  in
  (* First lets's store a binding to the store. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {| bar |}];
  (* Now let's start access that binding using the RPC api. *)
  let&- connection = Grpc_test.Server.with_connection server in
  let data =
    Grpc_client.unary (module Keyval_rpc.Get) ~connection (Keyval.Key.v "foo")
    |> Or_error.join
    |> Or_error.ok_exn
  in
  print_s [%sexp (data : Keyval.Value.t)];
  [%expect {| bar |}];
  ()
;;
