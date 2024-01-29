let%expect_test "rountrip" =
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.List_keys.Request)
      ~f:(fun key -> Roundtrip.test_request (module Keyval_rpc.List_keys) key));
  [%expect {||}];
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.List_keys.Response)
      ~f:(fun response -> Roundtrip.test_response (module Keyval_rpc.List_keys) response));
  [%expect {||}];
  ()
;;
