type t [@@deriving compare, equal, hash, quickcheck, sexp_of]

val to_string : t -> string
val of_string : string -> t
