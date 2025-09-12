(*_********************************************************************************)
(*_  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

type t [@@deriving compare, equal, hash, quickcheck, sexp_of]

include Comparable.S with type t := t

val to_string : t -> string
val of_string : string -> (t, [ `Msg of string ]) Result.t
val v : string -> t
