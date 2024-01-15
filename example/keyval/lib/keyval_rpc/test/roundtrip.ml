module type T = sig
  type t [@@deriving equal, sexp_of]
end

let test_request (type request) grpc_spec (module T : T with type t = request) request =
  let buffer = Grpc_spec.Private.encode_request grpc_spec request in
  let request' = Grpc_spec.Private.decode_request grpc_spec buffer in
  require_equal [%here] (module T) request request'
;;

let test_response (type response) grpc_spec (module T : T with type t = response) response
  =
  let buffer = Grpc_spec.Private.encode_response grpc_spec response in
  let response' = Grpc_spec.Private.decode_response grpc_spec buffer in
  require_equal [%here] (module T) response response'
;;
