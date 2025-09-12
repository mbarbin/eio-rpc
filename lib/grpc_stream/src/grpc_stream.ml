(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type 'a t = 'a Grpc_eio.Seq.t

let iter t ~f = Grpc_eio.Seq.iter f t

module Writer = struct
  type 'a t = 'a Grpc_eio.Seq.writer

  let write = Grpc_eio.Seq.write
  let close = Grpc_eio.Seq.close_writer
end
