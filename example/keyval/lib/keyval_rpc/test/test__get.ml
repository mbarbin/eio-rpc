let%expect_test "rountrip" =
  Grpc_quickcheck.run_exn
    (module Keyval_rpc.Get)
    ~requests:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ];
  [%expect {||}];
  ()
;;
