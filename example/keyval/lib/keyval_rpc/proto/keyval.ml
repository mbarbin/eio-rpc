[@@@ocaml.warning "-27-30-39-44"]

type key = { key : string } [@@deriving show { with_path = false }, eq]
type keys = { keys : key list } [@@deriving show { with_path = false }, eq]
type value = { value : string } [@@deriving show { with_path = false }, eq]
type error = { error : string } [@@deriving show { with_path = false }, eq]

type value_or_error =
  | Value of value
  | Error of error
[@@deriving show { with_path = false }, eq]

type keyval_pair =
  { key : string
  ; value : string
  }
[@@deriving show { with_path = false }, eq]

type unit_ = unit [@@deriving show { with_path = false }, eq]
type unit_or_error = { error : string } [@@deriving show { with_path = false }, eq]

let rec default_key ?(key : string = "") () : key = { key }
let rec default_keys ?(keys : key list = []) () : keys = { keys }
let rec default_value ?(value : string = "") () : value = { value }
let rec default_error ?(error : string = "") () : error = { error }
let rec default_value_or_error () : value_or_error = Value (default_value ())

let rec default_keyval_pair ?(key : string = "") ?(value : string = "") () : keyval_pair =
  { key; value }
;;

let rec default_unit_ = ()
let rec default_unit_or_error ?(error : string = "") () : unit_or_error = { error }

type key_mutable = { mutable key : string }

let default_key_mutable () : key_mutable = { key = "" }

type keys_mutable = { mutable keys : key list }

let default_keys_mutable () : keys_mutable = { keys = [] }

type value_mutable = { mutable value : string }

let default_value_mutable () : value_mutable = { value = "" }

type error_mutable = { mutable error : string }

let default_error_mutable () : error_mutable = { error = "" }

type keyval_pair_mutable =
  { mutable key : string
  ; mutable value : string
  }

let default_keyval_pair_mutable () : keyval_pair_mutable = { key = ""; value = "" }

type unit_or_error_mutable = { mutable error : string }

let default_unit_or_error_mutable () : unit_or_error_mutable = { error = "" }

[@@@ocaml.warning "-27-30-39"]

(** {2 Protobuf Encoding} *)

let rec encode_pb_key (v : key) encoder =
  Pbrt.Encoder.string v.key encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder;
  ()
;;

let rec encode_pb_keys (v : keys) encoder =
  Pbrt.List_util.rev_iter_with
    (fun x encoder ->
      Pbrt.Encoder.nested encode_pb_key x encoder;
      Pbrt.Encoder.key 1 Pbrt.Bytes encoder)
    v.keys
    encoder;
  ()
;;

let rec encode_pb_value (v : value) encoder =
  Pbrt.Encoder.string v.value encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder;
  ()
;;

let rec encode_pb_error (v : error) encoder =
  Pbrt.Encoder.string v.error encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder;
  ()
;;

let rec encode_pb_value_or_error (v : value_or_error) encoder =
  match v with
  | Value x ->
    Pbrt.Encoder.nested encode_pb_value x encoder;
    Pbrt.Encoder.key 1 Pbrt.Bytes encoder
  | Error x ->
    Pbrt.Encoder.nested encode_pb_error x encoder;
    Pbrt.Encoder.key 2 Pbrt.Bytes encoder
;;

let rec encode_pb_keyval_pair (v : keyval_pair) encoder =
  Pbrt.Encoder.string v.key encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder;
  Pbrt.Encoder.string v.value encoder;
  Pbrt.Encoder.key 2 Pbrt.Bytes encoder;
  ()
;;

let rec encode_pb_unit_ (v : unit_) encoder = ()

let rec encode_pb_unit_or_error (v : unit_or_error) encoder =
  Pbrt.Encoder.string v.error encoder;
  Pbrt.Encoder.key 1 Pbrt.Bytes encoder;
  ()
;;

