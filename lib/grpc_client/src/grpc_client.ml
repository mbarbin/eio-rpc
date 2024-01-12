module Connection = struct
  type t = H2_eio.Client.t
end

let with_connection ~env ~sw ~addr ~f =
  let socket = Eio.Net.connect ~sw (Eio.Stdenv.net env) addr in
  let connection = H2_eio.Client.create_connection ~sw ~error_handler:ignore socket in
  Exn.protect
    ~f:(fun () -> f connection)
    ~finally:(fun () -> Eio.Promise.await (H2_eio.Client.shutdown connection))
;;

let unary rpc ~connection request =
  match
    Grpc_eio.Client.Typed_rpc.call
      (Grpc_spec.client_rpc rpc)
      ~do_request:(H2_eio.Client.request connection ~error_handler:ignore)
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
      ~do_request:(H2_eio.Client.request connection ~error_handler:ignore)
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
      ~do_request:(H2_eio.Client.request connection ~error_handler:ignore)
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
      ~do_request:(H2_eio.Client.request connection ~error_handler:ignore)
      ~handler:(Grpc_eio.Client.Typed_rpc.bidirectional_streaming ~f)
      ()
  with
  | Ok (res, (_ : Grpc.Status.t)) -> Ok res
  | Error h2_status ->
    Or_error.error_s [%sexp "h2 error", { code = (H2.Status.to_code h2_status : int) }]
;;
