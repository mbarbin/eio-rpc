module Request : sig
  type t = Keyval.Keyval_pair.t [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = unit [@@deriving compare, equal, hash, sexp_of]
end

val rpc
  : ( Keyval_rpc_proto.Keyval.keyval_pair
      , Request.t
      , Keyval_rpc_proto.Keyval.unit_
      , Response.t )
      Grpc_spec.unary