[@@@ocaml.warning "-27-30-39"]

(** {2 Protobuf Decoding} *)

let rec decode_pb_key d =
  let v = default_key_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      ();
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.key <- Pbrt.Decoder.string d
    | Some (1, pk) -> Pbrt.Decoder.unexpected_payload "Message(key), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ key = v.key } : key)
;;

let rec decode_pb_keys d =
  let v = default_keys_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      v.keys <- List.rev v.keys;
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.keys <- decode_pb_key (Pbrt.Decoder.nested d) :: v.keys
    | Some (1, pk) -> Pbrt.Decoder.unexpected_payload "Message(keys), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ keys = v.keys } : keys)
;;

let rec decode_pb_value d =
  let v = default_value_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      ();
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.value <- Pbrt.Decoder.string d
    | Some (1, pk) -> Pbrt.Decoder.unexpected_payload "Message(value), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ value = v.value } : value)
;;

let rec decode_pb_error d =
  let v = default_error_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      ();
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.error <- Pbrt.Decoder.string d
    | Some (1, pk) -> Pbrt.Decoder.unexpected_payload "Message(error), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ error = v.error } : error)
;;

let rec decode_pb_value_or_error d =
  let rec loop () =
    let ret : value_or_error =
      match Pbrt.Decoder.key d with
      | None -> Pbrt.Decoder.malformed_variant "value_or_error"
      | Some (1, _) -> (Value (decode_pb_value (Pbrt.Decoder.nested d)) : value_or_error)
      | Some (2, _) -> (Error (decode_pb_error (Pbrt.Decoder.nested d)) : value_or_error)
      | Some (n, payload_kind) ->
        Pbrt.Decoder.skip d payload_kind;
        loop ()
    in
    ret
  in
  loop ()
;;

let rec decode_pb_keyval_pair d =
  let v = default_keyval_pair_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      ();
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.key <- Pbrt.Decoder.string d
    | Some (1, pk) -> Pbrt.Decoder.unexpected_payload "Message(keyval_pair), field(1)" pk
    | Some (2, Pbrt.Bytes) -> v.value <- Pbrt.Decoder.string d
    | Some (2, pk) -> Pbrt.Decoder.unexpected_payload "Message(keyval_pair), field(2)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ key = v.key; value = v.value } : keyval_pair)
;;

let rec decode_pb_unit_ d =
  match Pbrt.Decoder.key d with
  | None -> ()
  | Some (_, pk) ->
    Pbrt.Decoder.unexpected_payload "Unexpected fields in empty message(unit_)" pk
;;

let rec decode_pb_unit_or_error d =
  let v = default_unit_or_error_mutable () in
  let continue__ = ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None ->
      ();
      continue__ := false
    | Some (1, Pbrt.Bytes) -> v.error <- Pbrt.Decoder.string d
    | Some (1, pk) ->
      Pbrt.Decoder.unexpected_payload "Message(unit_or_error), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({ error = v.error } : unit_or_error)
;;

[@@@ocaml.warning "-27-30-39"]

(** {2 Protobuf YoJson Encoding} *)

let rec encode_json_key (v : key) =
  let assoc = [] in
  let assoc = ("key", Pbrt_yojson.make_string v.key) :: assoc in
  `Assoc assoc
;;

let rec encode_json_keys (v : keys) =
  let assoc = [] in
  let assoc =
    let l = v.keys |> List.map encode_json_key in
    ("keys", `List l) :: assoc
  in
  `Assoc assoc
;;

let rec encode_json_value (v : value) =
  let assoc = [] in
  let assoc = ("value", Pbrt_yojson.make_string v.value) :: assoc in
  `Assoc assoc
;;

