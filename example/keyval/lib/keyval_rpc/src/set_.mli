(*_********************************************************************************)
(*_  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module Request : sig
  type t = Keyval.Keyval_pair.t [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

module Response : sig
  type t = unit [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

include Grpc_spec.Unary.S with module Request := Request and module Response := Response
