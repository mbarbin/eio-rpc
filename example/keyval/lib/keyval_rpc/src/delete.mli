module Request : sig
  type t = Keyval.Key.t [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = unit Or_error.t [@@deriving compare, equal, hash, sexp_of]
end

val rpc
  : ( Keyval_rpc_proto.Keyval.key
      , Request.t
      , Keyval_rpc_proto.Keyval.unit_or_error
      , Response.t )
      Grpc_spec.unary
