type t

val create : unit -> t
val implement_rpcs : t -> Grpc_server.t
