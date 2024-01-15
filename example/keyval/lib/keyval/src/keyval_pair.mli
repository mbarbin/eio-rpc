type t =
  { key : Key.t
  ; value : Value.t
  }
[@@deriving compare, equal, hash, quickcheck, sexp_of]
