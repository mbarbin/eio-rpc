type t = Keyval.Value.t Or_error.t [@@deriving compare, equal, hash, sexp_of]

module Proto = struct
  type t = Keyval_rpc_proto.Keyval.value_or_error
end

let of_proto (proto : Keyval_rpc_proto.Keyval.value_or_error) =
  match proto with
  | Value { value } -> Ok (Keyval.Value.of_string value)
  | Error error -> Or_error.error_string error.error
;;

let to_proto (t : t) : Keyval_rpc_proto.Keyval.value_or_error =
  match t with
  | Ok value -> Value { value = Keyval.Value.to_string value }
  | Error error -> Error { error = Error.to_string_hum error }
;;
