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

let quickcheck_shrinker = Shrinker.atomic
let quickcheck_observer = Observer.of_hash_fold hash_fold_t

let quickcheck_generator =
  let open Generator.Let_syntax in
  match%bind Proto_unit_or_error.quickcheck_generator with
  | Ok () -> Keyval.Value.quickcheck_generator >>| Or_error.return
  | Error _ as error -> return error
;;
