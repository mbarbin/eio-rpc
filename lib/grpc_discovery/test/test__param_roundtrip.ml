open! Grpc_discovery

module type Paramable = sig
  type t [@@deriving equal, sexp_of]

  val param : t Command.Param.t
  val to_params : t -> string list
end

let test_roundtrip (type a) ~(inputs : a list) (module P : Paramable with type t = a) =
  List.iter inputs ~f:(fun t ->
    let params = P.to_params t in
    let t' = Command.Param.parse P.param params |> Or_error.ok_exn in
    require_equal [%here] (module P) t t')
;;

let%expect_test "connection_config" =
  let inputs =
    Connection_config.
      [ Tcp { host = `Localhost; port = 1234 }
      ; Unix { path = Fpath.v "/tmp/foo" }
      ; Discovery_file { path = Fpath.v "/tmp/foo" }
      ]
  in
  test_roundtrip ~inputs (module Connection_config);
  [%expect {||}];
  ()
;;

let%expect_test "listening_config" =
  let inputs =
    Listening_config.
      [ { specification = Tcp { port = `Chosen_by_OS }; discovery_file = None }
      ; { specification = Tcp { port = `Supplied 1234 }; discovery_file = None }
      ; { specification = Unix { path = Fpath.v "/tmp/foo" }; discovery_file = None }
      ; { specification = Tcp { port = `Chosen_by_OS }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ; { specification = Tcp { port = `Supplied 1234 }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ; { specification = Unix { path = Fpath.v "/tmp/foo" }
        ; discovery_file = Some (Fpath.v "/tmp/foo")
        }
      ]
  in
  test_roundtrip ~inputs (module Listening_config);
  [%expect {||}];
  ()
;;
