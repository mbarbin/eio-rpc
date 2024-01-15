module Request : sig
  type t = Keyval.Keyval_pair.t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

module Response : sig
  type t = unit [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

val rpc : (Request.t, Response.t) Grpc_spec.unary
