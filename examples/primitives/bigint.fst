(*--build-config
  options:--admit_fsi FStar.Set --admit_fsi Parameters --verify_module Bigint --z3timeout 5;
  other-files:FStar.Classical.fst FStar.PredicateExtensionality.fst FStar.Set.fsi seq.fsi FStar.Seq.fst FStar.SeqProperties.fst FStar.Heap.fst FStar.ST.fst FStar.All.fst FStar.Array.fst FStar.Ghost.fst axioms.fst intlib.fst parameters1305.fst sint.fst FStar.UInt8.fst FStar.UInt63.fst sbuffer.fst;
  --*)

module Bigint

open FStar.ST
open FStar.Heap
open FStar.Ghost
open IntLib
open Parameters
open Sint
open SBuffer

type template = nat -> Tot pos
type template_const = t:template{ forall (n:nat). t n = t 0 }

val byte_templ: template
let byte_templ = fun x -> 8

type bigint = buffer 63
type bytes = buffer 8

(* Normalized big integer type *)
opaque type Norm (h:heap) (b:bigint)  =
  Live h b /\ length b >= norm_length 
  /\ (forall (i:nat). {:pattern (v (get h b i))} i < norm_length ==>  v (get h b i) < pow2 (templ i))

opaque type Null (h:heap) (b:bigint) =
  Live h b /\ (forall (n:nat). {:pattern (v (get h b n))} n < length b ==> v (get h b n) = 0)

