(*********************************************************************************)
(*  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

type t =
  | Unix of { path : Fpath.t }
  | Tcp of
      { ipaddr : Eio.Net.Ipaddr.v4v6
      ; port : int
      }

let of_eio = function
  | `Unix path -> Unix { path = Fpath.v path }
  | `Tcp (ipaddr, port) -> Tcp { ipaddr; port }
;;

let to_eio = function
  | Unix { path } -> `Unix (path |> Fpath.to_string)
  | Tcp { ipaddr; port } -> `Tcp (ipaddr, port)
;;

let create = of_eio
let sockaddr = to_eio

module Serialized_format = struct
  module F = struct
    open Ppx_yojson_conv_lib.Yojson_conv.Primitives

    (* This format is used to serialize the sockaddr into the line of a file
       that is read during the service-discovery via file strategy. It is
       stable and should offer good backward compatibility. *)
    type t =
      | Unix of { path : string }
      | Tcp of
          { ipaddr : string
          ; port : int
          }
    [@@deriving yojson]
  end

  let to_f = function
    | Unix { path } -> F.Unix { path = Fpath.to_string path }
    | Tcp { ipaddr; port } -> F.Tcp { ipaddr :> string; port }
  ;;

  let of_f = function
    | F.Unix { path } -> Unix { path = Fpath.v path }
    | F.Tcp { ipaddr; port } -> Tcp { ipaddr = Eio.Net.Ipaddr.of_raw ipaddr; port }
  ;;

  let yojson_of_t t = F.yojson_of_t (to_f t)
  let of_yojson json = of_f (F.t_of_yojson json)
end

let load_t path =
  Eio.Path.load path |> Yojson.Safe.from_string |> Serialized_format.of_yojson
;;

let save_t t path =
  (* The rename step makes it hopefully more atomic. *)
  let tmp =
    let root, p = path in
    root, p ^ ".tmp"
  in
  Eio.Path.save
    ~create:(`Or_truncate 0o600)
    tmp
    (Yojson.Safe.to_string (Serialized_format.yojson_of_t t) ^ "\n");
  Eio.Path.rename tmp path
;;

let load path = path |> load_t |> sockaddr
let save path ~sockaddr = save_t (create sockaddr) path
