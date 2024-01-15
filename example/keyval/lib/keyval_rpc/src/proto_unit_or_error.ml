type t = unit Or_error.t [@@deriving compare, equal, hash, sexp_of]

module Proto = struct
  type t = Keyval_rpc_proto.Keyval.unit_or_error
end

let of_proto (proto : Keyval_rpc_proto.Keyval.unit_or_error) =
  match proto with
  | Unit -> Ok ()
  | Error error -> Or_error.error_string error.error
;;

let to_proto (t : t) : Keyval_rpc_proto.Keyval.unit_or_error =
  match t with
  | Ok () -> Unit
  | Error error -> Error { error = Error.to_string_hum error }
;;

let quickcheck_observer = Observer.of_hash_fold (Or_error.hash_fold_t Unit.hash_fold_t)
let quickcheck_shrinker = Shrinker.atomic

let quickcheck_generator =
  Generator.union
    [ Generator.map (Generator.return ()) ~f:(fun () -> Ok ())
    ; Generator.map quickcheck_generator_string ~f:(fun s -> Or_error.error_string s)
    ]
;;
