(* In this test we demonstrate how to exercise the command line interface of an
   eio-rpc application talking to a server, from an expect test. The goal is to
   be sort of like a cram test, but using your favorite programming language
   instead of bash. *)

let%expect_test "using the cli" =
  let& env = Eio_main.run in
  let&- t = Grpc_test.run ~env in
  let&- { server = _; client = keyval } =
    Grpc_test.with_server t ~config:Keyval_test.config
  in
  (* At first, there are no keys in the server. *)
  keyval [ [ "list-keys" ] ];
  [%expect {| () |}];
  (* The cli exit with code [1] if we're trying to get an invalid key. *)
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {|
    ("Key not found" ((key foo)))
    [1] |}];
  (* Same for delete. *)
  keyval [ [ "delete" ]; [ "--key"; "foo" ] ];
  [%expect {|
      ("Key not found" ((key foo)))
      [1] |}];
  (* Now let's try to add a binding to the keyval store. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  [%expect {||}];
  (* Now we can get the value back. *)
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {| bar |}];
  (* And we can delete it. *)
  keyval [ [ "delete" ]; [ "--key"; "foo" ] ];
  [%expect {||}];
  (* And now it's gone. *)
  keyval [ [ "get" ]; [ "--key"; "foo" ] ];
  [%expect {|
    ("Key not found" ((key foo)))
    [1] |}];
  (* Let's add it back. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "bar" ] ];
  [%expect {||}];
  (* Let's list the keys again! *)
  keyval [ [ "list-keys" ] ];
  [%expect {| (foo) |}];
  (* And now we test that we can set another key, and overwrite an existing
     key. *)
  keyval [ [ "set" ]; [ "--key"; "foo" ]; [ "--value"; "baz" ] ];
  for i = 0 to 10 do
    keyval
      [ [ "set" ]; [ "--key"; Printf.sprintf "k%02d" i ]; [ "--value"; Int.to_string i ] ]
  done;
  keyval [ [ "list-keys" ] ];
  [%expect {| (foo k00 k01 k02 k03 k04 k05 k06 k07 k08 k09 k10) |}];
  for i = 0 to 10 do
    keyval [ [ "get" ]; [ "--key"; Printf.sprintf "k%02d" i ] ]
  done;
  [%expect
    {|
      0
      1
      2
      3
      4
      5
      6
      7
      8
      9
      10 |}];
  ()
;;
