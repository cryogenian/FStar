module Crypto.Symmetric.Bytes

open FStar.HyperHeap
open FStar.HyperStack
open FStar.UInt32
open FStar.Ghost
open FStar.Buffer
open FStar.Mul
open FStar.Int.Cast

open Buffer.Utils
 
type mem = FStar.HyperStack.mem

let u8  = UInt8.t
let u32 = UInt32.t
let u64 = UInt64.t

// TODO: rename and move to FStar.Buffer
// bytes  -> uint8_s; lbytes  -> uint8_sl
// buffer -> uint8_p; lbuffer -> uint8_sl

type bytes = Seq.seq UInt8.t // Currently, Buffer.Utils redefines this as buffer
type buffer = Buffer.buffer UInt8.t

type lbytes  (l:nat) = b:bytes  {Seq.length b = l}
type lbuffer (l:nat) = b:buffer {Buffer.length b = l}

let uint128_to_uint8 (a:UInt128.t) : Tot (b:UInt8.t{UInt8.v b = UInt128.v a % pow2 8})
  = uint64_to_uint8 (uint128_to_uint64 a)

private let hex1 (x:UInt8.t {FStar.UInt8(x <^ 16uy)}) = 
  FStar.UInt8(
    if x <^ 10uy then UInt8.to_string x else 
    if x = 10uy then "a" else 
    if x = 11uy then "b" else 
    if x = 12uy then "c" else 
    if x = 13uy then "d" else 
    if x = 14uy then "e" else "f")
private let hex2 x = 
  FStar.UInt8(hex1 (x /^ 16uy) ^ hex1 (x %^ 16uy))

val print_buffer: s:buffer -> i:UInt32.t{UInt32.v i <= length s} -> len:UInt32.t{UInt32.v len <= length s} -> Stack unit
  (requires (fun h -> live h s))
  (ensures (fun h0 _ h1 -> h0 == h1))
let rec print_buffer s i len =
  let open FStar.UInt32 in
  if i <^ len then
    let b = Buffer.index s i in
    let sep = if i %^ 16ul =^ 15ul || i +^ 1ul = len then "\n" else " " in
    let _ = IO.debug_print_string (hex2 b ^ sep) in
    let _ = print_buffer s (i +^ 1ul) len in
    ()

// TODO: Deprecate?
val sel_bytes: h:mem -> l:UInt32.t -> buf:lbuffer (v l){Buffer.live h buf}
  -> GTot (lbytes (v l))
let sel_bytes h l buf = Buffer.as_seq h buf

// Should be polymorphic on the integer size
// This will be leaky (using implicitly the heap)
// TODO: We should isolate it in a different module, e.g. Buffer.Alloc
val load_bytes: l:UInt32.t -> buf:lbuffer (v l) -> Stack (lbytes (v l))
  (requires (fun h0 -> Buffer.live h0 buf))
  (ensures  (fun h0 r h1 -> h0 == h1 /\ Buffer.live h0 buf /\
		         Seq.equal r (sel_bytes h1 l buf)))
let rec load_bytes l buf = 
  if l = 0ul then
    Seq.createEmpty
  else
    let b = Buffer.index buf 0ul in
    let t = load_bytes (l -^ 1ul) (Buffer.sub buf 1ul (l -^ 1ul)) in
    SeqProperties.cons b t

private val store_bytes_aux: len:UInt32.t -> buf:lbuffer (v len)
  -> i:UInt32.t{i <=^ len} -> b:lbytes (v len) -> ST unit
  (requires (fun h0 -> Buffer.live h0 buf /\
    Seq.equal (Seq.slice b 0 (v i)) (sel_bytes h0 i (Buffer.sub buf 0ul i))))
  (ensures  (fun h0 r h1 -> Buffer.live h1 buf /\ Buffer.modifies_1 buf h0 h1 /\
    Seq.equal b (sel_bytes h1 len buf)))
