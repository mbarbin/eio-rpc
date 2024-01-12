module Request : sig
  type t = unit [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = Set.M(Keyval.Key).t [@@deriving compare, equal, hash, sexp_of]
end

val rpc
  : ( Keyval_rpc_proto.Keyval.unit_
      , Request.t
      , Keyval_rpc_proto.Keyval.keys
      , Response.t )
      Grpc_spec.unary
