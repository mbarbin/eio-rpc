(* In this test we show how to use a client command that doesn't connect to the
   running server (offline mode). *)

let%expect_test "offline" =
  let& env = Eio_main.run in
  let&- t = Grpc_test.run ~env in
  let&- { server = _; client = keyval } =
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
  keyval ~offline:false [ [ "validate-key"; "--help" ] ];
  [%expect
    {|
       verify the syntactic validity of a provided key

         keyval.exe validate-key KEY

       This command performs a static validation of the key and does not require a
       connection to a running server.

       === flags ===

         [-help], -?                . print this help text and exit |}];
  keyval ~offline:true [ [ "validate-key"; "my-key" ] ];
  [%expect {|
    ("Keyval.Key.of_string: invalid key" my-key)
    [1] |}];
  keyval ~offline:true [ [ "validate-key"; "my_key" ] ];
  [%expect {||}];
  (* If you're trying to use [offline:true] with a command that actually does
     need to connect to the server, you'll be left with whatever connection
     specification is chosen by default. In this application, this is
     [localhost:8080], which is not an address where a keyval server is listening
     during the tests. *)
  keyval ~offline:true [ [ "list-keys" ] ];
  [%expect
    {|
    ( "Eio.Io Net Connection_failure Refused Unix_error (Connection refused, \"connect\", \"\"),\
     \n  connecting to tcp:127.0.0.1:8080")
    [1] |}];
  ()
;;
