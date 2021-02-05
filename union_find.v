Require Import Coq.PArith.PArith.
Require Import Coq.Lists.List.
Require Import Coq.FSets.FMapPositive.
Import ListNotations.
Local Open Scope list_scope.
Local Open Scope positive_scope.

(** We follow https://cp-algorithms.com/data_structures/disjoint_set_union.html *)

Module Type DisjointSetUnion.
  (** t is standing in for the datastructure that we will store the information about the connectedness of the graph. **)
  Parameter t : Type.

  (** make_set registers a given node as being in its own connected component. *)
  (** takes in a node, and takes in connectedness, gives you connectedness. *)
  Parameter make_set : positive -> t -> t.

  (** union_sets merges two connected components. *)
  (** takes in two nodes, connectedness information, updates and returns the connectedness information. *)
  Parameter union_sets : positive -> positive -> t -> t.

  (** find_set tells you the representative element of the connected component of a given node. *)
  (** takes in node, connectedness information, gives representative element node and connectedness information. Returning the connectedness information is for optimizations. *)
  Parameter find_set : positive -> t -> option positive * t.

  (** Connectedness information for graph with no nodes *)
  Parameter empty : t.

  (** Spec of empty is that find_set of anything on empty is none *)
  Axiom find_set_empty : forall n, fst (find_set n empty) = None.

  (** after calling make_set, find_set returns self *)
  Axiom find_make_set : forall n conn, fst (find_set n (make_set n conn)) = Some n.

  (** when make_set is called on a node for the first time, find_set on this node will have an effect only on itself and no other node. *)
  Axiom make_set_restricted : forall n n' conn, fst (find_set n conn) = None -> n <> n' -> fst (find_set n' (make_set n conn)) = fst (find_set n' conn).

  (** connecting two nodes is connecting all the nodes in both of their components. *)
  Axiom find_union_sets : forall a b a' b' conn, fst (find_set a conn) = fst (find_set a' conn) -> fst (find_set b conn) = fst (find_set b' conn)
                                                 -> let conn' := union_sets a b conn in
                                                    fst (find_set a' conn') = fst (find_set b' conn').

  (** connecting two componenets does not change other components *)
  Axiom union_sets_restricted : forall a b v conn, fst (find_set a conn) <> fst (find_set v conn) -> fst (find_set b conn) <> fst (find_set v conn)
                                                   -> fst (find_set v (union_sets a b conn)) = fst (find_set v conn).

  (** the updated connectedness information of find_set does not change the representative element of any connected component *)
End DisjointSetUnion.
