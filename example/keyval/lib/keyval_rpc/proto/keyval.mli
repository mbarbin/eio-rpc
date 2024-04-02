(** Code for keyval.proto *)

(* generated from "keyval.proto", do not edit *)

(** {2 Types} *)

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

(** {2 Basic values} *)

(** [default_key ()] is the default value for type [key] *)
val default_key : ?key:string -> unit -> key

(** [default_keys ()] is the default value for type [keys] *)
val default_keys : ?keys:key list -> unit -> keys

(** [default_value ()] is the default value for type [value] *)
val default_value : ?value:string -> unit -> value

(** [default_error ()] is the default value for type [error] *)
val default_error : ?error:string -> unit -> error

(** [default_value_or_error ()] is the default value for type [value_or_error] *)
val default_value_or_error : unit -> value_or_error

(** [default_keyval_pair ()] is the default value for type [keyval_pair] *)
val default_keyval_pair : ?key:string -> ?value:string -> unit -> keyval_pair

(** [default_unit_ ()] is the default value for type [unit_] *)
val default_unit_ : unit

(** [default_unit_or_error ()] is the default value for type [unit_or_error] *)
val default_unit_or_error : ?error:string -> unit -> unit_or_error

(** {2 Protobuf Encoding} *)

(** [encode_pb_key v encoder] encodes [v] with the given [encoder] *)
val encode_pb_key : key -> Pbrt.Encoder.t -> unit

(** [encode_pb_keys v encoder] encodes [v] with the given [encoder] *)
val encode_pb_keys : keys -> Pbrt.Encoder.t -> unit

(** [encode_pb_value v encoder] encodes [v] with the given [encoder] *)
val encode_pb_value : value -> Pbrt.Encoder.t -> unit

(** [encode_pb_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_error : error -> Pbrt.Encoder.t -> unit

(** [encode_pb_value_or_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_value_or_error : value_or_error -> Pbrt.Encoder.t -> unit

(** [encode_pb_keyval_pair v encoder] encodes [v] with the given [encoder] *)
val encode_pb_keyval_pair : keyval_pair -> Pbrt.Encoder.t -> unit

(** [encode_pb_unit_ v encoder] encodes [v] with the given [encoder] *)
val encode_pb_unit_ : unit_ -> Pbrt.Encoder.t -> unit

(** [encode_pb_unit_or_error v encoder] encodes [v] with the given [encoder] *)
val encode_pb_unit_or_error : unit_or_error -> Pbrt.Encoder.t -> unit

(** {2 Protobuf Decoding} *)

(** [decode_pb_key decoder] decodes a [key] binary value from [decoder] *)
val decode_pb_key : Pbrt.Decoder.t -> key

(** [decode_pb_keys decoder] decodes a [keys] binary value from [decoder] *)
val decode_pb_keys : Pbrt.Decoder.t -> keys

(** [decode_pb_value decoder] decodes a [value] binary value from [decoder] *)
val decode_pb_value : Pbrt.Decoder.t -> value

(** [decode_pb_error decoder] decodes a [error] binary value from [decoder] *)
val decode_pb_error : Pbrt.Decoder.t -> error

(** [decode_pb_value_or_error decoder] decodes a [value_or_error] binary value from [decoder] *)
val decode_pb_value_or_error : Pbrt.Decoder.t -> value_or_error

(** [decode_pb_keyval_pair decoder] decodes a [keyval_pair] binary value from [decoder] *)
val decode_pb_keyval_pair : Pbrt.Decoder.t -> keyval_pair

(** [decode_pb_unit_ decoder] decodes a [unit_] binary value from [decoder] *)
val decode_pb_unit_ : Pbrt.Decoder.t -> unit_

(** [decode_pb_unit_or_error decoder] decodes a [unit_or_error] binary value from [decoder] *)
val decode_pb_unit_or_error : Pbrt.Decoder.t -> unit_or_error

(** {2 Protobuf YoJson Encoding} *)

(** [encode_json_key v encoder] encodes [v] to to json *)
val encode_json_key : key -> Yojson.Basic.t

(** [encode_json_keys v encoder] encodes [v] to to json *)
val encode_json_keys : keys -> Yojson.Basic.t

(** [encode_json_value v encoder] encodes [v] to to json *)
val encode_json_value : value -> Yojson.Basic.t

(** [encode_json_error v encoder] encodes [v] to to json *)
val encode_json_error : error -> Yojson.Basic.t

(** [encode_json_value_or_error v encoder] encodes [v] to to json *)
val encode_json_value_or_error : value_or_error -> Yojson.Basic.t

(** [encode_json_keyval_pair v encoder] encodes [v] to to json *)
val encode_json_keyval_pair : keyval_pair -> Yojson.Basic.t

(** [encode_json_unit_ v encoder] encodes [v] to to json *)
val encode_json_unit_ : unit_ -> Yojson.Basic.t

(** [encode_json_unit_or_error v encoder] encodes [v] to to json *)
val encode_json_unit_or_error : unit_or_error -> Yojson.Basic.t

(** {2 JSON Decoding} *)

(** [decode_json_key decoder] decodes a [key] value from [decoder] *)
val decode_json_key : Yojson.Basic.t -> key

(** [decode_json_keys decoder] decodes a [keys] value from [decoder] *)
val decode_json_keys : Yojson.Basic.t -> keys

(** [decode_json_value decoder] decodes a [value] value from [decoder] *)
val decode_json_value : Yojson.Basic.t -> value

(** [decode_json_error decoder] decodes a [error] value from [decoder] *)
val decode_json_error : Yojson.Basic.t -> error

(** [decode_json_value_or_error decoder] decodes a [value_or_error] value from [decoder] *)
val decode_json_value_or_error : Yojson.Basic.t -> value_or_error

(** [decode_json_keyval_pair decoder] decodes a [keyval_pair] value from [decoder] *)
val decode_json_keyval_pair : Yojson.Basic.t -> keyval_pair

(** [decode_json_unit_ decoder] decodes a [unit_] value from [decoder] *)
val decode_json_unit_ : Yojson.Basic.t -> unit_

(** [decode_json_unit_or_error decoder] decodes a [unit_or_error] value from [decoder] *)
val decode_json_unit_or_error : Yojson.Basic.t -> unit_or_error

(** {2 QuickCheck} *)

(** [quickcheck_key] contains helpers to test the type key with quickcheck *)
val quickcheck_key : key Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_key ?gen ()] builds a test suite for the type "key". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_key : ?gen:key QCheck2.Gen.t -> unit -> QCheck2.Test.t list

(** [quickcheck_keys] contains helpers to test the type keys with quickcheck *)
val quickcheck_keys : keys Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_keys ?gen ()] builds a test suite for the type "keys". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_keys : ?gen:keys QCheck2.Gen.t -> unit -> QCheck2.Test.t list

(** [quickcheck_value] contains helpers to test the type value with quickcheck *)
val quickcheck_value : value Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_value ?gen ()] builds a test suite for the type "value". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_value : ?gen:value QCheck2.Gen.t -> unit -> QCheck2.Test.t list

(** [quickcheck_error] contains helpers to test the type error with quickcheck *)
val quickcheck_error : error Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_error ?gen ()] builds a test suite for the type "error". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_error : ?gen:error QCheck2.Gen.t -> unit -> QCheck2.Test.t list

