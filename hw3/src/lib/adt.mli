(* Abstract Data Type for Simple C program *)

(******************************************************************************)
(******************************************************************************)
(* Common Definition                                                          *)
(******************************************************************************)
(******************************************************************************)

type id = string


(******************************************************************************)
(******************************************************************************)
(* Type                                                                       *)
(******************************************************************************)
(******************************************************************************)

module Ty : sig
  type t = 
    | T_int
    | T_bool
    | T_arr   of t

  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Expression                                                                 *)
(******************************************************************************)
(******************************************************************************)

module Expr : sig
  type t =
    | E_int   of int
    | E_bool  of bool
    | E_var   of var
    | E_add   of t * t
    | E_sub   of t * t
    | E_mul   of t * t
    | E_div   of t * t
    | E_neg   of t
    | E_len   of var
    | E_not   of t
    | E_eq    of t * t
    | E_neq   of t * t
    | E_lt    of t * t
    | E_gt    of t * t
    | E_le    of t * t
    | E_ge    of t * t
    | E_call  of id * t list

  and var =
    | V_var   of id
    | V_arr   of var * t

  val to_string : t -> string
  val string_of_lv : var -> string
end


(******************************************************************************)
(******************************************************************************)
(* Formula                                                                    *)
(******************************************************************************)
(******************************************************************************)

module Fmla : sig
  type t =
    | F_exp     of Expr.t
    | F_not     of t
    | F_and     of t list
    | F_or      of t list
    | F_imply   of t * t
    | F_iff     of t * t
    | F_forall  of Expr.var * t
    | F_exists  of Expr.var * t
  
  val create_sorted : (Expr.var * Expr.t * Expr.t) -> t
  val create_partitioned : (Expr.var * Expr.t * Expr.t * Expr.t * Expr.t) -> t
  val flatten : t -> t
  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Invariant                                                                  *)
(******************************************************************************)
(******************************************************************************)

module Inv : sig
  type t = {
    id: id;
    f: Fmla.t;
  }

  val create : Fmla.t -> id:id -> t
  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Ranking Funciton                                                           *)
(******************************************************************************)
(******************************************************************************)

module Rank : sig
  type t = Expr.t list

  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Statement                                                                  *)
(******************************************************************************)
(******************************************************************************)

module Stmt : sig
  type t =
    | S_seq     of t list
    | S_skip
    | S_assign  of Expr.var * Expr.t
    | S_if      of Expr.t * t * t
    | S_while   of Inv.t * Rank.t option * Expr.t * t
    | S_return  of Expr.t
    | S_break

  val flatten : t -> t
  val to_string : ?indent:int -> t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Declaration of a Variable                                                  *)
(******************************************************************************)
(******************************************************************************)

module Decl : sig
  type t = {
    typ: Ty.t;
    id: id;
  }

  val create : Ty.t -> id:id -> t
  val to_string : t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Program                                                                    *)
(******************************************************************************)
(******************************************************************************)

module Pgm : sig
  type t = {
    pre: Inv.t;
    post: Inv.t;
    rank: Rank.t option;
    typ: Ty.t;
    id: id;
    args: Decl.t list;
    locals: Decl.t list;
    stmt: Stmt.t;
  }
  
  val create : Stmt.t 
               -> pre:Inv.t 
               -> post:Inv.t 
               -> rank:Rank.t option 
               -> typ:Ty.t 
               -> id:id 
               -> args:Decl.t list 
               -> locals:Decl.t list 
               -> t
  val to_string : ?indent:int -> t -> string
end


(******************************************************************************)
(******************************************************************************)
(* Alias                                                                      *)
(******************************************************************************)
(******************************************************************************)

type t = Pgm.t

val string_of_id : id -> string
val string_of_typ : Ty.t -> string
val string_of_expr : Expr.t -> string
val string_of_lv : Expr.var -> string
val string_of_fmla : Fmla.t -> string
val string_of_inv : Inv.t -> string
val string_of_rank : Rank.t -> string
val string_of_stmt : ?indent:int -> Stmt.t -> string
val string_of_decl : Decl.t -> string
val string_of_pgm : ?indent:int -> Pgm.t -> string
