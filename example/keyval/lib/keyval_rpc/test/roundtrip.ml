let test_request
  (type request request_mode response response_mode)
  (grpc_spec : (request, request_mode, response, response_mode) Grpc_spec.t)
  request
  =
  let module M =
    (val grpc_spec
      : Grpc_spec.S
      with type Request.t = request
       and type request_mode = request_mode
       and type Response.t = response
       and type response_mode = response_mode)
  in
  let buffer = Grpc_spec.Private.encode_request grpc_spec request in
  let request' = Grpc_spec.Private.decode_request grpc_spec buffer in
  require_equal [%here] (module M.Request) request request'
;;

let test_response
  (type request request_mode response response_mode)
  (grpc_spec : (request, request_mode, response, response_mode) Grpc_spec.t)
  response
  =
  let module M =
    (val grpc_spec
      : Grpc_spec.S
      with type Request.t = request
       and type request_mode = request_mode
       and type Response.t = response
       and type response_mode = response_mode)
  in
  let buffer = Grpc_spec.Private.encode_response grpc_spec response in
  let response' = Grpc_spec.Private.decode_response grpc_spec buffer in
  require_equal [%here] (module M.Response) response response'
;;
