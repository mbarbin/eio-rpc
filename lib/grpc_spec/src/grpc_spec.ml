module Value_mode = struct
  type unary = Grpc.Rpc.Value_mode.unary
  type stream = Grpc.Rpc.Value_mode.stream
end

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

type ('request, 'response) unary =
  ('request, Value_mode.unary, 'response, Value_mode.unary) t

type ('request, 'response) server_streaming =
  ('request, Value_mode.unary, 'response, Value_mode.stream) t

type ('request, 'response) client_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.unary) t

type ('request, 'response) bidirectional_streaming =
  ('request, Value_mode.stream, 'response, Value_mode.stream) t

module Protoable = struct
  module type S = sig
    type t

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
  (module Response : Protoable.S with type t = response and type Proto.t = proto_response)
  =
  T
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
  (module Response : Protoable.S with type t = response and type Proto.t = proto_response)
  =
  T
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
  (module Response : Protoable.S with type t = response and type Proto.t = proto_response)
  =
  T
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
  (module Response : Protoable.S with type t = response and type Proto.t = proto_response)
  =
  T
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

let client_rpc
  : type proto_request request request_mode protoc_request_mode proto_response response response_mode protoc_response_mode.
    (request, request_mode, response, response_mode) t
    -> (request, request_mode, response, response_mode) Grpc.Rpc.Client_rpc.t
  =
  fun t ->
  let map_rpc (rpc : _ Grpc.Rpc.Client_rpc.t) ~request_to_proto ~response_of_proto =
    { rpc with
      encode_request = (fun request -> request |> request_to_proto |> rpc.encode_request)
    ; decode_response = (fun buffer -> buffer |> rpc.decode_response |> response_of_proto)
    }
  in
  match t with
  | T { client_rpc; make_client_rpc; request_to_proto; response_of_proto; _ } ->
    client_rpc |> make_client_rpc |> map_rpc ~request_to_proto ~response_of_proto
;;

let server_rpc
  : type proto_request request request_mode protoc_request_mode proto_response response response_mode protoc_response_mode.
    (request, request_mode, response, response_mode) t
    -> ( request
         , request_mode
         , response
         , response_mode
         , Grpc.Rpc.Service_spec.t )
         Grpc.Rpc.Server_rpc.t
  =
  fun (T t as t') ->
  let map_rpc (rpc : _ Grpc.Rpc.Server_rpc.t) ~request_of_proto ~response_to_proto =
    { rpc with
      service_spec =
        Some { package = t.client_rpc.package; service_name = t.client_rpc.service_name }
    ; encode_response =
        (fun response -> response |> response_to_proto |> rpc.encode_response)
    ; decode_request = (fun buffer -> buffer |> rpc.decode_request |> request_of_proto)
    }
  in
  match t' with
  | T { server_rpc; make_server_rpc; request_of_proto; response_to_proto; _ } ->
    server_rpc |> make_server_rpc |> map_rpc ~request_of_proto ~response_to_proto
;;

module Private = struct
  let service_spec (T t) =
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
