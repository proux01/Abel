From mathcomp Require Import all_ssreflect all_fingroup all_algebra all_solvable.
From mathcomp Require Import all_field.
From Abel Require Import Sn_solvable.

(******************************************************************************)
(*                                                                            *)
(*  Definitions for the statement ?                                           *)
(*    pure extension                                                          *)
(*    radical tower                                                           *)
(*    radical extension                                                       *)
(*    solvable by radicals                                                    *)
(*    Galois group of a polynomial ?                                          *)
(*                                                                            *)
(*  Additional lemmas ?                                                       *)
(*    Eisenstein criterion                                                    *)
(*                                                                            *)
(******************************************************************************)

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.


Section Defs.


Variables (F : fieldType) (L : splittingFieldType F).

(* Giving the parameters m and x in the definition makes it a boolean         *)
(* predicate which is useful as the tower property can be expressed as a path,*)
(* but it feels quite ugly for a tower                                        *)
Definition pure_extension (K E : {subfield L}) (x : L) (m : nat) :=
  [&& m > 0, (x ^+ m)%R \in K & (<<K; x>>%VS == E)].

Definition radical_tower (n : nat) (K : {subfield L})
  (sE : n.-tuple {subfield L}) (sx : n.-tuple L) (sm : n.-tuple nat) :=
  path (fun (U V : {subfield L} * (L * nat)) =>
     (U.1 <= V.1)%VS && pure_extension U.1 V.1 V.2.1 V.2.2)
     (K,(0%R,0)) [tuple (tnth sE i, (tnth sx i, tnth sm i)) | i < n].

(* Here, it feels really heavy with all the exists... *)
Definition radical_extension (K E : {subfield L}) :=
  exists2 n : nat, n > 0 & exists2 sE : n.-tuple {subfield L},
  last K sE == E & exists sx : n.-tuple L, exists sm : n.-tuple nat,
  radical_tower K sE sx sm.



(* Can we have a direct definition for 'the splitting field of a polynomial'  *)
(* which is a {subfield L} ? But L must then be big enough                    *)

Definition solvable_by_radicals (k K : {subfield L}) (p : {poly L}) :=
  splittingFieldFor k p K ->
  exists2 E : {subfield L}, radical_extension k E & (K <= E)%VS.

