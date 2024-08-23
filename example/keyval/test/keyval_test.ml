let executable = "./keyval.exe"

let config =
  Grpc_test_helpers.Config.grpc_discovery
    ~run_server_command:{ executable; args = [ "server"; "run" ] }
    ~run_client_command:{ executable; args = [] }
;;
