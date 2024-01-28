let () = QCheck_runner.run_tests_main (Keyval_rpc_proto.Keyval.all_quickcheck_tests ())
