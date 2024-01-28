let%expect_test "rountrip" =
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Delete.Request)
      ~examples:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ]
      ~f:(fun key ->
        Roundtrip.test_request
          Keyval_rpc.Delete.rpc
          (module Keyval_rpc.Delete.Request)
          key));
  [%expect {||}];
  require_does_not_raise [%here] (fun () ->
    Base_quickcheck.Test.run_exn
      (module Keyval_rpc.Delete.Response)
      ~f:(fun response ->
        Roundtrip.test_response
          Keyval_rpc.Delete.rpc
          (module Keyval_rpc.Delete.Response)
          response));
  [%expect
    {| |}];
  ()
;;

(* There used to be a bug in the deserialization of [Unit]. We monitor for
   regressions here. *)

let%expect_test "roundtrip" =
  let test key =
    Roundtrip.test_response Keyval_rpc.Delete.rpc (module Keyval_rpc.Delete.Response) key
  in
  require_does_not_raise [%here] (fun () -> test (Or_error.error_string "Hello Error"));
  [%expect {||}];
  require_does_not_raise [%here] (fun () -> test (Or_error.error_string ""));
  [%expect {||}];
  require_does_not_raise [%here] (fun () -> test (Ok ()));
  [%expect
    {| |}];
  ()
;;

let%expect_test "encoding of Unit" =
  let encoder = Pbrt.Encoder.create () in
  Keyval_rpc_proto.Keyval.encode_pb_unit_or_error { error = "" } encoder;
  let encoded = Pbrt.Encoder.to_string encoder in
  print_s [%sexp { encoded : string }];
  [%expect {| ((encoded "\n\000")) |}];
  let decoder = Pbrt.Decoder.of_string encoded in
  let decoded = Keyval_rpc_proto.Keyval.decode_pb_unit_or_error decoder in
  print_s
    (match decoded with
     | { error } -> [%sexp Error (error : string)]);
  [%expect {| (Error "") |}];
  ()
;;
