include struct
  [@@@coverage off]

  type t = string [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

let to_string t = t
let of_string t = t
