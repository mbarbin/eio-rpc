(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Request = Proto_unit

module Response = struct
  type t = Set.M(Keyval.Key).t [@@deriving compare, equal, hash, sexp_of]

  let quickcheck_generator =
    Generator.set_t_m (module Keyval.Key) Keyval.Key.quickcheck_generator
  ;;

  let quickcheck_observer = Observer.set_t Keyval.Key.quickcheck_observer
  let quickcheck_shrinker = Shrinker.set_t Keyval.Key.quickcheck_shrinker

  module Proto = struct
    type t = Keyval_rpc_proto.Keyval.keys
  end

  let of_proto ({ keys } : Proto.t) : t =
    keys
    |> List.map ~f:(fun ({ key } : Keyval_rpc_proto.Keyval.key) -> Keyval.Key.v key)
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

include
  Grpc_spec.Unary.Make (Request) (Response)
    (struct
      let client_rpc = Keyval_rpc_proto.Keyval.Keyval.Client.listKeys
      let server_rpc = Keyval_rpc_proto.Keyval.Keyval.Server.listKeys
    end)
