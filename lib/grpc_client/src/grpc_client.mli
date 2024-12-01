module Connection : sig
  type t = H2_eio.Client.t

  val raise_client_error : H2.Client_connection.error -> _
end

val with_connection
  :  env:< net : [> [ `Generic | `Unix ] Eio.Net.ty ] Eio.Resource.t ; .. >
  -> sockaddr:Eio.Net.Sockaddr.stream
  -> f:(Connection.t -> 'a Or_error.t)
  -> 'a Or_error.t

val unary
  :  ('request, 'response) Grpc_spec.unary
  -> connection:Connection.t
  -> 'request
  -> 'response Or_error.t

val server_streaming
  :  ('request, 'response) Grpc_spec.server_streaming
  -> connection:Connection.t
  -> 'request
  -> 'response Grpc_stream.t Or_error.t

val client_streaming
  :  ('request, 'response) Grpc_spec.client_streaming
  -> connection:Connection.t
  -> f:('request Grpc_stream.Writer.t -> 'response option Eio.Promise.t -> 'a)
  -> 'a Or_error.t

val bidirectional_streaming
  :  ('request, 'response) Grpc_spec.bidirectional_streaming
  -> connection:Connection.t
  -> f:('request Grpc_stream.Writer.t -> 'response Grpc_stream.t -> 'a)
  -> 'a Or_error.t
