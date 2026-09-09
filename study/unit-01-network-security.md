# Unit I — Introduction to Network Security

**6 lectures · mid-sem scope · maps to CO1**

Sources: `slides/ch01.md` (models, X.800, attack taxonomy) and `slides/ch10.md`
(Diffie-Hellman). **TCP/IP stack, implementation layers and IPsec are not in any
deck** — those sections are written from TB1 (Stallings 8e) and are marked ⚠.

---

## 1. Definitions

| Term | Meaning |
|---|---|
| **Computer security** | Generic name for the collection of tools designed to protect data and thwart hackers |
| **Network security** | Measures to protect data *during their transmission* |
| **Internet security** | Measures to protect data during transmission over a *collection of interconnected networks* |

Boundaries between the three are blurred. The course focus is Internet security:
measures to **deter, prevent, detect and correct** security violations involving
the transmission and storage of information.

## 2. OSI Security Architecture (ITU-T X.800)

X.800, *"Security Architecture for OSI"*, gives a systematic way of defining
security requirements. It organises everything under **three headings** — a
guaranteed exam question:

```
                    OSI Security Architecture (X.800)
                                 |
        +------------------------+------------------------+
        |                        |                        |
  Security ATTACK        Security MECHANISM         Security SERVICE
  any action that        a process designed to      a processing/comms
  compromises the        detect, prevent or         service that enhances
  security of info       recover from an attack     security; counters
  owned by an org                                   attacks using >=1
                                                    mechanism
```

> RFC 2828 phrasing: a security service is *"a processing or communication
> service provided by a system to give a specific kind of protection to system
> resources"*. **Services implement security policies and are implemented by
> mechanisms.**

## 3. Security Attacks — passive vs active

The single most examinable table in Unit I.

| | **Passive attack** | **Active attack** |
|---|---|---|
| **Nature** | Eavesdrop / monitor; does **not** affect system resources | Alters system resources or affects operation |
| **Sub-types** | 1. Release of message contents<br>2. Traffic analysis | 1. Masquerade<br>2. Replay<br>3. Modification of messages<br>4. Denial of service |
| **Detection** | **Very hard** — no alteration of data | Comparatively easy |
| **Prevention** | Feasible (encryption) | **Very hard** — too many vulnerabilities |
| **Strategy** | **Prevent**, don't try to detect | **Detect and recover**, don't try to prevent absolutely |

**Memory hook:** passive → *prevention* is possible, detection isn't.
Active → *detection* is possible, prevention isn't. They are exact opposites.

- **Traffic analysis** is passive even though nothing is read in cleartext: the
  attacker observes *location, identity, frequency and length* of messages, and
  can infer the nature of the communication. Countermeasure: **traffic padding**.

## 4. Security Services (X.800)

Five classic categories (X.800 defines 14 specific services inside these):

| Service | Assurance provided |
|---|---|
| **Authentication** | The communicating entity is the one it claims to be. Two forms: *peer entity* authentication and *data origin* authentication |
| **Access control** | Prevention of unauthorised **use** of a resource |
| **Data confidentiality** | Protection of data from unauthorised **disclosure** (incl. traffic-flow confidentiality) |
| **Data integrity** | Data received is exactly as sent by an authorised entity — no modification, insertion, deletion or replay |
| **Non-repudiation** | Protection against **denial** by one party of having participated. *Origin* and *destination* variants |

*(X.800 also lists **availability** as a property/service — worth naming if the
question asks for security goals rather than X.800 categories, alongside the
classic **CIA triad**: Confidentiality, Integrity, Availability.)*

## 5. Security Mechanisms (X.800)

Learn the split — examiners ask "specific vs pervasive":

**Specific** (embedded in a *particular protocol layer*) — 8 of them:

> **Encipherment · Digital signature · Access control · Data integrity ·
> Authentication exchange · Traffic padding · Routing control · Notarization**

**Pervasive** (**not** specific to any layer) — 5 of them:

> **Trusted functionality · Security labels · Event detection ·
> Security audit trail · Security recovery**

No single mechanism supports all services, but **cryptographic techniques**
underlie most of them — which is why the course is built on cryptography.

## 6. Model for Network Security

```
        Trusted Third Party
     (e.g. arbiter, key distributor)
                  |
      secret info | secret info
       +----------+----------+
       |                     |
  +----v----+           +----v----+
  | Sender  |           |Recipient|
  |         |  message  |         |
  | Security|==========>| Security|
  | related |  channel  | related |
  |transform|           |transform|
  +---------+     ^     +---------+
                  |
              +---+---+
              |Opponent|
              +--------+
```

