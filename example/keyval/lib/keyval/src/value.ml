(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

include struct
  [@@@coverage off]

  type t = string [@@deriving compare, equal, hash, quickcheck, sexp_of]
end

let to_string t = t
let of_string t = t
