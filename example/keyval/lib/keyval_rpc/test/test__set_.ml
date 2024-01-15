let%expect_test "rountrip" =
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Set_.Request)
      ~f:(fun key ->
        Roundtrip.test_request Keyval_rpc.Set_.rpc (module Keyval_rpc.Set_.Request) key));
  [%expect {||}];
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Set_.Response)
      ~f:(fun response ->
        Roundtrip.test_response
          Keyval_rpc.Set_.rpc
          (module Keyval_rpc.Set_.Response)
          response));
  [%expect {||}];
  ()
;;
