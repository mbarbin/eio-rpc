module Value_mode : sig
  type unary = Grpc.Rpc.Value_mode.unary
  type stream = Grpc.Rpc.Value_mode.stream
end

type ('request, 'request_mode, 'response, 'response_mode) t

(** Some type aliases to help managing the complexity of the types. *)

type ('request, 'response) unary =
  ('request, Value_mode.unary, 'response, Value_mode.unary) t

type ('request, 'response) server_streaming =
  ('request, Value_mode.unary, 'response, Value_mode.stream) t

type ('request, 'response) client_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.unary) t

type ('request, 'response) bidirectional_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.stream) t

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
  :  client_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.unary
         , 'proto_response
         , Pbrt_services.Value_mode.unary )
         Pbrt_services.Client.rpc
  -> server_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.unary
         , 'proto_response
         , Pbrt_services.Value_mode.unary )
         Pbrt_services.Server.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('request, 'response) unary

val server_streaming
  :  client_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.unary
         , 'proto_response
         , Pbrt_services.Value_mode.stream )
         Pbrt_services.Client.rpc
  -> server_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.unary
         , 'proto_response
         , Pbrt_services.Value_mode.stream )
         Pbrt_services.Server.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('request, 'response) server_streaming

val client_streaming
  :  client_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.stream
         , 'proto_response
         , Pbrt_services.Value_mode.unary )
         Pbrt_services.Client.rpc
  -> server_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.stream
         , 'proto_response
         , Pbrt_services.Value_mode.unary )
         Pbrt_services.Server.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('request, 'response) client_streaming

val bidirectional_streaming
  :  client_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.stream
         , 'proto_response
         , Pbrt_services.Value_mode.stream )
         Pbrt_services.Client.rpc
  -> server_rpc:
       ( 'proto_request
         , Pbrt_services.Value_mode.stream
         , 'proto_response
         , Pbrt_services.Value_mode.stream )
         Pbrt_services.Server.rpc
  -> (module Protoable.S with type t = 'request and type Proto.t = 'proto_request)
  -> (module Protoable.S with type t = 'response and type Proto.t = 'proto_response)
  -> ('request, 'response) bidirectional_streaming

(** {1 Grpc Utils}

    The rest of the module contains utils to help creating what is required by
    the [Grpc] library. *)

(** [client_rpc] is used by the implementation of {!module:Grpc_client}. *)
val client_rpc
  :  ('request, 'request_mode, 'response, 'response_mode) t
  -> ('request, 'request_mode, 'response, 'response_mode) Grpc.Rpc.Client_rpc.t

(** [server_rpc] is used by {!module:Grpc_server} to furnish the server
    implementation for a given RPC. *)
val server_rpc
  :  ('request, 'request_mode, 'response, 'response_mode) t
  -> ( 'request
       , 'request_mode
       , 'response
       , 'response_mode
       , Grpc.Rpc.Service_spec.t )
       Grpc.Rpc.Server_rpc.t

module Private : sig
  (** The [Private] module is not meant to be used by the users of the library
      directly. It is exported for tests. *)

  val service_spec : _ t -> Grpc.Rpc.Service_spec.t
  val encode_request : ('request, _, _, _) t -> 'request -> string
  val decode_request : ('request, _, _, _) t -> string -> 'request
  val encode_response : (_, _, 'response, _) t -> 'response -> string
  val decode_response : (_, _, 'response, _) t -> string -> 'response
end
