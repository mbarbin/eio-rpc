val test_request : ('request, _, _, _) Grpc_spec.t -> 'request -> unit
val test_response : (_, _, 'response, _) Grpc_spec.t -> 'response -> unit
