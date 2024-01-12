module Rpc = struct
  type t = unit Grpc_eio.Server.Typed_rpc.t

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
end

type t = Grpc_eio.Server.t

let implement server = server |> Grpc_protoc.handlers |> Grpc_eio.Server.Typed_rpc.server

let connection_handler server ~sw =
  let error_handler client_address ?request:_ _error start_response =
    Eio.traceln "Error in request from:%a" Eio.Net.Sockaddr.pp client_address;
    let response_body = start_response H2.Headers.empty in
    H2.Body.Writer.write_string
      response_body
      "There was an error handling your request.\n";
    H2.Body.Writer.close response_body
  in
  let request_handler client_address request_descriptor =
    Eio.Fiber.fork ~sw (fun () ->
      Eio.traceln "Received request from:%a" Eio.Net.Sockaddr.pp client_address;
      Grpc_eio.Server.handle_request server request_descriptor)
  in
  fun socket addr ->
    H2_eio.Server.create_connection_handler
      ?config:None
      ~request_handler
      ~error_handler
      addr
      socket
      ~sw
;;
