let%expect_test "rountrip" =
  Grpc_quickcheck.run_exn [%here] (module Keyval_rpc.List_keys);
  [%expect {||}];
  ()
;;
