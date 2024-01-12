type t = unit Or_error.t [@@deriving compare, equal, hash, sexp_of]

module Proto : sig
  type t = Keyval_rpc_proto.Keyval.unit_or_error
end

val of_proto : Proto.t -> t
val to_proto : t -> Proto.t
