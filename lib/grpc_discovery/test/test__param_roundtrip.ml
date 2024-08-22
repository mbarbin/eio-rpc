open! Grpc_discovery
module Core_command = Command
open! Commandlang

module type Argable = sig
  type t [@@deriving equal, sexp_of]

  val arg : t Or_error.t Command.Arg.t
  val to_args : t -> string list
end

let test_roundtrip (type a) ~(inputs : a list) (module A : Argable with type t = a) =
  List.iter inputs ~f:(fun t ->
    let args = A.to_args t in
    let { Commandlang_to_base.Translate.Private.Arg.param } =
      Commandlang_to_base.Translate.Private.Arg.project
        (Commandlang.Command.Private.To_ast.arg A.arg)
        ~config:(Commandlang_to_base.Translate.Config.create ())
    in
    let t' = Core_command.Param.parse param args |> Or_error.join |> Or_error.ok_exn in
    require_equal [%here] (module A) t t')
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
