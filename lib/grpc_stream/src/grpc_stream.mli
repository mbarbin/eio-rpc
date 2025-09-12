(*_********************************************************************************)
(*_  eio-rpc - Build RPC clients and servers with eio and grpc                    *)
(*_  SPDX-FileCopyrightText: 2023-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

(** A data structure to hold stream of values exchanged between clients and
    servers. *)

(*_ Note (mbarbin): Eventually I wish to use a [Eio] standard data structure for
  the streams, and I would like it even better if that's also what Grpc exposed
  directly. In the meantime, we only expose here a minimalistic API needed by
  the client code, so it is easy to modify while the design settles. Guideline:
  Add new functions lazily here only when strictly needed. *)
type 'a t = 'a Grpc_eio.Seq.t

val iter : 'a t -> f:('a -> unit) -> unit

module Writer : sig
  type 'a t = 'a Grpc_eio.Seq.writer

  (** Append a value at the current end of the stream. *)
  val write : 'a t -> 'a -> unit

  (** Once all the values have been written to the stream, it must be closed
      explicitly with this function. *)
  val close : _ t -> unit
end
