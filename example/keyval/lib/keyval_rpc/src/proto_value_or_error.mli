type t = Keyval.Value.t Or_error.t [@@deriving compare, equal, hash, quickcheck, sexp_of]

module Proto : sig
  type t = Keyval_rpc_proto.Keyval.value_or_error
end

val of_proto : Proto.t -> t
val to_proto : t -> Proto.t