type Filled (h:heap) (b:bigint) =
  Live h b /\ length b >= norm_length /\ 
  (forall (i:nat). {:pattern (v (get h b i))} i < norm_length ==> (pow2 ndiff' <= v (get h b i) /\ v (get h b i) < pow2 ndiff))

val bitweight : t:template -> n:nat -> GTot nat
let rec bitweight t n = 
  match n with 
  | 0 -> 0
  | _ -> t (n-1) + bitweight t (n-1)

val eval : h:heap -> b:bigint{Live h b} -> n:nat{n <= length b} -> GTot nat
let rec eval h  b n =
  match n with
  | 0 -> 0
  | _ -> pow2 (bitweight templ (n-1)) * v (get h b (n-1)) + eval h  b (n-1)

val eval_bytes : h:heap -> b:bytes{Live h b} -> n:nat{n <= length b} -> GTot nat
let rec eval_bytes h b n =
  match n with
  | 0 -> 0
  | _ -> pow2 (bitweight byte_templ (n-1)) * v (get h b (n-1)) + eval_bytes h b (n-1)

val maxValue: h:heap -> b:bigint{Live h  b} -> l:pos{l <= length  b} -> GTot nat
let rec maxValue h  b l = 
  match l with
  | 1 -> v (get h  b 0)
  | _ -> if maxValue h  b (l-1) > v (get h  b (l-1)) then maxValue h  b (l-1)
	 else v (get h  b (l-1))

val maxValue_lemma_aux: h:heap -> b:bigint{Live h b} -> l:pos{l<=length b} ->
  Lemma (forall (i:nat). i < l ==> v (get h b i) <= maxValue h b l)
let rec maxValue_lemma_aux h b l = match l with | 1 -> () | _ -> maxValue_lemma_aux h b (l-1)

opaque val gmaxValue_lemma: h:heap -> b:bigint{Live h b /\ length b > 0} ->
  GLemma unit (requires (True)) 
	(ensures (forall (i:nat). {:pattern (v (get h b i))} i < length b ==> v (get h b i) <= maxValue h b (length b))) []
let rec gmaxValue_lemma h b = maxValue_lemma_aux h b (length b)

val maxValue_lemma: h:heap -> b:bigint{Live h b /\ length b > 0} ->
  Lemma (requires (True)) 
	(ensures (forall (i:nat). {:pattern (v (get h b i))} i < length b ==> v (get h b i) <= maxValue h b (length b))) 
	[SMTPat (maxValue h b (length b))]
let maxValue_lemma h b = coerce (requires (True)) (ensures (forall (i:nat). i < length b ==> v (get h b i) <= maxValue h b (length b))) (fun _ -> gmaxValue_lemma h b)

val maxValue_bound_lemma_aux: h:heap -> b:bigint{Live h b /\ length b > 0} -> l:pos{l<=length b} -> 
  bound:nat ->  Lemma (requires (forall (i:nat). i < l ==> v (get h b i) <= bound))
	             (ensures (maxValue h b l <= bound))
let rec maxValue_bound_lemma_aux h b l bound = match l with | 1 -> () | _ -> maxValue_bound_lemma_aux h b (l-1) bound

opaque val gmaxValue_bound_lemma: h:heap -> b:bigint{Live h b /\ length b > 0} -> bound:nat ->  
  GLemma unit (requires (forall (i:nat). i < length b ==> v (get h b i) <= bound))
	      (ensures (maxValue h b (length b) <= bound)) []
let gmaxValue_bound_lemma h b bound = maxValue_bound_lemma_aux h b (length b) bound

val maxValue_bound_lemma: h:heap -> b:bigint{Live h b /\ length b > 0} -> bound:nat ->  
  Lemma (requires (forall (i:nat). i < length b ==> v (get h b i) <= bound))
	(ensures (maxValue h b (length b) <= bound)) 
let maxValue_bound_lemma h b bound = 
  coerce (requires (forall (i:nat). i < length b ==> v (get h b i) <= bound))
	 (ensures (maxValue h b (length b) <= bound)) 
	 (fun _ -> gmaxValue_bound_lemma h b bound)

val maxValueNorm: h:heap -> b:bigint{Live h  b /\ length  b >= norm_length} -> GTot nat
let maxValueNorm h  b = maxValue h b norm_length

val maxValueIdx: h:heap ->b:bigint{Live h  b} -> l:pos{l<=length  b} -> GTot nat
let rec maxValueIdx h  b l = 
  match l with 
  | 1 -> 0
  | _ -> if maxValue h  b l = v (get h b (l-1)) then l - 1 else maxValueIdx h b (l-1)

val maxValue_eq_lemma: 
  ha:heap -> hb:heap -> a:bigint{Live ha  a} -> b:bigint{Live hb  b} -> l:nat -> Lemma 
    (requires (Eq ha a hb b /\ l > 0 /\ l <= length a)) 
    (ensures (Eq ha a hb b /\ l > 0 /\ l <= length a /\ maxValue ha a l = maxValue hb b l))
let rec maxValue_eq_lemma ha hb a b l = 
  match l with
  | 1 -> ()
  | _ -> cut (forall (i:nat). i < length b ==> v (get ha a i) = v (get hb b i)); 
         maxValue_eq_lemma ha hb a b (l-1)
  
val maxValueNorm_eq_lemma: 
  ha:heap -> hb:heap -> a:bigint{ Live ha a /\ length a >= norm_length }  -> b:bigint{ Live hb b /\ length b >= norm_length } -> 
  Lemma 
    (requires (Eq ha a hb b)) 
    (ensures (maxValueNorm ha a = maxValueNorm hb b))
let maxValueNorm_eq_lemma ha hb a b = maxValue_eq_lemma ha hb a b norm_length

val eval_eq_lemma: ha:heap -> hb:heap -> a:bigint{Live ha a} -> b:bigint{Live hb b} ->
  len:nat{ (len <= length a) /\ (len <= length b) } -> Lemma
    (requires ( (forall (i:nat). i < len ==> v (get ha a i) = v (get hb b i)) ))
    (ensures ( eval ha a len = eval hb b len ))
let rec eval_eq_lemma ha hb a b len =
  match len with
  | 0 -> ()
  | _ -> eval_eq_lemma ha hb a b (len-1)

val eval_partial_eq_lemma: ha:heap -> hb:heap -> a:bigint{Live ha a} ->  b:bigint{Live hb b} -> 
  ctr:nat -> len:nat{ ctr <= len /\ len <= length a /\ len <= length b} -> Lemma
    (requires (EqSub ha a ctr hb b ctr (len-ctr)))
    (ensures ( eval ha a len - eval ha a ctr = eval hb b len - eval hb b ctr ))
let rec eval_partial_eq_lemma ha hb a b ctr len =
  match len-ctr with
  | 0 -> ()
  | _ -> 
    cut (forall (i:nat). {:pattern (v (get ha a i))} i < len - ctr ==> v (get ha a (ctr+i)) = v (get hb b (ctr+i))); 
    eval_partial_eq_lemma ha hb a b ctr (len-1); 
    cut (True /\ eval ha a (len-1) - eval ha a ctr = eval hb b (len-1) - eval hb b ctr); 
    cut (eval ha a len = pow2 (bitweight templ (len-1)) * v (get ha a (len-1)) + eval ha a (len-1) /\ eval hb b len = pow2 (bitweight templ (len-1)) * v (get hb b (len-1)) + eval hb b (len-1)); 
    cut (True /\ v (get ha a (ctr + (len-ctr-1))) = v (get hb b (len-1)))

val eval_null: h:heap -> b:bigint{Live h b} -> len:nat{len <= length b} -> Lemma
    (requires (forall (i:nat). {:pattern (v (get h b i))} i < len ==> v (get h b i) = 0))
    (ensures (eval h b len = 0))
let rec eval_null h  b len =
  match len with
  | 0 -> ()
  | _ -> eval_null h b (len-1)

val max_value_of_null_lemma: h:heap -> b:bigint{Live h b /\ length b > 0} -> l:pos{l <= length b} ->
  Lemma (requires (Null h b))
	(ensures (maxValue h b l = 0))
let rec max_value_of_null_lemma h b l = 
  match l with
  | 1 -> ()
  | _ -> max_value_of_null_lemma h b (l-1)

