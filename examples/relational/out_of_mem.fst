(*--build-config
    options:--admit_fsi FStar.Set --z3timeout 15;
    other-files:set.fsi heap.fst st.fst all.fst st2.fst
  --*)

module NonInterference

open FStar.Comp
open FStar.Heap
open FStar.Relational

(* We model labels with different levels as integers *)
type label = int

(* Label of the attacker *)
assume val alpha : label

(* Labeling function (assigns a label to every reference) *)
assume val label_fun : ref int -> Tot label

(* A reference can be observed bu the attacker if its label is not higher than
   alpha *)
let attacker_observable x = label_fun x <= alpha

type alpha_equiv (h1:double heap) = (forall (x:ref int). attacker_observable x 
                                                   ==> sel (R.l h1) x = sel (R.r h1) x) 

(* Definition of Noninterference  If all attacker-observable references contain
   equal values before the function call, then they also have to contain equal
   values after the function call. *)
type ni = double unit ->
          ST2 (double unit)
              (requires (fun h -> alpha_equiv h))
              (ensures  (fun _ _ h2 -> alpha_equiv h2))

(* Function to create new labeled references *)
assume val new_labeled_int : l:label -> x:ref int{label_fun x = l}

let tu = twice ()

(* Simple Examples using the above definition of Noninterference*)
module Example
open NonInterference
open FStar.Comp
open FStar.Relational

assume val la : la:int
assume val lb : lb:int{lb <= la}
assume val lc : lc:int{lc <= la /\ lb <= lc}
assume val ld : ld:int
assume val le : le:int{le <= ld /\ le <= lc}
assume val lf : lf:int{lf <= ld /\ le <= lf}
assume val lg : lg:int
assume val lh : lh:int{lh <= lg}
assume val li : li:int{li <= lg}
assume val lj : lj:int

let a = new_labeled_int la
let b = new_labeled_int lb
let c = new_labeled_int lc
let d = new_labeled_int ld
let e = new_labeled_int le
let f = new_labeled_int lf
let g = new_labeled_int lg
let h = new_labeled_int lh
let i = new_labeled_int li
let j = new_labeled_int lj

type distinct10 (#t:Type) (a1:t) (a2:t) (a3:t) (a4:t) (a5:t) (a6:t) (a7:t) (a8:t) (a9:t) (a10:t) =
      a1 <> a2 /\ a1 <> a3 /\ a1 <> a4 /\ a1 <> a5 /\ a1 <> a6 /\ a1 <> a7 /\ a1 <> a8 /\ a1 <> a9 /\ a1 <> a10
  /\  a2 <> a3 /\ a2 <> a4 /\ a2 <> a5 /\ a2 <> a6 /\ a2 <> a7 /\ a2 <> a8 /\ a2 <> a9 /\ a2 <> a10
  /\  a3 <> a4 /\ a3 <> a5 /\ a3 <> a6 /\ a3 <> a7 /\ a3 <> a8 /\ a3 <> a9 /\ a3 <> a10
  /\  a4 <> a5 /\ a4 <> a6 /\ a4 <> a7 /\ a4 <> a8 /\ a4 <> a9 /\ a4 <> a10
  /\  a5 <> a6 /\ a5 <> a7 /\ a5 <> a8 /\ a5 <> a9 /\ a5 <> a10
  /\  a6 <> a7 /\ a6 <> a8 /\ a6 <> a9 /\ a6 <> a10
  /\  a7 <> a8 /\ a7 <> a9 /\ a7 <> a10
  /\  a8 <> a9 /\ a8 <> a10
  /\  a9 <> a10

assume Distinct : distinct10 a b c d e f g h i j

let test () = a := !b + !c;
              d := !e * !f;
              c := !a - !e;
              g := !h + !i;
              f := !a + !b + !c + !d + !e + !g + !h + !i;
              f := !f - !a - !b - !c - !d;
              f := !f - !e - !g - !h - !i;
(* Adding this line uses all the memory *)
              f := 0; 

              if !f = 0 then
                f := !e
              else
                f := !a

val test_ni : ni
let test_ni _ = compose2_self test (twice ())