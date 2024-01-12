type rpc = unit Grpc_eio.Server.Typed_rpc.t

val unary
  :  ( 'proto_request
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , Pbrt_services.Value_mode.unary )
       Pbrt_services.Server.rpc
  -> ( 'proto_request
       , 'request
       , Grpc_spec.Value_mode.unary
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , 'response
       , Grpc_spec.Value_mode.unary
       , Pbrt_services.Value_mode.unary )
       Grpc_spec.t
  -> f:('request -> 'response)
  -> rpc

val client_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , Pbrt_services.Value_mode.unary )
       Pbrt_services.Server.rpc
  -> ( 'proto_request
       , 'request
       , Grpc_spec.Value_mode.stream
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , 'response
       , Grpc_spec.Value_mode.unary
       , Pbrt_services.Value_mode.unary )
       Grpc_spec.t
  -> f:('request Grpc_stream.t -> 'response)
  -> rpc

val server_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , Pbrt_services.Value_mode.stream )
       Pbrt_services.Server.rpc
  -> ( 'proto_request
       , 'request
       , Grpc_spec.Value_mode.unary
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , 'response
       , Grpc_spec.Value_mode.stream
       , Pbrt_services.Value_mode.stream )
       Grpc_spec.t
  -> f:('request -> send_response:('response -> unit) -> unit)
  -> rpc

val bidirectional_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , Pbrt_services.Value_mode.stream )
       Pbrt_services.Server.rpc
  -> ( 'proto_request
       , 'request
       , Grpc_spec.Value_mode.stream
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , 'response
       , Grpc_spec.Value_mode.stream
       , Pbrt_services.Value_mode.stream )
       Grpc_spec.t
  -> f:('request Grpc_stream.t -> send_response:('response -> unit) -> unit)
  -> rpc