let rec store_bytes_aux len buf i b =
  if i <^ len then
    begin
    Buffer.upd buf i (Seq.index b (v i));
    let h = ST.get () in
    assert (Seq.equal
      (sel_bytes h (i +^ 1ul) (Buffer.sub buf 0ul (i +^ 1ul)))
      (SeqProperties.snoc (sel_bytes h i (Buffer.sub buf 0ul i)) (Seq.index b (v i))));
    store_bytes_aux len buf (i +^ 1ul) b
    end

val store_bytes: l:UInt32.t -> buf:lbuffer (v l) -> b:lbytes (v l) -> ST unit
  (requires (fun h0 -> Buffer.live h0 buf))
  (ensures  (fun h0 r h1 -> Buffer.live h1 buf /\ Buffer.modifies_1 buf h0 h1 /\
    Seq.equal b (sel_bytes h1 l buf)))
let store_bytes l buf b = store_bytes_aux l buf 0ul b

// TODO: Dummy.
// Should be external and relocated in some library with a crypto-grade
// implementation in both OCaml and KreMLin,
val random: len:nat -> b:lbuffer len -> Stack unit
  (requires (fun h -> live h b))
  (ensures  (fun h0 _ h1 -> live h1 b /\ modifies_1 b h0 h1))
let random len b = ()

val random_bytes: len:u32 -> Stack (lbytes (v len))
  (requires (fun m -> True))
  (ensures  (fun m0 _ m1 -> modifies Set.empty m0 m1))
let random_bytes len =
  push_frame ();
  let m0 = ST.get () in
  let buf = Buffer.create 0uy len in
  let m1 = ST.get () in
  lemma_reveal_modifies_0 m0 m1;
  Bytes.random (v len) buf;
  let m2 = ST.get () in
  lemma_reveal_modifies_1 buf m1 m2;
  let b = load_bytes len buf in
  pop_frame ();
  b


open FStar.SeqProperties

(* Little endian integer value of a sequence of bytes *)
let rec little_endian (b:bytes) : Tot (n:nat) (decreases (Seq.length b)) =
  if Seq.length b = 0 then 0
  else
    UInt8.v (head b) + pow2 8 * little_endian (tail b)

(* Big endian integer value of a sequence of bytes *)
let rec big_endian (b:bytes) : Tot (n:nat) (decreases (Seq.length b)) = 
  if Seq.length b = 0 then 0 
  else
    UInt8.v (last b) + pow2 8 * big_endian (Seq.slice b 0 (Seq.length b - 1))

#reset-options "--initial_fuel 1 --max_fuel 1"

val little_endian_null: len:nat{len < 16} -> Lemma
  (little_endian (Seq.create len 0uy) == 0)
let rec little_endian_null len =
  if len = 0 then ()
  else
    begin
    Seq.lemma_eq_intro (Seq.slice (Seq.create len 0uy) 1 len)
		       (Seq.create (len - 1) 0uy);
    assert (little_endian (Seq.create len 0uy) ==
      0 + pow2 8 * little_endian (Seq.slice (Seq.create len 0uy) 1 len));
    little_endian_null (len - 1)
    end

val little_endian_singleton: n:UInt8.t -> Lemma
  (little_endian (Seq.create 1 n) == UInt8.v n)
let little_endian_singleton n =
  assert (little_endian (Seq.create 1 n) ==
    UInt8.v (Seq.index (Seq.create 1 n) 0) + pow2 8 *
    little_endian (Seq.slice (Seq.create 1 n) 1 1))

val little_endian_append: w1:bytes -> w2:bytes -> Lemma
  (requires True)
  (ensures
    little_endian (Seq.append w1 w2) ==
    little_endian w1 + pow2 (8 * Seq.length w1) * little_endian w2)
  (decreases (Seq.length w1))
