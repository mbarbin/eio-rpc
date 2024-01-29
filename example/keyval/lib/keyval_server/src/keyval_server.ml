type t = { table : Keyval.Value.t Hashtbl.M(Keyval.Key).t }

let create () = { table = Hashtbl.create (module Keyval.Key) }

let get t key =
  match Hashtbl.find t.table key with
  | Some value -> Ok value
  | None -> Or_error.error_s [%sexp "Key not found", { key : Keyval.Key.t }]
;;

let set t { Keyval.Keyval_pair.key; value } = Hashtbl.set t.table ~key ~data:value

let delete t key =
  let found = ref false in
  Hashtbl.change t.table key ~f:(fun prev ->
    found := Option.is_some prev;
    None);
  if !found
  then Ok ()
  else Or_error.error_s [%sexp "Key not found", { key : Keyval.Key.t }]
;;

let list_keys t = Hashtbl.keys t.table |> Set.of_list (module Keyval.Key)

let implement_rpcs t =
  Grpc_server.implement
    [ Grpc_server.Rpc.unary (module Keyval_rpc.Get) ~f:(fun key -> get t key)
    ; Grpc_server.Rpc.unary
        (module Keyval_rpc.Set_)
        ~f:(fun keyval_pair -> set t keyval_pair)
    ; Grpc_server.Rpc.unary (module Keyval_rpc.Delete) ~f:(fun key -> delete t key)
    ; Grpc_server.Rpc.unary (module Keyval_rpc.List_keys) ~f:(fun () -> list_keys t)
    ]
;;
