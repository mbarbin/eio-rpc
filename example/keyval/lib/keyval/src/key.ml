module T = struct
  type t = string [@@deriving compare, equal, hash, sexp_of]
end

include T
include Comparable.Make (T)

let invariant t =
  (not (String.is_empty t))
  && String.for_all t ~f:(fun c -> Char.is_alphanum c || Char.equal c '_')
;;

let to_string t = t

let of_string s =
  if invariant s then Ok s else Error (`Msg (Printf.sprintf "%S: invalid key" s))
;;

let v str =
  match str |> of_string with
  | Ok t -> t
  | Error (`Msg m) -> invalid_arg m
;;

let quickcheck_observer = quickcheck_observer_string
let quickcheck_shrinker = quickcheck_shrinker_string

let quickcheck_generator =
  Generator.filter
    (Generator.string_non_empty_of
       (Generator.union [ Generator.char_alphanum; Generator.return '_' ]))
    ~f:invariant
;;
