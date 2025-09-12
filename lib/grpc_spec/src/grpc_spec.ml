(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Value_mode = struct
  type unary = Grpc.Rpc.Value_mode.unary
  type stream = Grpc.Rpc.Value_mode.stream
end

module Rpc = struct
  type ('request, 'request_mode, 'response, 'response_mode) t =
    | T :
        { client_rpc :
            ( 'proto_request
              , 'protoc_request_mode
              , 'proto_response
              , 'protoc_response_mode )
              Pbrt_services.Client.rpc
        ; server_rpc :
            ( 'proto_request
              , 'protoc_request_mode
              , 'proto_response
              , 'protoc_response_mode )
              Pbrt_services.Server.rpc
        ; make_client_rpc :
            ( 'proto_request
              , 'protoc_request_mode
              , 'proto_response
              , 'protoc_response_mode )
              Pbrt_services.Client.rpc
            -> ( 'proto_request
                 , 'request_mode
                 , 'proto_response
                 , 'response_mode )
                 Grpc.Rpc.Client_rpc.t
        ; make_server_rpc :
            ( 'proto_request
              , 'protoc_request_mode
              , 'proto_response
              , 'protoc_response_mode )
              Pbrt_services.Server.rpc
            -> ( 'proto_request
                 , 'request_mode
                 , 'proto_response
                 , 'response_mode
                 , unit )
                 Grpc.Rpc.Server_rpc.t
        ; request_to_proto : 'request -> 'proto_request
        ; request_of_proto : 'proto_request -> 'request
        ; response_to_proto : 'response -> 'proto_response
        ; response_of_proto : 'proto_response -> 'response
        }
        -> ('request, 'request_mode, 'response, 'response_mode) t
end

module Protoable = struct
  module type S = sig
    type t [@@deriving equal, sexp_of]

    module Proto : sig
      type t
    end

    val of_proto : Proto.t -> t
    val to_proto : t -> Proto.t
  end
end

let unary
      (type proto_request request proto_response response)
      ~client_rpc
      ~server_rpc
      (module Request : Protoable.S with type t = request and type Proto.t = proto_request)
      (module Response : Protoable.S
        with type t = response
         and type Proto.t = proto_response)
  =
  Rpc.T
    { client_rpc
    ; server_rpc
    ; make_client_rpc = Grpc_protoc.Client_rpc.unary
    ; make_server_rpc = Grpc_protoc.Server_rpc.unary
    ; request_to_proto = Request.to_proto
    ; request_of_proto = Request.of_proto
    ; response_to_proto = Response.to_proto
    ; response_of_proto = Response.of_proto
    }
;;

let server_streaming
      (type proto_request request proto_response response)
      ~client_rpc
      ~server_rpc
      (module Request : Protoable.S with type t = request and type Proto.t = proto_request)
      (module Response : Protoable.S
        with type t = response
         and type Proto.t = proto_response)
  =
  Rpc.T
    { client_rpc
    ; server_rpc
    ; make_client_rpc = Grpc_protoc.Client_rpc.server_streaming
    ; make_server_rpc = Grpc_protoc.Server_rpc.server_streaming
    ; request_to_proto = Request.to_proto
    ; request_of_proto = Request.of_proto
    ; response_to_proto = Response.to_proto
    ; response_of_proto = Response.of_proto
    }
;;

let client_streaming
      (type proto_request request proto_response response)
      ~client_rpc
      ~server_rpc
      (module Request : Protoable.S with type t = request and type Proto.t = proto_request)
      (module Response : Protoable.S
        with type t = response
         and type Proto.t = proto_response)
  =
  Rpc.T
    { client_rpc
    ; server_rpc
    ; make_client_rpc = Grpc_protoc.Client_rpc.client_streaming
    ; make_server_rpc = Grpc_protoc.Server_rpc.client_streaming
    ; request_to_proto = Request.to_proto
    ; request_of_proto = Request.of_proto
    ; response_to_proto = Response.to_proto
    ; response_of_proto = Response.of_proto
    }
;;

let bidirectional_streaming
      (type proto_request request proto_response response)
      ~client_rpc
      ~server_rpc
      (module Request : Protoable.S with type t = request and type Proto.t = proto_request)
      (module Response : Protoable.S
        with type t = response
         and type Proto.t = proto_response)
  =
  Rpc.T
    { client_rpc
    ; server_rpc
    ; make_client_rpc = Grpc_protoc.Client_rpc.bidirectional_streaming
    ; make_server_rpc = Grpc_protoc.Server_rpc.bidirectional_streaming
    ; request_to_proto = Request.to_proto
    ; request_of_proto = Request.of_proto
    ; response_to_proto = Response.to_proto
    ; response_of_proto = Response.of_proto
    }
;;

module Protospec = struct
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

type ('request, 'response) unary =
  ('request, Value_mode.unary, 'response, Value_mode.unary) t

type ('request, 'response) server_streaming =
  ('request, Value_mode.unary, 'response, Value_mode.stream) t

type ('request, 'response) client_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.unary) t

type ('request, 'response) bidirectional_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.stream) t

module Unary = struct
  module type S =
    S with type request_mode = Value_mode.unary and type response_mode = Value_mode.unary

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (Protospec :
         Protospec.S
         with type request := Request.Proto.t
          and type request_mode := Pbrt_services.Value_mode.unary
          and type response := Response.Proto.t
          and type response_mode := Pbrt_services.Value_mode.unary) =
  struct
    type request_mode = Value_mode.unary
    type response_mode = Value_mode.unary

    let rpc =
      unary
        ~client_rpc:Protospec.client_rpc
        ~server_rpc:Protospec.server_rpc
        (module Request)
        (module Response)
    ;;
  end
end

module Client_streaming = struct
  module type S =
    S with type request_mode = Value_mode.stream and type response_mode = Value_mode.unary

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (Protospec :
         Protospec.S
         with type request := Request.Proto.t
          and type request_mode := Pbrt_services.Value_mode.stream
          and type response := Response.Proto.t
          and type response_mode := Pbrt_services.Value_mode.unary) =
  struct
    type request_mode = Value_mode.stream
    type response_mode = Value_mode.unary

    let rpc =
      client_streaming
        ~client_rpc:Protospec.client_rpc
        ~server_rpc:Protospec.server_rpc
        (module Request)
        (module Response)
    ;;
  end
end

module Server_streaming = struct
  module type S =
    S with type request_mode = Value_mode.unary and type response_mode = Value_mode.stream

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (Protospec :
         Protospec.S
         with type request := Request.Proto.t
          and type request_mode := Pbrt_services.Value_mode.unary
          and type response := Response.Proto.t
          and type response_mode := Pbrt_services.Value_mode.stream) =
  struct
    type request_mode = Value_mode.unary
    type response_mode = Value_mode.stream

    let rpc =
      server_streaming
        ~client_rpc:Protospec.client_rpc
        ~server_rpc:Protospec.server_rpc
        (module Request)
        (module Response)
    ;;
  end
end

module Bidirectional_streaming = struct
  module type S =
    S
    with type request_mode = Value_mode.stream
     and type response_mode = Value_mode.stream

  module Make
      (Request : Protoable.S)
      (Response : Protoable.S)
      (Protospec :
         Protospec.S
         with type request := Request.Proto.t
          and type request_mode := Pbrt_services.Value_mode.stream
          and type response := Response.Proto.t
          and type response_mode := Pbrt_services.Value_mode.stream) =
  struct
    type request_mode = Value_mode.stream
    type response_mode = Value_mode.stream

    let rpc =
      bidirectional_streaming
        ~client_rpc:Protospec.client_rpc
        ~server_rpc:Protospec.server_rpc
        (module Request)
        (module Response)
    ;;
  end
end

let client_rpc
  : type request request_mode response response_mode.
    (request, request_mode, response, response_mode) t
    -> (request, request_mode, response, response_mode) Grpc.Rpc.Client_rpc.t
  =
  fun t ->
  let module T =
    (val t
      : S with type request_mode = request_mode and type response_mode = response_mode
       and type Request.t = request and type Response.t = response)
  in
  let map_rpc (rpc : _ Grpc.Rpc.Client_rpc.t) ~request_to_proto ~response_of_proto =
    { rpc with
      encode_request = (fun request -> request |> request_to_proto |> rpc.encode_request)
    ; decode_response = (fun buffer -> buffer |> rpc.decode_response |> response_of_proto)
    }
  in
  match T.rpc with
  | Rpc.T { client_rpc; make_client_rpc; request_to_proto; response_of_proto; _ } ->
    client_rpc |> make_client_rpc |> map_rpc ~request_to_proto ~response_of_proto
;;

let server_rpc
  : type request request_mode response response_mode.
    (request, request_mode, response, response_mode) t
    -> ( request
         , request_mode
         , response
         , response_mode
         , Grpc.Rpc.Service_spec.t )
         Grpc.Rpc.Server_rpc.t
  =
  fun t ->
  let module T =
    (val t
      : S with type request_mode = request_mode and type response_mode = response_mode
       and type Request.t = request and type Response.t = response)
  in
  let map_rpc
        (rpc : _ Grpc.Rpc.Server_rpc.t)
        ~(client_rpc : _ Pbrt_services.Client.rpc)
        ~request_of_proto
        ~response_to_proto
    =
    { rpc with
      service_spec =
        Some { package = client_rpc.package; service_name = client_rpc.service_name }
    ; encode_response =
        (fun response -> response |> response_to_proto |> rpc.encode_response)
    ; decode_request = (fun buffer -> buffer |> rpc.decode_request |> request_of_proto)
    }
  in
  match T.rpc with
  | T { server_rpc; client_rpc; make_server_rpc; request_of_proto; response_to_proto; _ }
    ->
    server_rpc
    |> make_server_rpc
    |> map_rpc ~client_rpc ~request_of_proto ~response_to_proto
;;

module Private = struct
  let service_spec
        (type request request_mode response response_mode)
        (t : (request, request_mode, response, response_mode) t)
    =
    let module T =
      (val t
        : S with type request_mode = request_mode and type response_mode = response_mode
         and type Request.t = request and type Response.t = response)
    in
    let (T t) = T.rpc in
    { Grpc.Rpc.Service_spec.package = t.client_rpc.package
    ; service_name = t.client_rpc.service_name
    }
  ;;

  let encode_request t =
    let client_rpc = client_rpc t in
    client_rpc.encode_request
  ;;

  let decode_request t =
    let server_rpc = server_rpc t in
    server_rpc.decode_request
  ;;

  let encode_response t =
    let server_rpc = server_rpc t in
    server_rpc.encode_response
  ;;

  let decode_response t =
    let client_rpc = client_rpc t in
    client_rpc.decode_response
  ;;
end
