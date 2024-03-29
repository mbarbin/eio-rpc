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
  if invariant s
  then Ok s
  else Or_error.error_s [%sexp "Keyval.Key.of_string: invalid key", (s : string)]
;;

let v t = t |> of_string |> Or_error.ok_exn
let quickcheck_observer = quickcheck_observer_string
let quickcheck_shrinker = quickcheck_shrinker_string

let quickcheck_generator =
  Generator.filter
    (Generator.string_non_empty_of
       (Generator.union [ Generator.char_alphanum; Generator.return '_' ]))
    ~f:invariant
;;
