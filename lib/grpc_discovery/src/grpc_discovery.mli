(** A simple service discovery via file. This supports both unix socket and tcp
    servers running on localhost. *)

module Discovery_file = Discovery_file

module Connection_config : sig
  (** The client side of the discovery answers the question: "Where is the
      service running?"

      The intended usage for this library is to add {!param} to you command line
      parameters, and resolve the {!t} using {!sockaddr} in the body of your
      client command. *)

  type t =
    | Tcp of
        { host : [ `Localhost | `Ipaddr of Eio.Net.Ipaddr.v4v6 ]
        ; port : int
        }
    | Unix of { path : Fpath.t }
    | Discovery_file of { path : Fpath.t }
  [@@deriving equal, sexp_of]

  val param : t Command.Param.t

  val sockaddr
    :  t
    -> env:< fs : [> Eio.Fs.dir_ty ] Eio.Path.t ; .. >
    -> Eio.Net.Sockaddr.stream Or_error.t

  (** Returns the arguments that a client command needs to be supplied to
      rebuild [t] via {!param}. This is used by tests and by
      {!val:Grpc_test.Config.grpc_discovery} to create the right invocations for
      clients whose cli uses {!param}. *)
  val to_params : t -> string list
end

module Listening_config : sig
  (** The server side of the discovery specifies where to serve, and how to
      advertize that information so clients can find you.

      The intended usage for this library is to add {!param} to you command line
      parameters, and resolve the {!t} using {!sockaddr} in the body of your
      server command. Also, you should call {!advertize} after starting to
      serve, to save the discovery information to a file that clients will load. *)

  module Specification : sig
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

  val param : t Command.Param.t
  val sockaddr : t -> Eio.Net.Sockaddr.stream

  (** To be run on the server after starting to listen for connections. If a
      discovery file is created it is attempted to be removed when the supplied
      switch is released. *)
  val advertize
    :  t
    -> env:< fs : [> Eio.Fs.dir_ty ] Eio.Path.t ; .. >
    -> sw:Eio.Switch.t
    -> listening_socket:[> 'tag Eio.Net.listening_socket_ty ] Eio.Resource.t
    -> unit

  (** Returns the arguments that a server needs to be supplied to rebuild [t]
      via {!param}. This is used by tests and by
      {!val:Grpc_test.Config.grpc_discovery} to create the right invocations
      for servers whose cli uses {!param}. *)
  val to_params : t -> string list
end
