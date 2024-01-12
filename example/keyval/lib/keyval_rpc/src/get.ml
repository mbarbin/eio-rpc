module Request = struct
  type t = Keyval.Key.t [@@deriving compare, equal, hash, sexp_of]

  module Proto = struct
    type t = Keyval_rpc_proto.Keyval.key
  end

  let of_proto ({ key } : Proto.t) : t = Keyval.Key.v key
  let to_proto key = { Keyval_rpc_proto.Keyval.key = Keyval.Key.to_string key }
end

module Response = Proto_value_or_error

let rpc =
  Grpc_spec.unary
    ~client_rpc:Keyval_rpc_proto.Keyval.Keyval.Client.get
    ~server_rpc:Keyval_rpc_proto.Keyval.Keyval.Server.rpc_get
    (module Request)
    (module Response)
;;
