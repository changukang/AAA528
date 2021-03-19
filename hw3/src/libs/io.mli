(* Input and Output Frontend Definition for HW3 *)

(******************************************************************************)
(******************************************************************************)
(* Input                                                                      *)
(******************************************************************************)
(******************************************************************************)

module Input : sig
  type t = Adt.Pgm.t

  exception Error of string

  val position : Lexing.lexbuf -> string
  val read : unit -> t
  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Output                                                                     *)
(******************************************************************************)
(******************************************************************************)

module Output : sig
  
end