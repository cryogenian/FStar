module Flag

// this interface is meant to be opened -- avoid naming clashes. 

(* floating *) 

type mac_alg =
  | POLY1305
  | GHASH

type aead_cipher =
  | AES_256_GCM
  | CHACHA20_POLY1305

type id = {
  cipher: aead_cipher;
  uniq: UInt32.t // we'll need more
}

let mac_of_id i =
  match i.cipher with
  | AES_256_GCM       -> GHASH
  | CHACHA20_POLY1305 -> POLY1305

let cipher_of_id i =
  let open Crypto.Symmetric.Cipher in 
  match i.cipher with
  | AES_256_GCM       -> AES256
  | CHACHA20_POLY1305 -> CHACHA20

let cipher_alg = Crypto.Symmetric.Cipher.alg

(* All the idealization flags that we use for the cryptographic argument *)

// TODO check that the real implementation normalizes fully.


(* CRYPTOGRAPHIC SECURITY ASSUMPTIONS.
   These are not conditioned by i. 
   They suffice to select every intermediate game in our proof.
   They are ordered as successive idealization steps in our proof.
   We used to refer to those as "algorithmic strength predicates".
*) 

// controls idealization of each cipher as a perfect random function
val cipher_prf: cipher_alg -> Tot bool 

// controls existence of logs for all MACs
val mac_log: bool                

// idealizes each one-time MAC as perfectly INT-1CMA.
val mac_int1cma: mac_alg -> Tot bool  

// controls 2nd, perfect idealization step in enxor/dexor for all PRFs.
val prf_cpa: bool


(* CONDITIONAL IDEALIZATION *) 

// guarantees fresh record keys (to be defined by TLS Handshake)
val safeHS: i:id -> Tot bool 

// controls PRF idealization of ciphers (move to PRF?)
let prf (i: id) = safeHS i && cipher_prf(cipher_of_id i)

// controls INT1CMA idealization of MACs (move to MAC?)
let mac1 i = mac_log && mac_int1cma (mac_of_id i)

// controls abstraction of plaintexts
// (kept abstract, but requires all the crypto steps above)
val safeId: i:id -> Tot bool


(* IDEALIZATION DEPENDENCIES *) 

// review usage of these lemmas

val mac1_implies_mac_log: i:id -> Lemma
  (requires (mac1 i))
  (ensures mac_log)
  [SMTPat (mac1 i)]

val mac1_implies_prf: i:id -> Lemma
  (requires (mac1 i))
  (ensures (prf i))
  [SMTPat (mac1 i)]

val safeId_implies_mac1: i:id -> Lemma
  (requires (safeId i))
  (ensures (mac1 i))
  [SMTPat (safeId i)]

val safeId_implies_cpa: i:id -> Lemma
  (requires (safeId i))
  (ensures (prf_cpa))
  [SMTPat (safeId i)]


