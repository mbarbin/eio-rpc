(** Encoding a sockaddr into a file.

    A discovery file is a file on the local file system that contains some json
    value encoding for a sockaddr. It is used as simple service discovery via
    file strategy for a client to discover dynamically where the server is
    listening. *)

(** Load and parse discovery file from disk. *)
val load : _ Eio.Path.t -> Eio.Net.Sockaddr.stream

(** Save discovery file to disk. The responsibility of mkdir the parent is left
    for the caller to handle. *)
val save : _ Eio.Path.t -> sockaddr:Eio.Net.Sockaddr.stream -> unit
