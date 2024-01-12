type rpc = unit Grpc_eio.Server.Typed_rpc.t

let unary proto_rpc rpc ~f =
  Grpc_eio.Server.Typed_rpc.unary (Grpc_spec.server_rpc proto_rpc rpc) ~f:(fun req ->
    let res = f req in
    Grpc.Status.v OK, Some res)
;;

let client_streaming proto_rpc rpc ~f =
  Grpc_eio.Server.Typed_rpc.client_streaming
    (Grpc_spec.server_rpc proto_rpc rpc)
    ~f:(fun req ->
      let res = f req in
      Grpc.Status.v OK, Some res)
;;

let server_streaming proto_rpc rpc ~f =
  Grpc_eio.Server.Typed_rpc.server_streaming
    (Grpc_spec.server_rpc proto_rpc rpc)
    ~f:(fun req send_response ->
      f req ~send_response;
      Grpc.Status.v OK)
;;

let bidirectional_streaming proto_rpc rpc ~f =
  Grpc_eio.Server.Typed_rpc.bidirectional_streaming
    (Grpc_spec.server_rpc proto_rpc rpc)
    ~f:(fun req send_response ->
      f req ~send_response;
      Grpc.Status.v OK)
;;
