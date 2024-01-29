(* In this test we show how to use a client command that doesn't connect to the
   running server (offline mode). *)

let%expect_test "offline" =
  let%fun env = Eio_main.run in
  let%fun.F t = Grpc_test.run ~env in
  let%fun.F { server = _; client = keyval } =
    Grpc_test.with_server t ~config:Keyval_test.config
  in
  (* By default, [Grpc_test] adds to all commands invocation the necessary
     parameters to find the running server and connect to it. That's what
     happens below, when you list the known keys. *)
  keyval [ [ "list-keys" ] ];
  [%expect {| () |}];
  (* Now, let's say you're trying to use a command that doesn't connect to the
     server. It would normally not expect any of the command line parameters
     related to service discovery. *)
  keyval [ [ "validate-key"; "my-key" ] ];
  [%expect
    {|
    Error parsing command line:

      unknown flag --unix-socket

    For usage information, run

      keyval.exe validate-key -help

    [1] |}];
  (* This is what the [~offline:true] parameter is about. Let's demonstrate it
     below. *)
  keyval ~offline:true [ [ "validate-key"; "my-key" ] ];
  [%expect {|
    ("Keyval.Key.of_string: invalid key" my-key)
    [1] |}];
  keyval ~offline:true [ [ "validate-key"; "my_key" ] ];
  [%expect {| |}];
  ()
;;
