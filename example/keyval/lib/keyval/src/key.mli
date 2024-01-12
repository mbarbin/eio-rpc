type t [@@deriving compare, equal, hash, sexp_of]

include Comparable.S with type t := t

val to_string : t -> string
val of_string : string -> t Or_error.t
val v : string -> t
