module Request = struct
  type t = Keyval.Keyval_pair.t [@@deriving compare, equal, hash, sexp_of]

  module Proto = struct
    type t = Keyval_rpc_proto.Keyval.keyval_pair
  end

  let of_proto ({ key; value } : Proto.t) : t =
    { Keyval.Keyval_pair.key = Keyval.Key.v key; value = Keyval.Value.of_string value }
  ;;

  let to_proto { Keyval.Keyval_pair.key; value } =
    { Keyval_rpc_proto.Keyval.key = Keyval.Key.to_string key
    ; value = Keyval.Value.to_string value
    }
  ;;
end

module Response = Proto_unit

let rpc =
  Grpc_spec.unary
    Keyval_rpc_proto.Keyval.Keyval.Client.set
    (module Request)
    (module Response)
;;