Lemma AbelGalois (k : {subfield L}) (K : {subfield L}) (p : {poly L}) :
  splittingFieldFor k p K ->
  solvable_by_radicals k K p <-> solvable ('Gal (K / k)).
Proof.
Admitted.


End Defs.





Section Examples.


Import GRing.Theory Num.Theory.

Open Scope ring_scope.


Variable (L : splittingFieldType rat).
Variable (K : {subfield L}).

Section Example1.

Variable P : {poly rat}.

Hypothesis K_split_P : splittingFieldFor 1%AS (map_poly ratr P) K.
Hypothesis P_sep : separable_poly P.
Hypothesis P_irr : irreducible_poly P.

Let p := (size P).-1.
Hypothesis p_prime : prime p.

Let rs := sval (closed_field_poly_normal ((map_poly ratr P) : {poly algC})).
Hypothesis count_roots_P : count (fun x => x \isn't Num.real) rs == 2.

Lemma rs_roots : all (root (map_poly ratr P)) rs.
Proof.
Admitted.


(* This lemma should be divided into smaller parts                            *)
Definition pre_gal_perm (g : gal_of K) (i : 'I_p) : 'I_p.
Admitted.

Lemma gal_perm_is_perm (g : gal_of K) : injectiveb (finfun (pre_gal_perm g)).
Proof.
Admitted.

Definition gal_perm (g : gal_of K) := Perm (gal_perm_is_perm g).



Lemma injective_gal_perm : injective gal_perm.
Proof.
Admitted.

Lemma gal_perm_is_morphism :
  {in ('Gal(K / 1%AS))%G &, {morph gal_perm : x y / (x * y)%g >-> (x * y)%g}}.
Proof.
Admitted.

Canonical gal_perm_morphism :=  Morphism gal_perm_is_morphism.



Lemma injm_gal_perm : ('injm gal_perm)%g.
Proof.
Admitted.


(* Here it should also be divided                                             *)
Definition gal_orderp : gal_of K.
Admitted.

Lemma gal_orderp_orderp : #[gal_orderp]%g = p.
Proof.
Admitted.

Lemma permp_orderp : #[(gal_perm gal_orderp)]%g = p.
Proof.
(* morph_order & p_prime *)
Admitted.



(* Using the 2 complex roots                                                  *)
Definition gal_order2 : gal_of K.
Admitted.

Lemma gal_order2_order2 : #[gal_order2]%g = 2.
Proof.
Admitted.

Lemma perm2_order2 : #[(gal_perm gal_order2)]%g = 2.
Proof.
Admitted.



(* Missing lemma :                                                            *)
(* Sp is generated by a p-cycle and a transposition : how to state it ?       *)



Lemma surj_gal_perm : (gal_perm @* 'Gal (K / 1%AS) = 'Sym_('I_p))%g.
Proof.
Admitted.




Lemma isog_gal_perm : 'Gal (K / 1%AS) \isog ('Sym_('I_p)).
Proof.
(* isogP, surj_gal_perm & injm_gal_perm *)
Admitted.


End Example1.

(* I think this lemma is quite close to the mathematical statement :          *)
(* Let P be an irreducible polynomial with rational coefficients, separable   *)
(* and of degree p prime. If P has precisely two nonreal roots in the complex *)
(* numbers, then the Galois group of P is Sp                                  *)
Lemma example1 (P : {poly rat}) (C : numClosedFieldType) :
  splittingFieldFor 1%AS (map_poly ratr P) K ->
  separable_poly P ->
  irreducible_poly P ->
  let p := (size P).-1 in prime p ->
  let rs := sval (closed_field_poly_normal ((map_poly ratr P) : {poly C})) in
  count (fun x => x \isn't Num.real) rs == 2 ->
  'Gal (K / 1%AS) \isog ('Sym_('I_p)).
Proof.
(* We could split this lemma in smaller steps (which may be generalized) :    *)
(*   - constructing a function from the Galois group to the permutations      *)
(*   - showing it is injective                                                *)
(*   - showing it is a group morphism                                         *)
(*   - there is an element of order p in its image                            *)
(*   - there is a transposition in its image (with the nonreal roots)         *)
(*   - Sp is generated by any p-cycle and a transposition (this may already   *)
(*       exists, but I don't know where)                                      *)
(* See Section Example1 just above for a first draft of the steps             *)
Admitted.

Definition poly_example : {poly rat} := 'X^5 - 4%:R *: 'X + 2%:R%:P.

Lemma size_poly_ex : size poly_example = 6.
Proof.
rewrite /poly_example -addrA size_addl ?size_polyXn//.
by rewrite size_addl ?size_opp ?size_scale ?size_polyX ?size_polyC.
Qed.

Lemma poly_example_neq0 : poly_example != 0.
Proof. by rewrite -size_poly_eq0 size_poly_ex. Qed.

(* Usually, this is done with Eisenstein's criterion, but I don't think it is *)
(* already formalized in mathcomp                                             *)
(***  By Cyril ?                                                            ***)
Lemma irreducible_ex : irreducible_poly poly_example.
Proof.
Admitted.


Lemma separable_ex : separable_poly poly_example.
Proof.
apply/coprimepP => d /(irredp_XsubCP irreducible_ex) [//| eqd].
have size_deriv_ex : size poly_example^`() = 5.
  rewrite !derivCE addr0 alg_polyC -scaler_nat /=.
  by rewrite size_addl ?size_scale ?size_opp ?size_polyXn ?size_polyC.
by rewrite gtNdvdp -?size_poly_eq0 ?size_deriv_ex ?(eqp_size eqd) ?size_poly_ex.
Qed.

Lemma prime_ex : prime (size poly_example).-1.
Proof. by rewrite size_poly_ex. Qed.

(* Using the package real_closed, we should be able to monitor the sign of    *)
(* the derivative, and find that the polynomial has exactly three real roots. *)
(*** By Cyril ?                                                             ***)
Lemma count_roots_ex :
  let rs := sval (closed_field_poly_normal ((map_poly ratr poly_example) : {poly algC})) in
  count (fun x => x \isn't Num.real) rs == 2.
Proof.
Admitted.


(* An example of how it could feel to use the proposed statement              *)
Lemma example_not_solvable_by_radicals :
  splittingFieldFor 1%AS (map_poly ratr poly_example) K ->
  ~ solvable_by_radicals 1%AS K (map_poly ratr poly_example).
Proof.
move=> K_splitP; rewrite (AbelGalois K_splitP).
have := (example1 K_splitP separable_ex irreducible_ex prime_ex count_roots_ex).
by move/isog_sol => ->; apply: not_solvable_Sym; rewrite card_ord size_poly_ex.
Qed.


Inductive algformula : Type :=
| Const of rat
| Add of algformula & algformula
| Opp of algformula
| Mul of algformula & algformula
| Inv of algformula
| NRoot of nat & algformula.

Fixpoint alg_eval (f : algformula) : algC :=
  match f with
  | Const x => ratr x
  | Add f1 f2 => (alg_eval f1) + (alg_eval f2)
  | Opp f1 => - (alg_eval f1)
  | Mul f1 f2 => (alg_eval f1) * (alg_eval f2)
  | Inv f1 => (alg_eval f1)^-1
  | NRoot n f1 => nthroot n (alg_eval f1)
  end.

(* I changed a little bit the statement your proposed as being solvable by    *)
(* radicals can't be obtain from a formula for only one root.                 *)
(* I also feel that giving both the coefficients of the polynomial and access *)
(* to the rationals is redundant.                                             *)
Lemma example_formula (p : {poly rat}) :
  splittingFieldFor 1%AS (map_poly ratr poly_example) K ->
  solvable_by_radicals 1%AS K (map_poly ratr p) <->
  {in root (map_poly ratr p), forall x, exists f : algformula, alg_eval f = x}.
Proof.
Admitted.

End Examples.