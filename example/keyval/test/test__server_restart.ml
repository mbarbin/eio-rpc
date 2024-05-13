(* In this test we show that two invocation of [with_server] run distinct
   servers, and due to the particular nature of the [keyval] application, the
   state is not persisted across restarts (our example is only an in-memory
   database). *)

let%expect_test "testing server restart" =
  let& env = Eio_main.run in
  let&- t = Grpc_test.run ~env in
  Grpc_test.with_server t ~config:Keyval_test.config ~f:(fun { client = keyval; _ } ->
    keyval [ [ "list-keys" ] ];
    [%expect {| () |}];
    keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
    [%expect {||}];
    keyval [ [ "get" ]; [ "--key"; "foo" ] ];
    [%expect {| bar |}];
    keyval [ [ "list-keys" ] ];
    [%expect {| (foo) |}]);
  Grpc_test.with_server t ~config:Keyval_test.config ~f:(fun { client = keyval; _ } ->
    keyval [ [ "list-keys" ] ];
    [%expect {| () |}];
    keyval [ [ "get" ]; [ "--key"; "foo" ] ];
    [%expect {|
      ("Key not found" ((key foo)))
      [1] |}]);
  ()
;;
