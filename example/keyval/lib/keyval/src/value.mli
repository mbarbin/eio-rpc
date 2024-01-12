type t [@@deriving compare, equal, hash, sexp_of]

val to_string : t -> string
val of_string : string -> t
