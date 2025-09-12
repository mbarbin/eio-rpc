(*_********************************************************************************)
(*_  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module Rpc : sig
  type t = Grpc.Rpc.Service_spec.t Grpc_eio.Server.Typed_rpc.t

  val unary
    :  ( 'request
         , Grpc_spec.Value_mode.unary
         , 'response
         , Grpc_spec.Value_mode.unary )
         Grpc_spec.t
    -> f:('request -> 'response)
    -> t

  val client_streaming
    :  ( 'request
         , Grpc_spec.Value_mode.stream
         , 'response
         , Grpc_spec.Value_mode.unary )
         Grpc_spec.t
    -> f:('request Grpc_stream.t -> 'response)
    -> t

  val server_streaming
    :  ( 'request
         , Grpc_spec.Value_mode.unary
         , 'response
         , Grpc_spec.Value_mode.stream )
         Grpc_spec.t
    -> f:('request -> send_response:('response -> unit) -> unit)
    -> t

  val bidirectional_streaming
    :  ( 'request
         , Grpc_spec.Value_mode.stream
         , 'response
         , Grpc_spec.Value_mode.stream )
         Grpc_spec.t
    -> f:('request Grpc_stream.t -> send_response:('response -> unit) -> unit)
    -> t
end

type t

val implement : Rpc.t list -> t

val connection_handler
  :  t
  -> sw:Eio.Switch.t
  -> [> [> `Generic ] Eio.Net.stream_socket_ty ] Eio.Resource.t
  -> Eio.Net.Sockaddr.stream
  -> unit
