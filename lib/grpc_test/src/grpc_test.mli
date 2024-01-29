(** A library to help writting tests for gRPC Eio applications.

    This is built with expect-tests in mind. See the keyval application in this
    repo for a complete example of use.

    {1 Testing environment}

    To use the rest of this API, you need to introduce a new test environment to
    the scope. This is done via the {!run} function. This function will run the
    given function [f] with a fresh environment of type {!t}, and clean up the
    environment at the end. *)

type t

val run
  :  env:
       < fs : _ Eio.Path.t
       ; net : [> [ `Generic | `Unix ] Eio.Net.ty ] Eio.Resource.t
       ; process_mgr : _ Eio.Process.mgr
       ; stderr : _ Eio.Flow.sink
       ; clock : _ Eio.Time.clock
       ; .. >
  -> f:(t -> unit)
  -> unit

(** {1 Socket kinds}

    The tests support both kind of sockaddr, unix sockets and tcp connections,
    in both cases to connect to a server running on the localhost where the
    expect tests are running. *)

module Sockaddr_kind : sig
  (** Choosing the kind of sockaddr to use.

      Here is what happens in each mode:

      {2 Unix_socket}

      The library creates a temporary file in the file system, and supplies
      parameters to the server and client command pointing to it, to use it as a
      unix socket.

      {2 Tcp_localhost}

      The library creates a temporary file in the file system, and supplies
      parameters to the server and client command pointing to it. This temporary
      file will serve as a basic service discover via file:

      The server command is expected to let the OS choose an available port,
      listen on the given port and write down that port to the file into a
      parsable json format. The client command is expected to read the port from
      the file, and use it to innitiate a connection to this port. The format in
      used is defined by {!module:Grpc_discovery.Discovery_file}. *)

  type t =
    | Unix_socket
    | Tcp_localhost
end

(** {1 Config} *)

module Config : sig
  (** A configuration is required by the library to know how to run your server
      and client commands.

      The library provides a default configuration that should work for most
      simple cases. To use it, you have to make sure your server and client
      commands accept command line parameters specified by the {!module:Grpc_discovery}
      library. Then you can use the {!grpc_discovery} function to get a
      configuration that will work. For more advanced uses, see
      {!section-"advanced-api"}. *)

  type t

  module Process_command : sig
    (** This type is used to represent a command that the library must run to
        start the servers and clients processes. [executable] must be the path to
        the executable to run, searching $PATH for it if necessary.

        Do not forget to list the executable as a test dependency in your [dune]
        file. For example, if you executable is "m_app", you should have something
        like this in your dune file:

        {v
          (library
            (name my_app_test)
            (inline_tests (deps %{bin:my_app}))
          ...)
        v} *)
    type t =
      { executable : string
      ; args : string list
      }
  end

  (** If you use [Grpc_discovery] in your client and server command line, you
      then only need to supply the path to both commands. *)
  val grpc_discovery
    :  run_server_command:Process_command.t
    -> run_client_command:Process_command.t
    -> t

  (** {1:advanced-api Advanced API} *)

  module Client_invocation : sig
    (** In the tests, sometimes we run client commands that needs to connect to
        the server, and sometimes we run client commands that do not, and only
        perform other kinds of actions. This type is used to distinguish
        between these cases. *)
    type t =
      | Connect_to of { connection_config : Grpc_discovery.Connection_config.t }
      | Offline
  end

  module type S = sig
    (** This should return a valid command line to run a server that listens to
        the sockaddr as specified. *)
    val run_server_command
      :  listening_config:Grpc_discovery.Listening_config.t
      -> Process_command.t

    (** Once the server is running, this library will allow running client
        commands given some arguments. This function specifies the complete
        command to run. In particular it should add any required parameters
        in order for the command to connect to the server as specified. *)
    val run_client_command
      :  client_invocation:Client_invocation.t
      -> args:string list
      -> Process_command.t
  end

  val create : (module S) -> t
end

(** {1 Server}

    The rest of the API is used to run one or several server(s) and connect to
    it, either by running your app's cli, or in OCaml directly via
    {!Server.with_connection}. *)

module Server : sig
  (** A server running that you can connect to during tests. *)
  type t

  val listening_on : t -> Eio.Net.Sockaddr.stream

  (** Initiates a connection to the running server so you can perform RPCs written
      in OCaml. *)
  val with_connection : t -> f:(Grpc_client.Connection.t -> unit) -> unit
end

module With_server : sig
  (** This is what is introduced to the scope with the {!with_server} function. *)
  type t =
    { server : Server.t
    ; client : ?offline:bool -> string list list -> unit
    (** [client ?offline args] is a convenient wrapper for {!run_client},
        applied to the given server, and directly introduced to the scope. *)
    }
end

(** Takes care of starting a server, running [f] and stopping the server at the
    end. [sockaddr_kind] defaults to [Unix_socket]. *)
val with_server
  :  ?sockaddr_kind:Sockaddr_kind.t
  -> t
  -> config:Config.t
  -> f:(With_server.t -> unit)
  -> unit

(** [run_client server ?offline args] runs a client process that will connect to
    the given server. [offline:true] should be used for commands that do not
    connect to the server, and defaults to [false]. The [args] are flatten
    before the actual invocation, the grouping is only useful to make the
    code more readable (e.g. you can group together a flag with it's
    required argument, etc.). *)
val run_client : Server.t -> ?offline:bool -> string list list -> unit
