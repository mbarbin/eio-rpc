module type T = sig
  type t [@@deriving equal, sexp_of]
end

val test_request
  :  ('request, _, _, _) Grpc_spec.t
  -> (module T with type t = 'request)
  -> 'request
  -> unit

val test_response
  :  (_, _, 'response, _) Grpc_spec.t
  -> (module T with type t = 'response)
  -> 'response
  -> unit
