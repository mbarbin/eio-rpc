type t = unit [@@deriving compare, equal, hash, quickcheck, sexp_of]

module Proto : sig
  type t = Keyval_rpc_proto.Keyval.unit_
end

val of_proto : Proto.t -> t
val to_proto : t -> Proto.t
