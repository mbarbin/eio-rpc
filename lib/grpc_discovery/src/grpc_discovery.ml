module Discovery_file = Discovery_file

module Switch = struct
  let port = "port"
  let unix_socket = "unix-socket"
  let discovery_file = "discovery-file"
  let port_chosen_by_os = "port-chosen-by-os"
end

module Connection_config = struct
  module Ipaddr = struct
    type t = Eio.Net.Ipaddr.v4v6

    let to_string (t : t) = (t :> string)
    let equal t1 t2 = String.equal (to_string t1) (to_string t2)
    let sexp_of_t t = Sexp.Atom (to_string t)
  end

  type t =
    | Tcp of
        { host : [ `Localhost | `Ipaddr of Ipaddr.t ]
        ; port : int
        }
    | Unix of { path : Fpath.t }
    | Discovery_file of { path : Fpath.t }
  [@@deriving equal, sexp_of]

  let arg =
    let%map_open.Command by_port =
      Arg.named_opt
        [ Switch.port ]
        Param.int
        ~docv:"PORT"
        ~doc:"connect to localhost TCP port"
      >>| Option.map ~f:(fun port -> Tcp { host = `Localhost; port })
    and by_unix_socket =
      Arg.named_opt
        [ Switch.unix_socket ]
        (Param.validated_string (module Fpath))
        ~docv:"PATH"
        ~doc:"connect to unix socket"
      >>| Option.map ~f:(fun path -> Unix { path })
    and by_discovery_file =
      Arg.named_opt
        [ Switch.discovery_file ]
        (Param.validated_string (module Fpath))
        ~docv:"PATH"
        ~doc:"read sockaddr from discovery file"
      >>| Option.map ~f:(fun path -> Discovery_file { path })
    in
    match List.filter_opt [ by_port; by_unix_socket; by_discovery_file ] with
    | [ spec ] -> Or_error.return spec
    | [] -> Or_error.return (Tcp { host = `Localhost; port = 8080 })
    | _ :: _ :: _ ->
      Or_error.error_string
        "Only one of --port, --unix-socket, or --discovery-file can be used"
  ;;

  let to_args t =
    match t with
    | Tcp { host = `Ipaddr _; port = _ } -> failwith "Not implemented"
    | Tcp { host = `Localhost; port } -> [ "--" ^ Switch.port; Int.to_string port ]
    | Unix { path } -> [ "--" ^ Switch.unix_socket; Fpath.to_string path ]
    | Discovery_file { path } -> [ "--" ^ Switch.discovery_file; Fpath.to_string path ]
  ;;

  let sockaddr t ~env : Eio.Net.Sockaddr.stream Or_error.t =
    Or_error.try_with (fun () ->
      match t with
      | Tcp { host; port } ->
        let ipaddr =
          match host with
          | `Localhost -> Eio.Net.Ipaddr.V4.loopback
          | `Ipaddr ipaddr -> ipaddr
        in
        `Tcp (ipaddr, port)
      | Unix { path } -> `Unix (Fpath.to_string path)
      | Discovery_file { path } ->
        Discovery_file.load Eio.Path.(Eio.Stdenv.fs env / Fpath.to_string path))
  ;;
end

module Listening_config = struct
  module Specification = struct
    type t =
      | Tcp of { port : [ `Chosen_by_OS | `Supplied of int ] }
      | Unix of { path : Fpath.t }
    [@@deriving equal, sexp_of]
  end

  type t =
    { specification : Specification.t
    ; discovery_file : Fpath.t option
    }
  [@@deriving equal, sexp_of]

  let arg =
    let open Command.Let_syntax in
    let%map_open.Command specification =
      let%map by_os =
        if%map
          Arg.flag
            [ Switch.port_chosen_by_os ]
            ~doc:"listen on localhost TCP port chosen by OS (default)"
        then Some (Specification.Tcp { port = `Chosen_by_OS })
        else None
      and by_port =
        Arg.named_opt
          [ Switch.port ]
          Param.int
          ~docv:"PORT"
          ~doc:"listen on localhost TCP port"
        >>| Option.map ~f:(fun port -> Specification.Tcp { port = `Supplied port })
      and by_socket =
        Arg.named_opt
          [ Switch.unix_socket ]
          (Param.validated_string (module Fpath))
          ~docv:"PATH"
          ~doc:"listen on unix socket"
        >>| Option.map ~f:(fun path -> Specification.Unix { path })
      in
      match List.filter_opt [ by_os; by_port; by_socket ] with
      | [ spec ] -> Or_error.return spec
      | [] -> Or_error.return (Specification.Tcp { port = `Chosen_by_OS })
      | _ :: _ :: _ ->
        Or_error.error_string
          "Only one of --port, --unix-socket, or --port-chosen-by-os can be used"
    and discovery_file =
      Arg.named_opt
        [ Switch.discovery_file ]
        (Param.validated_string (module Fpath))
        ~docv:"PATH"
        ~doc:"save sockaddr to discovery file"
    in
    let%map.Or_error specification = specification in
    { specification; discovery_file }
  ;;

  let to_args t =
    let specification =
      match t.specification with
      | Tcp { port = `Chosen_by_OS } -> [ "--" ^ Switch.port_chosen_by_os ]
      | Tcp { port = `Supplied port } -> [ "--" ^ Switch.port; Int.to_string port ]
      | Unix { path } -> [ "--" ^ Switch.unix_socket; Fpath.to_string path ]
    in
    let discovery_file =
      match t.discovery_file with
      | None -> []
      | Some path -> [ "--" ^ Switch.discovery_file; Fpath.to_string path ]
    in
    List.concat [ specification; discovery_file ]
  ;;

  let sockaddr { specification; discovery_file = _ } : Eio.Net.Sockaddr.stream =
    match specification with
    | Tcp { port } ->
      `Tcp
        ( Eio.Net.Ipaddr.V4.loopback
        , match port with
          | `Supplied port -> port
          | `Chosen_by_OS -> 0 )
    | Unix { path } -> `Unix (Fpath.to_string path)
  ;;

  let advertize t ~env ~sw ~listening_socket =
    match t.discovery_file with
    | None -> ()
    | Some path ->
      let sockaddr = Eio.Net.listening_addr listening_socket in
      let discovery_path = Eio.Path.(Eio.Stdenv.fs env / Fpath.to_string path) in
      Discovery_file.save discovery_path ~sockaddr;
      Eio.Switch.on_release sw (fun () -> Eio.Path.unlink discovery_path)
  ;;
end
