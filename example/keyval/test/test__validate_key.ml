(* In this test we show how to use a client command that doesn't connect to the
   running server (offline mode). *)

let%expect_test "offline" =
  let& env = Eio_main.run in
  let&- t = Grpc_test_helpers.run ~env in
  let&- { server = _; client = keyval } =
    Grpc_test_helpers.with_server t ~config:Keyval_test.config
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
    keyval: unknown option '--unix-socket'.
    Usage: keyval validate-key [OPTION]… KEY
    Try 'keyval validate-key --help' or 'keyval --help' for more information.
    [124]
    |}];
  (* This is what the [~offline:true] parameter is about. Let's demonstrate it
     below. *)
  keyval ~offline:false [ [ "validate-key"; "--help=plain" ] ];
  [%expect
    {|
    NAME
           keyval-validate-key - Verify the syntactic validity of a provided key.

    SYNOPSIS
           keyval validate-key [OPTION]… KEY

           This command performs a static validation of the key and does not
           require a connection to a running server.

    ARGUMENTS
           KEY (required)
               The key to validate.

    COMMON OPTIONS
           --help[=FMT] (default=auto)
               Show this help in format FMT. The value FMT must be one of auto,
               pager, groff or plain. With auto, the format is pager or plain
               whenever the TERM env var is dumb or undefined.

           --version
               Show version information.

    EXIT STATUS
           keyval validate-key exits with:

           0   on success.

           123 on indiscriminate errors reported on standard error.

           124 on command line parsing errors.

           125 on unexpected internal errors (bugs).

    SEE ALSO
           keyval(1)
    |}];
  keyval ~offline:true [ [ "validate-key"; "my-key" ] ];
  [%expect
    {|
    "my-key": invalid key
    [1]
    |}];
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
