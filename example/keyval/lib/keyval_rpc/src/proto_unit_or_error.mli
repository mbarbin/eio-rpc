(*_********************************************************************************)
(*_  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t = unit Or_error.t [@@deriving compare, equal, hash, quickcheck, sexp_of]

module Proto : sig
  type t = Keyval_rpc_proto.Keyval.unit_or_error
end

val of_proto : Proto.t -> t
val to_proto : t -> Proto.t
