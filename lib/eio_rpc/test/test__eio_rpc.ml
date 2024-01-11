let%expect_test "hello" =
  print_s Eio_rpc.hello_world;
  [%expect {| "Hello, World!" |}]
;;
