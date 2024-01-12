type t = unit [@@deriving compare, equal, hash, sexp_of]

module Proto = struct
  type t = Keyval_rpc_proto.Keyval.unit_
end

let of_proto () = ()
let to_proto () = ()
