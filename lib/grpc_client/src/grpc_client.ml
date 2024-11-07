module Connection = struct
  type t = H2_eio.Client.t

  let raise_client_error (error : H2.Client_connection.error) =
    match error with
    | `Malformed_response msg -> raise_s [%sexp `Malformed_response (msg : string)]
    | `Invalid_response_body_length response ->
      let response = Stdlib.Format.asprintf "%a" H2.Response.pp_hum response in
      raise_s [%sexp `Invalid_response_body_length (response : string)]
    | `Protocol_error (error_code, msg) ->
      raise_s
        [%sexp
          `Protocol_error
            { error_code = (H2.Error_code.to_string error_code : string); msg : string }]
    | `Exn exn -> Exn.raise_without_backtrace exn
  ;;
end

let with_connection ~env ~sockaddr ~f =
  Eio.Switch.run
  @@ fun sw ->
  let%bind.Or_error connection =
    Or_error.try_with (fun () ->
      let socket = Eio.Net.connect ~sw (Eio.Stdenv.net env) sockaddr in
      H2_eio.Client.create_connection
        ~sw
        ~error_handler:Connection.raise_client_error
        socket)
  in
  Exn.protect
    ~f:(fun () -> f connection)
    ~finally:(fun () -> Eio.Promise.await (H2_eio.Client.shutdown connection))
;;

let unary rpc ~connection request =
  match
    Grpc_eio.Client.Typed_rpc.call
      (Grpc_spec.client_rpc rpc)
      ~do_request:
        (H2_eio.Client.request connection ~error_handler:Connection.raise_client_error)
      ~handler:(Grpc_eio.Client.Typed_rpc.unary request ~f:Fn.id)
      ()
  with
  | Ok (Some res, (_ : Grpc.Status.t)) -> Ok res
  | Ok (None, status) ->
    Or_error.error_s
      [%sexp "no response", { status = (Grpc.Status.show status : string) }]
  | Error h2_status ->
    Or_error.error_s [%sexp "h2 error", { code = (H2.Status.to_code h2_status : int) }]
;;

let server_streaming rpc ~connection request =
  match
    Grpc_eio.Client.Typed_rpc.call
      (Grpc_spec.client_rpc rpc)
      ~do_request:
        (H2_eio.Client.request connection ~error_handler:Connection.raise_client_error)
      ~handler:(Grpc_eio.Client.Typed_rpc.server_streaming request ~f:Fn.id)
      ()
  with
  | Ok (res, (_ : Grpc.Status.t)) -> Ok res
  | Error h2_status ->
    Or_error.error_s [%sexp "h2 error", { code = (H2.Status.to_code h2_status : int) }]
;;

let client_streaming rpc ~connection ~f =
  match
    Grpc_eio.Client.Typed_rpc.call
      (Grpc_spec.client_rpc rpc)
      ~do_request:
        (H2_eio.Client.request connection ~error_handler:Connection.raise_client_error)
      ~handler:(Grpc_eio.Client.Typed_rpc.client_streaming ~f)
      ()
  with
  | Ok (res, (_ : Grpc.Status.t)) -> Ok res
  | Error h2_status ->
    Or_error.error_s [%sexp "h2 error", { code = (H2.Status.to_code h2_status : int) }]
;;

let bidirectional_streaming rpc ~connection ~f =
  match
    Grpc_eio.Client.Typed_rpc.call
      (Grpc_spec.client_rpc rpc)
      ~do_request:
        (H2_eio.Client.request connection ~error_handler:Connection.raise_client_error)
      ~handler:(Grpc_eio.Client.Typed_rpc.bidirectional_streaming ~f)
      ()
  with
  | Ok (res, (_ : Grpc.Status.t)) -> Ok res
  | Error h2_status ->
    Or_error.error_s [%sexp "h2 error", { code = (H2.Status.to_code h2_status : int) }]
;;
