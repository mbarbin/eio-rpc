module Value_mode : sig
  type unary = Grpc.Rpc.Value_mode.unary
  type stream = Grpc.Rpc.Value_mode.stream
end

(** {1 Creating RPC apis} *)

module Rpc : sig
  type ('request, 'request_mode, 'response, 'response_mode) t
end

module Protoable : sig
  module type S = sig
    type t [@@deriving equal, sexp_of]

    module Proto : sig
      type t
    end

    val of_proto : Proto.t -> t
    val to_proto : t -> Proto.t
  end
end

module Protospec : sig
  module type S = sig
    type request
    type request_mode
    type response
    type response_mode

    val client_rpc
      : (request, request_mode, response, response_mode) Pbrt_services.Client.rpc

    val server_rpc
      : (request, request_mode, response, response_mode) Pbrt_services.Server.rpc
  end
end

module type S = sig
  module Request : sig
    type t [@@deriving equal, sexp_of]
  end

  module Response : sig
    type t [@@deriving equal, sexp_of]
  end

  type request_mode
  type response_mode

  val rpc : (Request.t, request_mode, Response.t, response_mode) Rpc.t
end

type ('request, 'request_mode, 'response, 'response_mode) t =
  (module S
     with type Request.t = 'request
      and type Response.t = 'response
      and type request_mode = 'request_mode
      and type response_mode = 'response_mode)

(** Some type aliases to help managing the complexity of the types. *)

type ('request, 'response) unary =
  ('request, Value_mode.unary, 'response, Value_mode.unary) t

type ('request, 'response) server_streaming =
  ('request, Value_mode.unary, 'response, Value_mode.stream) t

type ('request, 'response) client_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.unary) t

type ('request, 'response) bidirectional_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.stream) t

module Unary : sig
  module type S =
    S with type request_mode = Value_mode.unary and type response_mode = Value_mode.unary

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (_ : Protospec.S
           with type request := Request.Proto.t
            and type request_mode := Pbrt_services.Value_mode.unary
            and type response := Response.Proto.t
            and type response_mode := Pbrt_services.Value_mode.unary) :
    S with module Request := Request and module Response := Response
end

module Client_streaming : sig
  module type S =
    S with type request_mode = Value_mode.stream and type response_mode = Value_mode.unary

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (_ : Protospec.S
           with type request := Request.Proto.t
            and type request_mode := Pbrt_services.Value_mode.stream
            and type response := Response.Proto.t
            and type response_mode := Pbrt_services.Value_mode.unary) :
    S with module Request := Request and module Response := Response
end

module Server_streaming : sig
  module type S =
    S with type request_mode = Value_mode.unary and type response_mode = Value_mode.stream

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (_ : Protospec.S
           with type request := Request.Proto.t
            and type request_mode := Pbrt_services.Value_mode.unary
            and type response := Response.Proto.t
            and type response_mode := Pbrt_services.Value_mode.stream) :
    S with module Request := Request and module Response := Response
end

module Bidirectional_streaming : sig
  module type S =
    S
    with type request_mode = Value_mode.stream
     and type response_mode = Value_mode.stream

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (_ : Protospec.S
           with type request := Request.Proto.t
            and type request_mode := Pbrt_services.Value_mode.stream
            and type response := Response.Proto.t
            and type response_mode := Pbrt_services.Value_mode.stream) :
    S with module Request := Request and module Response := Response
end

(** {1 Grpc Utils}

    The rest of the module contains utils to help creating what is required by
    the [Grpc] library. *)

(** [client_rpc] is used by the implementation of [Grpc_client]. *)
val client_rpc
  :  ('request, 'request_mode, 'response, 'response_mode) t
  -> ('request, 'request_mode, 'response, 'response_mode) Grpc.Rpc.Client_rpc.t

(** [server_rpc] is used by [Grpc_server] to furnish the server implementation
    for a given RPC. *)
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
