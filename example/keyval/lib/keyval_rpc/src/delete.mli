module Request : sig
  type t = Keyval.Key.t [@@deriving compare, equal, hash, sexp_of]
end

module Response : sig
  type t = unit Or_error.t [@@deriving compare, equal, hash, sexp_of]
end

val rpc : (Request.t, Response.t) Grpc_spec.unary
