module Value_mode : sig
  type unary = Grpc.Rpc.Value_mode.unary
  type stream = Grpc.Rpc.Value_mode.stream
end

type ('proto_request
     , 'request
     , 'request_mode
     , 'protoc_request_mode
     , 'proto_response
     , 'response
     , 'response_mode
     , 'protoc_response_mode)
     t

(** Some type aliases to help managing the complexity of the types. *)

type ('proto_request, 'request, 'proto_response, 'response) unary =
  ( 'proto_request
    , 'request
    , Value_mode.unary
    , Pbrt_services.Value_mode.unary
    , 'proto_response
    , 'response
    , Value_mode.unary
    , Pbrt_services.Value_mode.unary )
    t

type ('proto_request, 'request, 'proto_response, 'response) server_streaming =
  ( 'proto_request
    , 'request
    , Value_mode.unary
    , Pbrt_services.Value_mode.unary
    , 'proto_response
    , 'response
    , Value_mode.stream
    , Pbrt_services.Value_mode.stream )
    t

type ('proto_request, 'request, 'proto_response, 'response) client_streaming =
  ( 'proto_request
    , 'request
    , Value_mode.stream
    , Pbrt_services.Value_mode.stream
    , 'proto_response
    , 'response
    , Value_mode.unary
    , Pbrt_services.Value_mode.unary )
    t

type ('proto_request, 'request, 'proto_response, 'response) bidirectional_streaming =
  ( 'proto_request
    , 'request
    , Value_mode.stream
    , Pbrt_services.Value_mode.stream
    , 'proto_response
    , 'response
    , Value_mode.stream
    , Pbrt_services.Value_mode.stream )
    t

(** {1 Creating RPC apis} *)

module Protoable : sig
  module type S = sig
    type t

    module Proto : sig
      type t
    end

    val of_proto : Proto.t -> t
    val to_proto : t -> Proto.t
  end
end

val unary
  :  ( 'proto_request
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , Pbrt_services.Value_mode.unary )
       Pbrt_services.Client.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('proto_request, 'request, 'proto_response, 'response) unary

val server_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.unary
       , 'proto_response
       , Pbrt_services.Value_mode.stream )
       Pbrt_services.Client.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('proto_request, 'request, 'proto_response, 'response) server_streaming

val client_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , Pbrt_services.Value_mode.unary )
       Pbrt_services.Client.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('proto_request, 'request, 'proto_response, 'response) client_streaming

val bidirectional_streaming
  :  ( 'proto_request
       , Pbrt_services.Value_mode.stream
       , 'proto_response
       , Pbrt_services.Value_mode.stream )
       Pbrt_services.Client.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('proto_request, 'request, 'proto_response, 'response) bidirectional_streaming

(** {1 Grpc Utils}

    The rest of the module contains utils to help creating what is required by
    the [Grpc] library. *)

(** [client_rpc] is used by the implementation of {!module:Grpc_client}. *)
val client_rpc
  :  (_, 'request, 'request_mode, _, _, 'response, 'response_mode, _) t
  -> ('request, 'request_mode, 'response, 'response_mode) Grpc.Rpc.Client_rpc.t

(** [server_rpc] is used by {!module:Grpc_server} to furnish the server
    implementation for a given RPC. *)
val server_rpc
  :  ( 'proto_request
       , 'protoc_request_mode
       , 'proto_response
       , 'protoc_response_mode )
       Pbrt_services.Server.rpc
  -> ( 'proto_request
       , 'request
       , 'request_mode
       , 'protoc_request_mode
       , 'proto_response
       , 'response
       , 'response_mode
       , 'protoc_response_mode )
       t
  -> ('request, 'request_mode, 'response, 'response_mode, unit) Grpc.Rpc.Server_rpc.t
