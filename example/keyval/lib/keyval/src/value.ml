type t = string [@@deriving compare, equal, hash, quickcheck, sexp_of]

let to_string t = t
let of_string t = t
