module type S = sig
  module Request : sig
    type t [@@deriving equal, quickcheck, sexp_of]
  end

  module Response : sig
    type t [@@deriving equal, quickcheck, sexp_of]
  end

  include Grpc_spec.S with module Request := Request and module Response := Response
end

type ('request, 'request_mode, 'response, 'response_mode) t =
  (module S
     with type Request.t = 'request
      and type Response.t = 'response
      and type request_mode = 'request_mode
      and type response_mode = 'response_mode)

let run_request_exn
  (type request request_mode response response_mode)
  ?config
  ?examples
  (t : (request, request_mode, response, response_mode) t)
  =
  let module M =
    (val t
      : S
      with type Request.t = request
       and type request_mode = request_mode
       and type Response.t = response
       and type response_mode = response_mode)
  in
  Base_quickcheck.Test.run_exn
    (module M.Request)
    ?config
    ?examples
    ~f:(fun request ->
      let buffer = Grpc_spec.Private.encode_request (module M) request in
      let request' = Grpc_spec.Private.decode_request (module M) buffer in
      require_equal [%here] (module M.Request) request request')
;;

let run_response_exn
  (type request request_mode response response_mode)
  ?config
  ?examples
  (t : (request, request_mode, response, response_mode) t)
  =
  let module M =
    (val t
      : S
      with type Request.t = request
       and type request_mode = request_mode
       and type Response.t = response
       and type response_mode = response_mode)
  in
  Base_quickcheck.Test.run_exn
    (module M.Response)
    ?config
    ?examples
    ~f:(fun response ->
      let buffer = Grpc_spec.Private.encode_response (module M) response in
      let response' = Grpc_spec.Private.decode_response (module M) buffer in
      require_equal [%here] (module M.Response) response response')
;;

let run_exn ?config ?requests ?responses t =
  run_request_exn ?config ?examples:requests t;
  run_response_exn ?config ?examples:responses t
;;
