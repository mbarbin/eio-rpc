(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Request = struct
  type t = Keyval.Keyval_pair.t [@@deriving compare, equal, hash, quickcheck, sexp_of]

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

include
  Grpc_spec.Unary.Make (Request) (Response)
    (struct
      let client_rpc = Keyval_rpc_proto.Keyval.Keyval.Client.set
      let server_rpc = Keyval_rpc_proto.Keyval.Keyval.Server.set
    end)
