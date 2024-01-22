(* In this test we demonstrate that we can use the OCaml rpc library in tests in
   addition to the cli. *)

let%expect_test "with_connection" =
  let%fun env = Eio_main.run in
  let%fun.F t = Grpc_test.run ~env in
  let%fun.F { server; client = keyval } =
    Grpc_test.with_server t ~config:Keyval_test.config
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
