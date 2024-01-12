module Request : sig
  type t = unit [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = Set.M(Keyval.Key).t [@@deriving compare, equal, hash, sexp_of]
end

val rpc : (Request.t, Response.t) Grpc_spec.unary
