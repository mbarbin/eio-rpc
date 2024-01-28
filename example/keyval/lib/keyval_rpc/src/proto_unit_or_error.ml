type t = unit Or_error.t [@@deriving compare, equal, hash, sexp_of]

module Proto = struct
  type t = Keyval_rpc_proto.Keyval.unit_or_error
end

let of_proto ({ error } : Keyval_rpc_proto.Keyval.unit_or_error) =
  if String.is_empty error
  then Ok ()
  else Error (Parsexp.Conv_single.parse_string_exn error Error.t_of_sexp)
;;

let to_proto (t : t) : Keyval_rpc_proto.Keyval.unit_or_error =
  match t with
  | Ok () -> Keyval_rpc_proto.Keyval.default_unit_or_error ()
  | Error error ->
    Keyval_rpc_proto.Keyval.default_unit_or_error ~error:(Error.to_string_mach error) ()
;;

let quickcheck_observer = Observer.of_hash_fold (Or_error.hash_fold_t Unit.hash_fold_t)
let quickcheck_shrinker = Shrinker.atomic

let quickcheck_generator =
  Generator.union
    [ Generator.map (Generator.return ()) ~f:(fun () -> Ok ())
    ; Generator.map quickcheck_generator_string ~f:(fun s -> Or_error.error_string s)
    ]
;;
