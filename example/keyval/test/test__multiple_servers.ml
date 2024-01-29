(* In this test we demonstrate that the testing API allows for running multiple
   servers in parallel, in case this is intersting for a particular test case.

   For the sake of the example here, we'll just run two servers and have a
   function to feed the keys from one server to the other.

   So it's easier to implement, we'll actually make use of the OCaml RPC
   interface for this, rather than pure cli. This way, this test can also
   server an example of mixing the RPC and cli interfaces in a test. *)

(* A util to push all bindings from server1 to server2. *)
let push_all_bindings ~connection1 ~connection2 =
  let keys =
    Grpc_client.unary (module Keyval_rpc.List_keys) ~connection:connection1 ()
    |> Or_error.ok_exn
  in
  Set.iter keys ~f:(fun key ->
    let value =
      Grpc_client.unary (module Keyval_rpc.Get) ~connection:connection1 key
      |> Or_error.join
      |> Or_error.ok_exn
    in
    Grpc_client.unary (module Keyval_rpc.Set_) ~connection:connection2 { key; value }
    |> Or_error.ok_exn)
;;

(* A util to get all bindings, via multiple RPCs (this could also be served
   directly as an RPC, this is just for the sake of the example). *)
let all_bindings ~connection =
  let keys =
    Grpc_client.unary (module Keyval_rpc.List_keys) ~connection () |> Or_error.ok_exn
  in
  List.map (Set.to_list keys) ~f:(fun key ->
    let value =
      Grpc_client.unary (module Keyval_rpc.Get) ~connection key
      |> Or_error.join
      |> Or_error.ok_exn
    in
    { Keyval.Keyval_pair.key; value })
;;

let%expect_test "two servers" =
  let%fun env = Eio_main.run in
  let%fun.F t = Grpc_test.run ~env in
  let%fun.F { server = server1; client = cli1 } =
    Grpc_test.with_server t ~config:Keyval_test.config
  in
  let%fun.F { server = server2; client = cli2 } =
    Grpc_test.with_server t ~config:Keyval_test.config
  in
  let%fun.F connection1 = Grpc_test.Server.with_connection server1 in
  let%fun.F connection2 = Grpc_test.Server.with_connection server2 in
  (* At first, none of the servers have keys. *)
  cli1 [ [ "list-keys" ] ];
  [%expect {| () |}];
  cli2 [ [ "list-keys" ] ];
  [%expect {| () |}];
  for i = 0 to 3 do
    cli1
      [ [ "set" ]; [ "--key"; Printf.sprintf "k%02d" i ]; [ "--value"; Int.to_string i ] ]
  done;
  cli1 [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  cli1 [ [ "list-keys" ] ];
  [%expect {| (foo k00 k01 k02 k03) |}];
  (* For the sake of the example, let's also have foo in server2. It
     will be replaced after we push all bindings from server1 to
     server2. *)
  cli2 [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "OLD-VALUE" ] ];
  cli2 [ [ "set" ]; [ "--key"; "bar" ]; [ "--value"; "sna" ] ];
  print_s [%sexp (all_bindings ~connection:connection2 : Keyval.Keyval_pair.t list)];
  [%expect {|
    (((key bar) (value sna))
     ((key foo) (value OLD-VALUE))) |}];
  push_all_bindings ~connection1 ~connection2;
  [%expect {||}];
  cli2 [ [ "list-keys" ] ];
  [%expect {| (bar foo k00 k01 k02 k03) |}];
  print_s [%sexp (all_bindings ~connection:connection2 : Keyval.Keyval_pair.t list)];
  [%expect
    {|
    (((key bar) (value sna))
     ((key foo) (value bar))
     ((key k00) (value 0))
     ((key k01) (value 1))
     ((key k02) (value 2))
     ((key k03) (value 3))) |}];
  ()
;;
