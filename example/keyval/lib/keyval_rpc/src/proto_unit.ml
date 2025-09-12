(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t = unit [@@deriving compare, equal, hash, quickcheck, sexp_of]

module Proto = struct
  type t = Keyval_rpc_proto.Keyval.unit_
end

let of_proto () = ()
let to_proto () = ()