**Four basic tasks** when designing a security service with this model:

1. Design an **algorithm** for the security transformation
2. Generate the **secret information** (keys) used by it
3. Develop **methods to distribute and share** that secret information
4. Specify a **protocol** letting the principals use the transformation and
   secret information to achieve the service

## 7. Model for Network Access Security

```
                     +--------------------------------+
                     |     Information System         |
   Opponent          |  +--------------------------+  |
   - human           |  |  Computing resources     |  |
   - software  --->  |  |  (processor, memory, I/O)|  |
     (virus,         |  |  Data                    |  |
      worm)          |  |  Processes / Software    |  |
                     |  +--------------------------+  |
        ^            |   Internal security controls   |
        |            +--------------------------------+
        +----> Gatekeeper function ---^
               (login, screening logic)
```

**Two tasks:**

1. Select appropriate **gatekeeper functions** to identify users
2. Implement **internal security controls** so only authorised users reach
   designated information or resources

Trusted computer systems help implement this model.

**Contrast for the exam:** the *network security* model protects **data in
transit** across a channel; the *network access security* model protects
**resources on a system** from unwanted access. Different threats, different
controls.

## 8. ⚠ TCP/IP protocol stack

*Not in any deck — from TB1.*

| Layer | Function | Example security protocol |
|---|---|---|
| **Application** | End-user services | PGP, S/MIME, Kerberos, HTTPS content |
| **Transport** | End-to-end delivery, TCP/UDP | **SSL/TLS** |
| **Internet (Network)** | Routing, addressing, IP | **IPsec** |
| **Network access / Link** | Frame transmission on one hop | WPA2/WPA3, MACsec |
| **Physical** | Bits on the medium | — |

## 9. ⚠ Implementation layers for security protocols — and the implications

*Not in any deck — from TB1. A classic "discuss the trade-off" question.*

| Placed at | Example | Advantages | Implications / drawbacks |
|---|---|---|---|
| **Application** | PGP, S/MIME, Kerberos | True **end-to-end**; per-user granularity; app understands the data's meaning | Must **modify every application**; security logic duplicated per app |
| **Transport** | SSL/TLS | No change to the app's own protocol; protects whole TCP session; widely deployed | Only protects **TCP**, not UDP/ICMP; app must be TLS-aware to open the socket |
| **Network** | **IPsec** | **Transparent to applications and users**; protects *all* traffic incl. routing; deploy once at a gateway | **No per-user granularity** (per-host/per-SA); breaks **NAT**; end systems must trust the gateway |
| **Data link** | WPA2, MACsec, PPTP/L2TP | Fast, hardware-assisted; protects the link completely | **Per-hop only, not end-to-end** — data is in clear at every intermediate node |

**The general trade-off:** the *higher* the layer, the more **granular and
end-to-end** the protection, but the more **application changes** required. The
*lower* the layer, the more **transparent and general**, but the **coarser** the
protection.

## 10. Diffie–Hellman key exchange

From `slides/ch10.md` (slides 14–19). First published public-key scheme,
Diffie & Hellman 1976. *(Williamson at UK CESG had secretly proposed the concept
in 1970, declassified 1987.)*

**It is a key-distribution scheme only** — it establishes a **shared secret**
between two parties. It **cannot be used to exchange an arbitrary message**.

**Setup (public):** a prime `q`, and `α` a **primitive root** of `q`.

| Step | Alice | Bob |
|---|---|---|
| Private key | choose `xA < q` | choose `xB < q` |
| Public key | `yA = α^xA mod q` | `yB = α^xB mod q` |
| Exchange | send `yA` → | ← send `yB` |
| Shared key | `K = yB^xA mod q` | `K = yA^xB mod q` |

Both arrive at the same value because

```
K = α^(xA · xB) mod q
```

**Security** rests on the **discrete logarithm problem**: exponentiation mod q is
easy, but recovering `x` from `α^x mod q` is computationally infeasible for large
`q`.

**Worked example (Stallings):** `q = 353`, `α = 3`, `xA = 97`, `xB = 233`

- `yA = 3^97 mod 353 = 40`
- `yB = 3^233 mod 353 = 248`
- `K = 248^97 mod 353 = 40^233 mod 353 = **160**`

**⚠ Critical weakness — man-in-the-middle.** Plain D-H is **unauthenticated**.
Darth can intercept `yA` and `yB`, substitute his own, and establish one shared
key with Alice and a different one with Bob, relaying and reading everything.
**Fix:** authenticate the public values — digital signatures, certificates, or
station-to-station protocol.

