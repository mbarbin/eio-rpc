module Client_connection_error = struct
  type t = H2.Client_connection.error

  let sexp_of_t : t -> Sexplib0.Sexp.t = function
    | `Malformed_response msg -> List [ Atom "Malformed_response"; Atom msg ]
    | `Invalid_response_body_length response ->
      let response = Stdlib.Format.asprintf "%a" H2.Response.pp_hum response in
      List
        [ Atom "Invalid_response_body_length"; List [ Atom "response"; Atom response ] ]
    | `Protocol_error (error_code, msg) ->
      List
        [ Atom "Protocol_error"
        ; List
            [ List [ Atom "error_code"; Atom (H2.Error_code.to_string error_code) ]
            ; List [ Atom "msg"; Atom msg ]
            ]
        ]
    | `Exn exn -> List [ Atom "Exn"; Sexplib0.Sexp_conv.sexp_of_exn exn ]
  ;;
end

module E = struct
  type t =
    | Client_connection_error of { error : Client_connection_error.t }
    | No_response of { status : Grpc.Status.t }
    | H2_error of { status : H2.Status.t }

  let sexp_of_t = function
    | Client_connection_error { error } -> Client_connection_error.sexp_of_t error
    | No_response { status } ->
      List [ Atom "No_response"; List [ Atom "status"; Atom (Grpc.Status.show status) ] ]
    | H2_error { status } ->
      List
        [ Atom "H2 error"
        ; List [ Atom "code"; Atom (Int.to_string (H2.Status.to_code status)) ]
        ]
  ;;
end

exception E of E.t

let () =
  Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor E] (function
    | E e -> E.sexp_of_t e
    | _ -> assert false)
;;

module Connection = struct
  type t = H2_eio.Client.t

  let raise_client_error (error : H2.Client_connection.error) =
    match error with
    | `Exn exn -> Exn.raise_without_backtrace exn
    | `Malformed_response _ | `Invalid_response_body_length _ | `Protocol_error _ ->
      raise (E (Client_connection_error { error }))
  ;;
end

let with_connection ~env ~sockaddr ~f =
  Eio.Switch.run
  @@ fun sw ->
  match
    Or_error.try_with (fun () ->
      let socket = Eio.Net.connect ~sw (Eio.Stdenv.net env) sockaddr in
      H2_eio.Client.create_connection
        ~sw
        ~error_handler:Connection.raise_client_error
        socket)
  with
  | Error _ as error -> error
  | Ok connection ->
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
  | Ok (None, status) -> Or_error.of_exn (E (No_response { status }))
  | Error status -> Or_error.of_exn (E (H2_error { status }))
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
  | Error status -> Or_error.of_exn (E (H2_error { status }))
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
  | Error status -> Or_error.of_exn (E (H2_error { status }))
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
  | Error status -> Or_error.of_exn (E (H2_error { status }))
;;
