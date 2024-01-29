let%expect_test "rountrip" =
  Grpc_quickcheck.run_exn (module Keyval_rpc.Set_);
  [%expect {||}];
  ()
;;