let rec encode_json_error (v : error) =
  let assoc = [] in
  let assoc = ("error", Pbrt_yojson.make_string v.error) :: assoc in
  `Assoc assoc
;;

let rec encode_json_value_or_error (v : value_or_error) =
  match v with
  | Value v -> `Assoc [ "value", encode_json_value v ]
  | Error v -> `Assoc [ "error", encode_json_error v ]
;;

let rec encode_json_keyval_pair (v : keyval_pair) =
  let assoc = [] in
  let assoc = ("key", Pbrt_yojson.make_string v.key) :: assoc in
  let assoc = ("value", Pbrt_yojson.make_string v.value) :: assoc in
  `Assoc assoc
;;

let rec encode_json_unit_ (v : unit_) = Pbrt_yojson.make_unit v

let rec encode_json_unit_or_error (v : unit_or_error) =
  let assoc = [] in
  let assoc = ("error", Pbrt_yojson.make_string v.error) :: assoc in
  `Assoc assoc
;;

[@@@ocaml.warning "-27-30-39"]

(** {2 JSON Decoding} *)

let rec decode_json_key d =
  let v = default_key_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "key", json_value -> v.key <- Pbrt_yojson.string json_value "key" "key"
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ key = v.key } : key)
;;

let rec decode_json_keys d =
  let v = default_keys_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "keys", `List l ->
        v.keys
        <- List.map
             (function
               | json_value -> decode_json_key json_value)
             l
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ keys = v.keys } : keys)
;;

let rec decode_json_value d =
  let v = default_value_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "value", json_value -> v.value <- Pbrt_yojson.string json_value "value" "value"
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ value = v.value } : value)
;;

let rec decode_json_error d =
  let v = default_error_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "error", json_value -> v.error <- Pbrt_yojson.string json_value "error" "error"
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ error = v.error } : error)
;;

let rec decode_json_value_or_error json =
  let assoc =
    match json with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  let rec loop = function
    | [] -> Pbrt_yojson.E.malformed_variant "value_or_error"
    | ("value", json_value) :: _ ->
      (Value (decode_json_value json_value) : value_or_error)
    | ("error", json_value) :: _ ->
      (Error (decode_json_error json_value) : value_or_error)
    | _ :: tl -> loop tl
  in
  loop assoc
;;

let rec decode_json_keyval_pair d =
  let v = default_keyval_pair_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "key", json_value -> v.key <- Pbrt_yojson.string json_value "keyval_pair" "key"
      | "value", json_value ->
        v.value <- Pbrt_yojson.string json_value "keyval_pair" "value"
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ key = v.key; value = v.value } : keyval_pair)
;;

let rec decode_json_unit_ d = Pbrt_yojson.unit d "unit_" "empty record"

