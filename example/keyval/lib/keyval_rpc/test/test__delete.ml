(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let%expect_test "rountrip" =
  (* There used to be a bug in the deserialization of [Unit]. We monitor for
     regressions here. *)
  Grpc_quickcheck.run_exn
    [%here]
    (module Keyval_rpc.Delete)
    ~requests:[ Keyval.Key.v "foo"; Keyval.Key.v "bar" ]
    ~responses:
      [ Or_error.error_string "Hello Error"
      ; Or_error.error_string ""
      ; Or_error.error_string "()"
      ; Or_error.error_s [%sexp ()]
      ; Ok ()
      ];
  [%expect {||}];
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
     | { error } -> [%sexp { error : string }]);
  [%expect {| ((error "")) |}];
  ()
;;
