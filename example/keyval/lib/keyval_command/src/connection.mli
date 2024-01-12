(** This is the address used by the server to serve the RPCs. In a real case,
    this would be replaced by e.g. a service discovery mechanism. *)
val addr : Eio.Net.Sockaddr.stream
