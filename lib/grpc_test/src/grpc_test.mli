(** A library to help writting tests for gRPC Eio applications.

    This is built with expect-tests in mind. See the keyval application in this
    repo for a complete example of use.

    The tests support both kind of sockaddr, unix sockets and tcp connections,
    in both cases to connect to a server running on the localhost where the
    expect tests are running.

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
    listen on the given port and write down that port to the file, as a plain
    integer. The client command is expected to read the port from the file, and
    use it to innitiate a connection to this port. *)

module Config : sig
  (** The config allows each app to implement the bits required by this library. *)

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

  type t

  val create : (module S) -> t

  (** If you use [Grpc_discovery] in your client and server command line, you
      then only need to supply the path to both commands. *)
  val grpc_discovery
    :  run_server_command:Process_command.t
    -> run_client_command:Process_command.t
    -> t
end

(** An environment for the test. *)
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

module Server : sig
  (** A server running that you can connect to during tests. *)
  type t

  val listening_on : t -> Eio.Net.Sockaddr.stream

  (** Initiates a connection to the running server so you can perform RPCs written
      in OCaml. *)
  val with_connection : t -> f:(Grpc_client.Connection.t -> unit) -> unit
end

module With_server : sig
  type t =
    { server : Server.t
    ; client : ?offline:bool -> string list list -> unit
    }
end

module Sockaddr_kind : sig
  type t =
    | Unix_socket
    | Tcp_localhost
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
