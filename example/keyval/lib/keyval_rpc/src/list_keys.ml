module Request = Proto_unit

module Response = struct
  type t = Set.M(Keyval.Key).t [@@deriving compare, equal, hash, sexp_of]

  module Proto = struct
    type t = Keyval_rpc_proto.Keyval.keys
  end

  let of_proto ({ keys } : Proto.t) : t =
    keys
    |> List.map ~f:(fun { key } -> Keyval.Key.v key)
    |> Set.of_list (module Keyval.Key)
  ;;

  let to_proto keys : Proto.t =
    let keys =
      keys
      |> Set.to_list
      |> List.map ~f:(fun key ->
        { Keyval_rpc_proto.Keyval.key = Keyval.Key.to_string key })
    in
    { keys }
  ;;
end

let rpc =
  Grpc_spec.unary
    ~client_rpc:Keyval_rpc_proto.Keyval.Keyval.Client.listKeys
    ~server_rpc:Keyval_rpc_proto.Keyval.Keyval.Server.listKeys
    (module Request)
    (module Response)
;;
