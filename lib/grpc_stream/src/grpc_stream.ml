type 'a t = 'a Grpc_eio.Seq.t

let iter t ~f = Grpc_eio.Seq.iter f t

module Writer = struct
  type 'a t = 'a Grpc_eio.Seq.writer

  let write = Grpc_eio.Seq.write
  let close = Grpc_eio.Seq.close_writer
end
