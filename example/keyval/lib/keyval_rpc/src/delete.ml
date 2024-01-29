module Request = struct
  type t = Keyval.Key.t [@@deriving compare, equal, hash, quickcheck, sexp_of]

  module Proto = struct
    type t = Keyval_rpc_proto.Keyval.key
  end

  let of_proto ({ key } : Proto.t) : t = Keyval.Key.v key
  let to_proto key = { Keyval_rpc_proto.Keyval.key = Keyval.Key.to_string key }
end

module Response = Proto_unit_or_error

include
  Grpc_spec.Unary.Make (Request) (Response)
    (struct
      let client_rpc = Keyval_rpc_proto.Keyval.Keyval.Client.delete
      let server_rpc = Keyval_rpc_proto.Keyval.Keyval.Server.delete
    end)