(** [quickcheck_value_or_error] contains helpers to test the type value_or_error with quickcheck *)
val quickcheck_value_or_error : value_or_error Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_value_or_error ?gen ()] builds a test suite for the type "value_or_error". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_value_or_error
  :  ?gen:value_or_error QCheck2.Gen.t
  -> unit
  -> QCheck2.Test.t list

(** [quickcheck_keyval_pair] contains helpers to test the type keyval_pair with quickcheck *)
val quickcheck_keyval_pair : keyval_pair Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_keyval_pair ?gen ()] builds a test suite for the type "keyval_pair". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_keyval_pair
  :  ?gen:keyval_pair QCheck2.Gen.t
  -> unit
  -> QCheck2.Test.t list

(** [quickcheck_unit_] contains helpers to test the type unit_ with quickcheck *)
val quickcheck_unit_ : unit_ Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_unit_ ?gen ()] builds a test suite for the type "unit_". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_unit_ : ?gen:unit_ QCheck2.Gen.t -> unit -> QCheck2.Test.t list

(** [quickcheck_unit_or_error] contains helpers to test the type unit_or_error with quickcheck *)
val quickcheck_unit_or_error : unit_or_error Pbrt_quickcheck.Type_class.t

(** [quickcheck_tests_unit_or_error ?gen ()] builds a test suite for the type "unit_or_error". Inputs are generated with QuickCheck. Use [gen] to override the generator. *)
val quickcheck_tests_unit_or_error
  :  ?gen:unit_or_error QCheck2.Gen.t
  -> unit
  -> QCheck2.Test.t list

(** [all_quickcheck_tests ()] builds a test suite which, by default, includes tests for all known types. Use [~include_test:false] to exclude a particular test. *)
val all_quickcheck_tests
  :  ?include_key:bool
  -> ?include_keys:bool
  -> ?include_value:bool
  -> ?include_error:bool
  -> ?include_value_or_error:bool
  -> ?include_keyval_pair:bool
  -> ?include_unit_:bool
  -> ?include_unit_or_error:bool
  -> unit
  -> QCheck2.Test.t list

(** {2 Services} *)

(** Keyval service *)
module Keyval : sig
  open Pbrt_services
  open Pbrt_services.Value_mode

  module Client : sig
    val get : (key, unary, value_or_error, unary) Client.rpc
    val set : (keyval_pair, unary, unit_, unary) Client.rpc
    val delete : (key, unary, unit_or_error, unary) Client.rpc
    val listKeys : (unit_, unary, keys, unary) Client.rpc
  end

  module Server : sig
    (** Produce a server implementation from handlers *)
    val make
      :  get:((key, unary, value_or_error, unary) Server.rpc -> 'handler)
      -> set:((keyval_pair, unary, unit_, unary) Server.rpc -> 'handler)
      -> delete:((key, unary, unit_or_error, unary) Server.rpc -> 'handler)
      -> listKeys:((unit_, unary, keys, unary) Server.rpc -> 'handler)
      -> unit
      -> 'handler Pbrt_services.Server.t

    (** The individual server stubs are only exposed for advanced users. Casual users should prefer accessing them through {!make}. *)

    val get : (key, unary, value_or_error, unary) Server.rpc
    val set : (keyval_pair, unary, unit_, unary) Server.rpc
    val delete : (key, unary, unit_or_error, unary) Server.rpc
    val listKeys : (unit_, unary, keys, unary) Server.rpc
  end
end