*Note:* if Alice and Bob communicate again they derive the **same** key unless
they choose new public keys — hence ephemeral D-H (DHE) for forward secrecy.

## 11. ⚠ IPsec — AH, ESP and IKE

*Not in any deck — from TB1. Directly named in CO1, so expect a question.*

IPsec secures traffic at the **network layer**, making it transparent to
applications. Used for VPNs, branch-office connectivity and remote access.

### Security Association (SA)

A **one-way (simplex)** logical relationship between sender and receiver. Two SAs
are needed for bidirectional traffic. Uniquely identified by a **triple**:

> **SPI** (Security Parameters Index) · **destination IP address** ·
> **security protocol identifier** (AH or ESP)

Stored in the **SAD** (SA Database); policy about what to protect lives in the
**SPD** (Security Policy Database).

### The two protocols

| | **AH** — Authentication Header | **ESP** — Encapsulating Security Payload |
|---|---|---|
| IP protocol no. | **51** | **50** |
| Confidentiality (encryption) | ❌ **No** | ✅ Yes |
| Integrity + data-origin authentication | ✅ Yes | ✅ Optional (in practice always used) |
| Anti-replay | ✅ Yes | ✅ Yes |
| Covers outer IP header? | ✅ Yes — authenticates **immutable** IP header fields | ❌ No |
| Works through **NAT**? | ❌ **Breaks** — NAT rewrites the IP header AH protects | ⚠ Needs **NAT-T** (UDP 4500 encapsulation) |
| Status | Largely **deprecated** in favour of ESP | Dominant in practice |

**Why ESP won:** it does everything AH does *plus* encryption, and it survives
NAT. AH's only edge is authenticating the outer IP header.

### The two modes

| | **Transport mode** | **Tunnel mode** |
|---|---|---|
| Protects | IP **payload** only | The **entire original IP packet** |
| IP header | Original header kept | **New outer IP header** added |
| Typical use | **End-to-end**, host-to-host | **Gateway-to-gateway VPN**, site-to-site |
| Traffic-flow confidentiality | ❌ No — original addresses visible | ✅ Yes — real endpoints hidden |

```
Original:            [ IP hdr | TCP hdr | Data ]

ESP transport:       [ IP hdr | ESP | TCP hdr | Data | ESP trl | ESP auth ]
                                     <------ encrypted ------>
                               <-------- authenticated ------>

ESP tunnel:  [ new IP hdr | ESP | IP hdr | TCP hdr | Data | ESP trl | ESP auth ]
                                 <--------- encrypted --------->
                           <---------- authenticated ---------->
```

**Anti-replay** works via a monotonically increasing **sequence number** plus a
**sliding receive window** (default 64); duplicates and too-old packets are
dropped.

### IKE — Internet Key Exchange

IPsec needs keys; **IKE** negotiates them automatically (the alternative is
unmanageable manual keying). Runs over **UDP port 500** (500 + **4500** with
NAT-T). Built from three components:

- **ISAKMP** — the generic framework/message formats for negotiation
- **Oakley** — the key-determination protocol, based on **Diffie–Hellman**
- **SKEME** — key-exchange techniques

**IKEv1 runs in two phases:**

| Phase | Purpose | Modes |
|---|---|---|
| **Phase 1** | Mutually authenticate the peers and set up a secure channel — the **IKE SA** | **Main mode** (6 messages, identity protected) or **Aggressive mode** (3 messages, faster, identity exposed) |
| **Phase 2** | Under that protection, negotiate the actual **IPsec SAs** (for AH/ESP) | **Quick mode** (3 messages) |

**IKEv2** (RFC 7296) replaces this with a single 4-message exchange, adds
built-in NAT traversal, EAP support and DoS protection via **cookies**.

IKE inherits D-H's properties: it gets **perfect forward secrecy** when a fresh
D-H exchange is run per session, and it must **authenticate** the exchange
(pre-shared key, RSA signature or certificate) to defeat man-in-the-middle.

---

## Unit I — likely exam targets

1. Passive vs active attacks, with the four active sub-types *(near-certain)*
2. X.800 security services and the specific/pervasive mechanism split
3. Both models — draw and state the tasks for each
4. Diffie–Hellman numerical problem + the MITM weakness
5. AH vs ESP, transport vs tunnel mode comparison tables
6. "At which layer should security be implemented?" trade-off discussion
