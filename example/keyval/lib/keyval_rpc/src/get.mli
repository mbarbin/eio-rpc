module Request : sig
  type t = Keyval.Key.t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

module Response : sig
  type t = Keyval.Value.t Or_error.t
  [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

include Grpc_spec.Unary.S with module Request := Request and module Response := Response