let rec little_endian_append w1 w2 =
  let open FStar.Seq in
  if length w1 = 0 then
    begin
    assert_norm (pow2 (8 * 0) == 1);
    Seq.lemma_eq_intro (append w1 w2) w2
    end
  else
    begin
    let w1' = slice w1 1 (length w1) in
    assert (length w1' == length w1 - 1);
    little_endian_append w1' w2;
    assert (index (append w1 w2) 0 == index w1 0);
    Seq.lemma_eq_intro
      (append w1' w2)
      (Seq.slice (append w1 w2) 1 (length (append w1 w2)));
    assert (little_endian (append w1 w2) ==
      UInt8.v (index w1 0) + pow2 8 * little_endian (append w1' w2));
    assert (little_endian (append w1' w2) ==
      little_endian w1' + pow2 (8 * length w1') * little_endian w2);
    assert (UInt8.v (index w1 0) + pow2 8 * little_endian (append w1' w2) ==
      UInt8.v (index w1 0) +
      pow2 8 * (little_endian w1' + pow2 (8 * length w1') * little_endian w2));
    Math.Lemmas.pow2_plus 8 (8 * (length w1 - 1));
    assert (pow2 8 * pow2 (8 * length w1') == pow2 (8 * length w1));
    assert (UInt8.v (index w1 0) + pow2 8 * little_endian (append w1' w2) ==
      UInt8.v (index w1 0) +
      pow2 8 * little_endian w1' + pow2 (8 * length w1) * little_endian w2);
    assert (UInt8.v (index w1 0) + pow2 8 * little_endian w1' == little_endian w1)
    end

private val lemma_factorise: a:nat -> b:nat -> Lemma (a + a * b = a * (b + 1))
let lemma_factorise a b = ()

val lemma_little_endian_is_bounded: b:bytes -> Lemma
  (requires True)
  (ensures  (little_endian b < pow2 (8 * Seq.length b)))
  (decreases (Seq.length b))
let rec lemma_little_endian_is_bounded b =
  if Seq.length b = 0 then ()
  else
    begin
    let s = Seq.slice b 1 (Seq.length b) in
    assert(Seq.length s = Seq.length b - 1);
    lemma_little_endian_is_bounded s;
    assert(UInt8.v (Seq.index b 0) < pow2 8);
    assert(little_endian s < pow2 (8 * Seq.length s));
    assert(little_endian b < pow2 8 + pow2 8 * pow2 (8 * (Seq.length b - 1)));
    lemma_euclidean_division (UInt8.v (Seq.index b 0)) (little_endian s) (pow2 8);
    assert(little_endian b <= pow2 8 * (little_endian s + 1));
    assert(little_endian b <= pow2 8 * pow2 (8 * (Seq.length b - 1)));
    Math.Lemmas.pow2_plus 8 (8 * (Seq.length b - 1));
    lemma_factorise 8 (Seq.length b - 1)
    end

val lemma_big_endian_is_bounded: b:bytes -> Lemma
  (requires True)
  (ensures  (big_endian b < pow2 (8 * Seq.length b)))
  (decreases (Seq.length b))
  [SMTPat (big_endian b)]
let rec lemma_big_endian_is_bounded b =
  if Seq.length b = 0 then ()
  else
    begin
    let s = Seq.slice b 0 (Seq.length b - 1) in
    assert(Seq.length s = Seq.length b - 1);
    lemma_big_endian_is_bounded s;
    assert(UInt8.v (SeqProperties.last b) < pow2 8);
    assert(big_endian s < pow2 (8 * Seq.length s));
    assert(big_endian b < pow2 8 + pow2 8 * pow2 (8 * (Seq.length b - 1)));
    lemma_euclidean_division (UInt8.v (SeqProperties.last b)) (big_endian s) (pow2 8);
    assert(big_endian b <= pow2 8 * (big_endian s + 1));
    assert(big_endian b <= pow2 8 * pow2 (8 * (Seq.length b - 1)));
    Math.Lemmas.pow2_plus 8 (8 * (Seq.length b - 1));
    lemma_factorise 8 (Seq.length b - 1)
    end

#reset-options "--initial_fuel 0 --max_fuel 0"

val lemma_little_endian_lt_2_128: b:bytes {Seq.length b <= 16} -> Lemma
  (requires True)
  (ensures  (little_endian b < pow2 128))
  [SMTPat (little_endian b)]
let lemma_little_endian_lt_2_128 b =
  lemma_little_endian_is_bounded b;
  if Seq.length b = 16 then ()
  else Math.Lemmas.pow2_lt_compat 128 (8 * Seq.length b)


#reset-options "--z3timeout 20 --max_fuel 1 --initial_fuel 1" 

(* REMARK: The trigger in lemma_little_endian_lt_2_128 is used to prove absence of
   overflow *)
(** Loads a machine integer from a buffer of len bytes *)
val load_uint32: len:UInt32.t { v len <= 4 } -> buf:lbuffer (v len) -> ST UInt32.t
  (requires (fun h0 -> live h0 buf))
  (ensures (fun h0 n h1 -> 
    h0 == h1 /\ live h0 buf /\ 
    UInt32.v n == little_endian (sel_bytes h1 len buf)))
let rec load_uint32 len buf = 
  if len = 0ul then 0ul
  else
    let len = len -^ 1ul in
    let n = load_uint32 len (sub buf 1ul len) in
    let b = buf.(0ul) in
    assert_norm (pow2 8 == 256);
    FStar.UInt32(uint8_to_uint32 b +^ 256ul *^ n)

val load_big32: len:UInt32.t { v len <= 4 } -> buf:lbuffer (v len) -> ST UInt32.t
  (requires (fun h0 -> live h0 buf))
  (ensures (fun h0 n h1 -> 
    h0 == h1 /\ live h0 buf /\ 
    UInt32.v n == big_endian (sel_bytes h1 len buf)))
let rec load_big32 len buf = 
  if len = 0ul then 0ul
  else
    let len = len -^ 1ul in
    let n = load_big32 len (sub buf 0ul len) in
    let b = buf.(len) in
    assert_norm (pow2 8 == 256);
    FStar.UInt32(uint8_to_uint32 b +^ 256ul *^ n)

(** Used e.g. for converting TLS sequence numbers into AEAD nonces *)
#reset-options "--z3timeout 100"
val load_big64: len:UInt32.t { v len <= 8 } -> buf:lbuffer (v len) -> ST UInt64.t
  (requires (fun h0 -> live h0 buf))
  (ensures (fun h0 n h1 -> 
    h0 == h1 /\ live h0 buf /\ 
    UInt64.v n == big_endian (sel_bytes h1 len buf)))
let rec load_big64 len buf = 
  if len = 0ul then 0UL
  else
    let len = len -^ 1ul in
    let n = load_big64 len (sub buf 0ul len) in
    let b = buf.(len) in
    assert_norm (pow2 8 == 256);
    FStar.UInt64(uint8_to_uint64 b +^ 256UL *^ n)


(* TODO: Add to FStar.Int.Cast and Kremlin and OCaml implementations *)
val uint8_to_uint128: a:UInt8.t -> Tot (b:UInt128.t{UInt128.v b = UInt8.v a})
let uint8_to_uint128 a = uint64_to_uint128 (uint8_to_uint64 a)

val load_uint128: len:UInt32.t { v len <= 16 } -> buf:lbuffer (v len) -> ST UInt128.t
  (requires (fun h0 -> live h0 buf))
  (ensures (fun h0 n h1 -> 
    h0 == h1 /\ live h0 buf /\ 
    UInt128.v n == little_endian (sel_bytes h1 len buf)))
let rec load_uint128 len buf = 
  if len = 0ul then uint64_to_uint128 0UL // Need 128-bit constants?
  else
    let n = load_uint128 (len -^ 1ul) (sub buf 1ul (len -^ 1ul)) in
    let b = buf.(0ul) in 
    let h = ST.get () in
    lemma_little_endian_is_bounded 
      (sel_bytes h (len -^ 1ul) (sub buf 1ul (len -^ 1ul)));
    assert (UInt128.v n <= pow2 (8 * v len - 8) - 1);
    assert (256 * UInt128.v n <= 256 * pow2 (8 * v len - 8) - 256);
    assert_norm (256 * pow2 (8 * 16 - 8) - 256 <= pow2 128 - 256);
    Math.Lemmas.pow2_le_compat (8 * 16 - 8) (8 * v len - 8);
    assert (256 * pow2 (8 * v len - 8) - 256 <= pow2 128 - 256);
    FStar.UInt128(uint8_to_uint128 b +^ uint64_to_uint128 256UL *^ n) 

(* stores a machine integer into a buffer of len bytes *)
// 16-10-02 subsumes Buffer.Utils.bytes_of_uint32 ?
// check efficient compilation for all back-ends
val store_uint32: 
  len:UInt32.t {v len <= 4} -> buf:lbuffer (v len) -> 
  n:UInt32.t {UInt32.v n < pow2 (8 * v len)} -> ST unit
  (requires (fun h0 -> Buffer.live h0 buf))
  (ensures (fun h0 r h1 -> 
    Buffer.live h1 buf /\ Buffer.modifies_1 buf h0 h1 /\
    UInt32.v n == little_endian (sel_bytes h1 len buf)))
let rec store_uint32 len buf n = 
  if len <> 0ul then
    let len = len -^ 1ul in 
    let b = uint32_to_uint8 n in
    let n' = FStar.UInt32(n >>^ 8ul) in 
    assert(v n = UInt8.v b + 256 * v n');
    let buf' = Buffer.sub buf 1ul len in
    Math.Lemmas.pow2_plus 8 (8 * v len);
    assert_norm (pow2 8 == 256);
    store_uint32 len buf' n';
    buf.(0ul) <- b // updating after the recursive call helps verification

val uint32_bytes: 
  len:UInt32.t {v len <= 4} -> n:UInt32.t {UInt32.v n < pow2 (8 * v len)} -> 
  Tot (b:lbytes (v len) { UInt32.v n = little_endian b}) (decreases (v len))
let rec uint32_bytes len n = 
  if len = 0ul then 
    let e = Seq.createEmpty #UInt8.t in
    assert_norm(0 = little_endian e);
    e
  else
    let len = len -^ 1ul in 
    let byte = uint32_to_uint8 n in
    let n' = FStar.UInt32(n >>^ 8ul) in 
    assert(v n = UInt8.v byte + 256 * v n');
    Math.Lemmas.pow2_plus 8 (8 * v len);
    assert_norm (pow2 8 == 256);
    assert(v n' < pow2 (8 * v len ));
    let b' = uint32_bytes len n'
    in 
    SeqProperties.cons byte b'


// check efficient compilation for all back-ends
val store_uint128: 
  len:UInt32.t {v len <= 16} -> buf:lbuffer (v len) -> 
  n:UInt128.t {UInt128.v n < pow2 (8 * v len)} -> ST unit
  (requires (fun h0 -> Buffer.live h0 buf))
  (ensures (fun h0 r h1 -> 
    Buffer.live h1 buf /\ Buffer.modifies_1 buf h0 h1 /\
    UInt128.v n = little_endian (sel_bytes h1 len buf))) 
let rec store_uint128 len buf n = 
  if len <> 0ul then
    let len = len -^ 1ul in 
    let b = uint128_to_uint8 n in
    let n' = FStar.UInt128(n >>^ 8ul) in 
    assert(UInt128.v n = UInt8.v b + 256 * UInt128.v n');
    let buf' = Buffer.sub buf 1ul len in
    Math.Lemmas.pow2_plus 8 (8 * v len);
    assert_norm (pow2 8 == 256);
    store_uint128 len buf' n';
    buf.(0ul) <- b // updating after the recursive call helps verification
