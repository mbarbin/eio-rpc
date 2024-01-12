module Rpc : sig
  type t = unit Grpc_eio.Server.Typed_rpc.t

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
    -> t

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
    -> t

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
    -> t

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
    -> t
end

type t

val implement : Rpc.t Pbrt_services.Server.t -> t

val connection_handler
  :  t
  -> sw:Eio.Switch.t
  -> [> [> `Generic ] Eio.Net.stream_socket_ty ] Eio.Resource.t
  -> Eio.Net.Sockaddr.stream
  -> unit
