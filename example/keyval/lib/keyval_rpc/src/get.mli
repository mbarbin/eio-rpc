module Request : sig
  type t = Keyval.Key.t [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = Keyval.Value.t Or_error.t [@@deriving compare, equal, hash, sexp_of]
end

val rpc
  : ( Keyval_rpc_proto.Keyval.key
      , Request.t
      , Keyval_rpc_proto.Keyval.value_or_error
      , Response.t )
      Grpc_spec.unary
