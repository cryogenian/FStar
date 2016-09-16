module Crypto.AEAD.AES256GCM

open FStar.Mul
open FStar.Ghost
open FStar.HyperStack
open FStar.HST
open FStar.UInt8
open FStar.Buffer
open FStar.Int.Cast
open Crypto.Symmetric.AES
open Crypto.Symmetric.GCM

#reset-options "--initial_fuel 0 --max_fuel 0 --z3timeout 100"

module U32 = FStar.UInt32

type bytes = buffer byte

let lemma_aux_001 (w:bytes{length w >= 240}) : Lemma (length w >= 4 * U32.v nb * (U32.v nr+1)) = ()

(* Block cipher function AES256 *)
private val aes256: key:bytes{length key = 32} ->
    input:bytes{length input = 16 /\ disjoint key input} ->
    out:bytes{length out = 16 /\ disjoint key out /\ disjoint input out} ->
    STL unit
      (requires (fun h -> live h key /\ live h input /\ live h out))
      (ensures  (fun h0 _ h1 -> live h1 out /\ modifies_1 out h0 h1))
let aes256 key input out =
  let hinit = HST.get() in
  push_frame();
  let h0 = HST.get() in
  let tmp = create (0uy) 752ul in
  let w = sub tmp 0ul 240ul in
  let sbox = sub tmp 240ul 256ul in
  let inv_sbox = sub tmp 496ul 256ul in
  assert(~(contains h0 w) /\ ~(contains h0 inv_sbox) /\ ~(contains h0 sbox));
  lemma_aux_001 w;
  let h1 = HST.get() in
  mk_sbox sbox;
  mk_inv_sbox inv_sbox;
  let h2 = HST.get() in
  assert(modifies_0 h0 h2);
  keyExpansion key w sbox;
  let h3 = HST.get() in
  assert(modifies_0 h0 h3);
  cipher out input w sbox;
  let h4 = HST.get() in
  assert(modifies_2_1 out h0 h4);
  assert(poppable h4);
  pop_frame();
  let hfin = HST.get() in
  assert(live hfin out);
  modifies_popped_1 out hinit h0 h4 hfin

(* Main AEAD functions *)
val aead_encrypt: ciphertext:bytes ->
    tag:bytes{length tag = 16 /\ disjoint ciphertext tag} ->
    key:bytes{length key = 32 /\ disjoint ciphertext key /\ disjoint tag key} ->
    iv:bytes{length iv = 12 /\ disjoint ciphertext iv /\ disjoint tag iv /\ disjoint key iv} ->
    plaintext:bytes{length plaintext = length ciphertext /\ disjoint ciphertext plaintext /\ disjoint tag plaintext /\ disjoint key plaintext /\ disjoint iv plaintext} ->
    len:u32{length ciphertext = U32.v len} ->
    ad:bytes{disjoint ciphertext ad /\ disjoint tag ad /\ disjoint key ad /\ disjoint iv ad /\ disjoint plaintext ad} ->
    adlen:u32{length ad = U32.v adlen} ->
    STL unit
    (requires (fun h -> live h ciphertext /\ live h tag /\ live h key /\ live h iv /\ live h plaintext /\ live h ad))
    (ensures (fun h0 _ h1 -> live h1 ciphertext /\ live h1 tag /\ live h1 key /\ live h1 iv /\ live h1 plaintext /\ live h1 ad
      /\ modifies_2 ciphertext tag h0 h1))
let aead_encrypt ciphertext tag key iv plaintext len ad adlen =
    Crypto.Symmetric.GCM.encrypt #32 aes256 ciphertext tag key iv ad adlen plaintext len

(* TODO: AEAD decrypt function *)