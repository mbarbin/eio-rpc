module Config = struct
  module Process_command = struct
    type t =
      { executable : string
      ; args : string list
      }

    let to_string_list { executable; args } = executable :: args
  end

  module Client_invocation = struct
    type t =
      | Connect_to of { connection_config : Grpc_discovery.Connection_config.t }
      | Offline
  end

  module type S = sig
    val run_server_command
      :  listening_config:Grpc_discovery.Listening_config.t
      -> Process_command.t

    val run_client_command
      :  client_invocation:Client_invocation.t
      -> args:string list
      -> Process_command.t
  end

  type t = (module S)

  let create s = s

  let grpc_discovery ~run_server_command ~run_client_command : t =
    let module Config : S = struct
      let run_server_command ~listening_config =
        let { Process_command.executable; args } = run_server_command in
        { Process_command.executable
        ; args = args @ Grpc_discovery.Listening_config.to_params listening_config
        }
      ;;

      let run_client_command ~client_invocation ~args =
        let { Process_command.executable; args = client_args } = run_client_command in
        let connection_args =
          match (client_invocation : Client_invocation.t) with
          | Offline -> []
          | Connect_to { connection_config } ->
            Grpc_discovery.Connection_config.to_params connection_config
        in
        { Process_command.executable
        ; args = List.concat [ args; client_args; connection_args ]
        }
      ;;
    end
    in
    (module Config)
  ;;
end

let run_client ~env args =
  Eio.Switch.run
  @@ fun sw ->
  let child =
    Eio.Process.spawn
      ~sw
      (Eio.Stdenv.process_mgr env)
      ?cwd:None
      ?stdin:None
      ?stdout:None
      ?stderr:None
      ?env:None
      ?executable:None
      args
  in
  Eio.Buf_write.with_flow (Eio.Stdenv.stderr env) (fun stderr ->
    match Eio.Process.await child with
    | `Exited 0 -> ()
    | `Exited code -> Eio.Buf_write.printf stderr "[%d]\n" code
    | `Signaled int -> Eio.Buf_write.printf stderr "[Signaled %d]\n" int)
;;

type t =
  | T :
      { env :
          < fs : _ Eio.Path.t
          ; net : [> [ `Generic | `Unix ] Eio.Net.ty ] Eio.Resource.t
          ; process_mgr : _ Eio.Process.mgr
          ; stderr : _ Eio.Flow.sink
          ; clock : _ Eio.Time.clock
          ; .. >
      }
      -> t

let run ~env ~f =
  let t = T { env } in
  Exn.protect ~f:(fun () -> f t) ~finally:(fun () -> ())
;;

module Server = struct
  type nonrec t =
    { test : t
    ; config : Config.t
    ; connection_config : Grpc_discovery.Connection_config.t
    ; listening_on : Eio.Net.Sockaddr.stream
    }

  let listening_on t = t.listening_on

  let with_connection { test = T { env }; listening_on; _ } ~f =
    Grpc_client.with_connection ~env ~sockaddr:listening_on ~f:(fun connection ->
      f connection;
      Ok ())
    |> Or_error.ok_exn
  ;;
end

let run_client
  { Server.test = T { env }; config; listening_on = _; connection_config }
  ?(offline = false)
  args
  =
  let module C = (val config : Config.S) in
  run_client
    ~env
    (C.run_client_command
       ~client_invocation:(if offline then Offline else Connect_to { connection_config })
       ~args:(List.concat args)
     |> Config.Process_command.to_string_list)
;;

module With_server = struct
  type t =
    { server : Server.t
    ; client : ?offline:bool -> string list list -> unit
    }
end

module Sockaddr_kind = struct
  type t =
    | Unix_socket
    | Tcp_localhost
end

let with_server ?(sockaddr_kind = Sockaddr_kind.Unix_socket) (T { env } as t) ~config ~f =
  let module C = (val config : Config.S) in
  let temp_file = Stdlib.Filename.temp_file "eio_unix_socket_test" ".sock" in
  let temp_path = Eio.Path.(Eio.Stdenv.fs env / temp_file) in
  Eio.Path.unlink temp_path;
  let process_mgr = Eio.Stdenv.process_mgr env in
  Eio.Switch.run
  @@ fun sw ->
  let listening_config : Grpc_discovery.Listening_config.t =
    match sockaddr_kind with
    | Unix_socket ->
      { specification = Unix { path = Fpath.v temp_file }; discovery_file = None }
    | Tcp_localhost ->
      { specification = Tcp { port = `Chosen_by_OS }
      ; discovery_file = Some (Fpath.v temp_file)
      }
  in
  let server_process =
    Eio.Process.spawn
      ~sw
      process_mgr
      (C.run_server_command ~listening_config |> Config.Process_command.to_string_list)
  in
  (* Give the server a little time before it is ready to accept connections. *)
  Eio.Time.sleep (Eio.Stdenv.clock env) 0.5;
  let connection_config : Grpc_discovery.Connection_config.t =
    match listening_config.specification with
    | Unix { path } -> Unix { path }
    | Tcp { port = `Supplied port } -> Tcp { host = `Localhost; port }
    | Tcp { port = `Chosen_by_OS } ->
      (match listening_config.discovery_file with
       | None -> failwith "Tcp port chosen by OS but no discovery file"
       | Some discovery_file -> Discovery_file { path = discovery_file })
  in
  let listening_on =
    Grpc_discovery.Connection_config.sockaddr connection_config ~env |> Or_error.ok_exn
  in
  let server = { Server.test = t; config; connection_config; listening_on } in
  let client ?offline args = run_client server ?offline args in
  Exn.protect
    ~f:(fun () ->
      f { With_server.server; client };
      Eio.Process.signal server_process Stdlib.Sys.sigint;
      match Eio.Process.await server_process with
      | `Exited _ | `Signaled _ -> ())
    ~finally:(fun () ->
      match Eio.Path.kind ~follow:false temp_path with
      | `Socket | `Regular_file -> Eio.Path.unlink temp_path
      | _ -> ())
;;