let rec decode_json_unit_or_error d =
  let v = default_unit_or_error_mutable () in
  let assoc =
    match d with
    | `Assoc assoc -> assoc
    | _ -> assert false
  in
  List.iter
    (function
      | "error", json_value ->
        v.error <- Pbrt_yojson.string json_value "unit_or_error" "error"
      | _, _ -> () (*Unknown fields are ignored*))
    assoc;
  ({ error = v.error } : unit_or_error)
;;

module Keyval = struct
  open Pbrt_services.Value_mode

  module Client = struct
    open Pbrt_services

    let get : (key, unary, value_or_error, unary) Client.rpc =
      (Client.mk_rpc
         ~package:[ "keyval" ]
         ~service_name:"Keyval"
         ~rpc_name:"Get"
         ~req_mode:Client.Unary
         ~res_mode:Client.Unary
         ~encode_json_req:encode_json_key
         ~encode_pb_req:encode_pb_key
         ~decode_json_res:decode_json_value_or_error
         ~decode_pb_res:decode_pb_value_or_error
         ()
       : (key, unary, value_or_error, unary) Client.rpc)
    ;;

    open Pbrt_services

    let set : (keyval_pair, unary, unit_, unary) Client.rpc =
      (Client.mk_rpc
         ~package:[ "keyval" ]
         ~service_name:"Keyval"
         ~rpc_name:"Set"
         ~req_mode:Client.Unary
         ~res_mode:Client.Unary
         ~encode_json_req:encode_json_keyval_pair
         ~encode_pb_req:encode_pb_keyval_pair
         ~decode_json_res:decode_json_unit_
         ~decode_pb_res:decode_pb_unit_
         ()
       : (keyval_pair, unary, unit_, unary) Client.rpc)
    ;;

    open Pbrt_services

    let delete : (key, unary, unit_or_error, unary) Client.rpc =
      (Client.mk_rpc
         ~package:[ "keyval" ]
         ~service_name:"Keyval"
         ~rpc_name:"Delete"
         ~req_mode:Client.Unary
         ~res_mode:Client.Unary
         ~encode_json_req:encode_json_key
         ~encode_pb_req:encode_pb_key
         ~decode_json_res:decode_json_unit_or_error
         ~decode_pb_res:decode_pb_unit_or_error
         ()
       : (key, unary, unit_or_error, unary) Client.rpc)
    ;;

    open Pbrt_services

    let listKeys : (unit_, unary, keys, unary) Client.rpc =
      (Client.mk_rpc
         ~package:[ "keyval" ]
         ~service_name:"Keyval"
         ~rpc_name:"ListKeys"
         ~req_mode:Client.Unary
         ~res_mode:Client.Unary
         ~encode_json_req:encode_json_unit_
         ~encode_pb_req:encode_pb_unit_
         ~decode_json_res:decode_json_keys
         ~decode_pb_res:decode_pb_keys
         ()
       : (unit_, unary, keys, unary) Client.rpc)
    ;;
  end

  module Server = struct
    open Pbrt_services

    let get : (key, unary, value_or_error, unary) Server.rpc =
      (Server.mk_rpc
         ~name:"Get"
         ~req_mode:Server.Unary
         ~res_mode:Server.Unary
         ~encode_json_res:encode_json_value_or_error
         ~encode_pb_res:encode_pb_value_or_error
         ~decode_json_req:decode_json_key
         ~decode_pb_req:decode_pb_key
         ()
       : _ Server.rpc)
    ;;

    let set : (keyval_pair, unary, unit_, unary) Server.rpc =
      (Server.mk_rpc
         ~name:"Set"
         ~req_mode:Server.Unary
         ~res_mode:Server.Unary
         ~encode_json_res:encode_json_unit_
         ~encode_pb_res:encode_pb_unit_
         ~decode_json_req:decode_json_keyval_pair
         ~decode_pb_req:decode_pb_keyval_pair
         ()
       : _ Server.rpc)
    ;;

    let delete : (key, unary, unit_or_error, unary) Server.rpc =
      (Server.mk_rpc
         ~name:"Delete"
         ~req_mode:Server.Unary
         ~res_mode:Server.Unary
         ~encode_json_res:encode_json_unit_or_error
         ~encode_pb_res:encode_pb_unit_or_error
         ~decode_json_req:decode_json_key
         ~decode_pb_req:decode_pb_key
         ()
       : _ Server.rpc)
    ;;

    let listKeys : (unit_, unary, keys, unary) Server.rpc =
      (Server.mk_rpc
         ~name:"ListKeys"
         ~req_mode:Server.Unary
         ~res_mode:Server.Unary
         ~encode_json_res:encode_json_keys
         ~encode_pb_res:encode_pb_keys
         ~decode_json_req:decode_json_unit_
         ~decode_pb_req:decode_pb_unit_
         ()
       : _ Server.rpc)
    ;;

    let make
      ~get:__handler__get
      ~set:__handler__set
      ~delete:__handler__delete
      ~listKeys:__handler__listKeys
      ()
      : _ Server.t
      =
      { Server.service_name = "Keyval"
      ; package = [ "keyval" ]
      ; handlers =
          [ __handler__get get
          ; __handler__set set
          ; __handler__delete delete
          ; __handler__listKeys listKeys
          ]
      }
    ;;
  end
end
