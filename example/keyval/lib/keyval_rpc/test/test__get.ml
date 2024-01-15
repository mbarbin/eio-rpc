let%expect_test "rountrip" =
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Get.Request)
      ~examples:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ]
      ~f:(fun key ->
        Roundtrip.test_request Keyval_rpc.Get.rpc (module Keyval_rpc.Get.Request) key));
  [%expect {||}];
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Get.Response)
      ~f:(fun response ->
        Roundtrip.test_response
          Keyval_rpc.Get.rpc
          (module Keyval_rpc.Get.Response)
          response));
  [%expect {||}];
  ()
;;
