let () =
  match
    Cmdliner.Cmd.eval_value'
      (Commandlang_to_cmdliner.Translate.command
         Keyval_command.main
         ~name:"keyval"
         ~version:"%%VERSION%%")
  with
  | `Ok (Ok ()) -> ()
  | `Exit code -> Stdlib.exit code
  | `Ok (Error err) ->
    prerr_endline (Base.Error.to_string_hum err);
    Stdlib.exit 1
;;
