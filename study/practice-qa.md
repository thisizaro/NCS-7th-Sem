# NCS Mid-Semester — Practice Questions with Model Answers

Covers **Unit I and Unit II only** (mid-sem scope, 20 marks).
Attempt each before reading the answer. Answers are written at the length the
mark value expects.

---

# Section A — Short answer (2 marks each)

### A1. Distinguish between a threat and an attack.
A **threat** is a *potential* danger — a circumstance or event with the capability
to cause harm by exploiting a vulnerability. An **attack** is the *realisation*
of that threat: a deliberate act that actually attempts to violate security.
Threat = possibility; attack = action.

### A2. Why are passive attacks hard to detect but easy to prevent?
They involve **no alteration of data** — the attacker only eavesdrops — so there
is no observable anomaly in the traffic to detect. They are preventable because
**encryption** renders the captured data useless without ever needing to notice
the attacker.

### A3. Name the two categories of security mechanism in X.800 and the difference.
**Specific** security mechanisms are implemented within a **particular protocol
layer** (encipherment, digital signature, access control, data integrity,
authentication exchange, traffic padding, routing control, notarization).
**Pervasive** mechanisms are **not specific to any layer** (trusted
functionality, security labels, event detection, security audit trail, security
recovery).

### A4. What is traffic analysis, and which mechanism counters it?
Observing the **pattern** of communication — identities, location, frequency and
message length — to infer information even when contents are encrypted. It is a
**passive** attack, countered by **traffic padding** (generating filler traffic
to mask real patterns).

### A5. Why can Diffie–Hellman not be used to send an arbitrary message?
D-H is a **key-agreement** scheme: the value both parties compute is determined
by their private and public values, so **neither party can choose it**. It
establishes a shared secret for later symmetric encryption, but cannot transport
chosen plaintext.

### A6. State the triple that uniquely identifies an IPsec Security Association.
**SPI** (Security Parameters Index), the **destination IP address**, and the
**security protocol identifier** (AH or ESP). An SA is **one-way**, so two are
needed for bidirectional communication.

### A7. Give one reason ESP has largely replaced AH.
ESP provides **confidentiality (encryption)** in addition to integrity and
authentication, whereas AH provides no encryption at all. ESP also survives
**NAT** (with NAT-T), while AH breaks because NAT rewrites the IP header fields
AH authenticates.

### A8. Differentiate DoS from DDoS.
**DoS** originates from a **single source**, so it can be blocked by filtering
one address and is limited by that host's bandwidth. **DDoS** uses **many
compromised hosts (zombies/botnet)** simultaneously, making it far higher volume,
much harder to filter, and difficult to trace to the true attacker.

### A9. Why is fibre-optic cable more secure than copper?
Copper radiates **electromagnetic interference** that can be captured remotely
and can be **inductively tapped** without cutting it. Fibre carries light, emits
no EMI, and must be physically **bent or spliced** to tap — which causes
detectable signal loss.

### A10. What single property makes honeypot alerts so reliable?
A honeypot has **no production value**, so no legitimate user or process has any
reason to contact it. Therefore **any interaction is inherently suspicious**,
giving an extremely low **false-positive** rate.

### A11. Define false positive and false negative for an IDS.
A **false positive** is benign activity incorrectly flagged as an attack, causing
wasted effort and alert fatigue. A **false negative** is a **genuine attack that
goes undetected** — the more dangerous of the two, since it creates false
confidence.

### A12. Why is ARP inherently vulnerable to poisoning?
ARP is **stateless and unauthenticated**. A host caches **any** ARP reply it
receives — including **gratuitous** replies it never requested — with no way to
verify that the sender legitimately owns the claimed IP address.

---

# Section B — Medium answer (5 marks each)

### B1. Compare passive and active attacks, listing sub-types of each.

| Basis | Passive attack | Active attack |
|---|---|---|
| Definition | Attempts to **learn or use** information without affecting resources | Attempts to **alter** resources or affect operation |
| Sub-types | Release of message contents; traffic analysis | Masquerade; replay; modification of messages; denial of service |
| Data modified? | No | Yes |
| Detection | Very difficult | Comparatively easy |
| Prevention | Feasible (encryption) | Very difficult |
| Emphasis | **Prevention** | **Detection and recovery** |

The two are **exact opposites**: passive attacks are hard to detect but
preventable; active attacks are hard to prevent absolutely — because of the huge
range of physical, software and network vulnerabilities — so the goal shifts to
detecting them and recovering from the disruption they cause.

### B2. Explain the Model for Network Security and the four tasks it implies.

Two principals exchange a message across an **insecure channel** watched by an
opponent. Each applies a **security-related transformation** (e.g. encryption)
using **secret information** (a key), possibly distributed by a **trusted third
party** acting as arbiter or key distributor.

Designing any service on this model requires four tasks:

1. Design an **algorithm** for the security transformation that an opponent
   cannot defeat
2. **Generate the secret information** (keys) used by that algorithm
3. Develop **methods to distribute and share** that secret information securely
4. Specify a **protocol** by which the principals use the algorithm and the
   secret information to achieve the security service

Contrast with the **network access security** model, which protects **resources
on a system** using a **gatekeeper function** plus **internal controls**, rather
than protecting data in transit.

### B3. Explain the SYN flood attack and how SYN cookies defeat it.

**Attack.** The attacker sends a stream of TCP **SYN** segments with **spoofed**
source addresses. For each, the server allocates a Transmission Control Block,
replies **SYN/ACK**, and holds a **half-open** connection in its backlog queue
awaiting the final ACK. Because the source is forged, that ACK never arrives.
The backlog fills, and the server **refuses legitimate connections** — a
resource-exhaustion (protocol/state) attack rather than a bandwidth one.

**SYN cookies.** The server **allocates no state** on receiving a SYN. Instead it
encodes the connection parameters and a timestamp into a cryptographic hash used
as the **initial sequence number** in its SYN/ACK. If a genuine ACK returns, the
acknowledgement number contains that cookie; the server **recomputes and
validates it**, and only then builds the connection state. A flood of spoofed
SYNs therefore consumes **no memory at all**.

Other defences: larger backlog, shorter SYN timeout, SYN proxying, and ingress
filtering (BCP 38) to drop spoofed sources.

### B4. Distinguish DNS spoofing from DNS cache poisoning.

Both forge a DNS response, exploiting the fact that DNS runs over **UDP** with
**no authentication** — a reply is accepted if the transaction ID, source port
and question match.

- **DNS spoofing** — the attacker **races** the legitimate server with a forged
  reply to a specific query. If it arrives first and matches, the victim is
  redirected. It affects **that one lookup** only.
- **DNS cache poisoning** — the forged record is **written into the resolver's
  cache**, so **every client using that resolver** is redirected until the
  **TTL** expires. Far broader impact from a single success.

The **Kaminsky attack** made poisoning practical by querying random non-existent
subdomains and injecting a malicious **authority record** for the whole zone,
allowing unlimited retries against a 16-bit transaction ID.

**Defences:** source-port randomisation, 0x20 encoding, shorter TTLs, and
**DNSSEC** — cryptographic signing of records — which is the only complete fix.

### B5. Explain ARP poisoning and how it enables MITM on a switched network.

ARP resolves an IP address to a MAC address and is **stateless and
unauthenticated**. The attacker sends **forged ARP replies**:

1. To the **victim**: "the default gateway's IP is at *my* MAC"
2. To the **gateway**: "the victim's IP is at *my* MAC"

Both caches are poisoned, so all traffic between them is delivered to the
attacker, who enables **IP forwarding** and relays it — remaining transparent
while reading or modifying everything.

This matters because a **switch** normally forwards frames only to the correct
port, preventing sniffing. ARP poisoning defeats that by making the switch
*believe* the attacker's port is the correct destination.

**Consequences:** MITM, credential sniffing, session hijacking, and selective DoS
(mapping an IP to a non-existent MAC).

**Defences:** **Dynamic ARP Inspection** with **DHCP snooping** (the switch
validates ARP against a trusted binding table), static ARP entries for critical
hosts, port security, VLAN segmentation, and encryption so intercepted data is
useless.

### B6. What is a DMZ? Draw the dual-firewall design and state its traffic rules.

A **DMZ** is a **semi-trusted subnet** between the untrusted Internet and the
trusted internal network, hosting services that must be publicly reachable — web,
mail relay, external DNS, reverse proxies.

```
Internet ---[ Firewall 1 ]--- DMZ ---[ Firewall 2 ]--- Internal LAN
                            (web, mail,
                             DNS servers)
```

| Direction | Policy |
|---|---|
| Internet → DMZ | Permitted, only to specific published ports |
| Internet → Internal | **Denied** |
| Internal → DMZ | Permitted |
| **DMZ → Internal** | **Denied**, or a tightly restricted and logged exception |
| DMZ → Internet | Restricted to service requirements |

**Rationale:** the DMZ→Internal denial is the heart of the design — if a public
server is compromised, the attacker gains **no route into the internal network**.
The dual-firewall (screened subnet) form is stronger than a single three-legged
firewall because an attacker must defeat **two devices**, preferably from
**different vendors** so one vulnerability cannot breach both.

### B7. Compare IDS and IPS, and NIDS and HIDS.

| Basis | **IDS** | **IPS** |
|---|---|---|
| Placement | **Out-of-band** (tap/SPAN port) | **Inline** |
| Response | Detects and **alerts** — passive | **Blocks/drops** — active |
| Risk | Attack continues until a human responds | A false positive **blocks legitimate traffic**; device failure can break the link |

| Basis | **NIDS** | **HIDS** |
|---|---|---|
| Monitors | Traffic on a network **segment** | One **host**: logs, file integrity, processes, system calls |
| Coverage | Many hosts at once | Deep detail on a single host |
| Blind spot | **Encrypted payloads**; traffic not crossing it | Anything not involving that host |

**Key insight:** **HIPS** solves the NIDS encryption blind spot by inspecting data
on the endpoint **after TLS termination**, and can block malicious system calls
at the host.

### B8. Explain the two VLAN hopping attacks and their mitigations.

**1. Switch spoofing.** Many switch ports negotiate trunking automatically via
**DTP**. The attacker's device pretends to be a switch and negotiates a **trunk
link**, thereby receiving traffic for **all VLANs**.
*Mitigation:* disable dynamic trunking — `switchport mode access` and
`switchport nonegotiate` on all user ports.

**2. Double tagging.** The attacker crafts a frame with **two 802.1Q tags**. The
first switch strips the outer tag (which matches the **native VLAN**, carried
untagged) and forwards the frame; the next switch reads the **inner** tag and
delivers it into the **target VLAN**.
*Mitigation:* change the **native VLAN** to an unused ID, never use **VLAN 1**
for user traffic, and explicitly tag the native VLAN.

Note double tagging is **unidirectional** — the attacker can send into the target
VLAN but receives no replies — so it suits DoS or injection rather than MITM.

---

# Section C — Long answer (10 marks each)

### C1. Explain the OSI Security Architecture (X.800) in full.

*Structure your answer in four parts.*

**1. Purpose.** ITU-T Recommendation X.800 gives managers a **systematic way** to
define security requirements and to evaluate products and policies — a problem
that is hard in a centralised system and much harder across local and wide area
networks. It organises the field under three headings: **attacks, mechanisms and
services**.

**2. Security attacks** — any action compromising the security of information
owned by an organisation. Split into:
- **Passive** — release of message contents; traffic analysis. No data altered;
  hard to detect, feasible to prevent.
- **Active** — masquerade, replay, modification of messages, denial of service.
  Resources altered; hard to prevent, feasible to detect.

**3. Security services** — X.800 defines five categories (14 specific services):

| Service | Assurance |
|---|---|
| Authentication | The peer entity or data origin is who it claims to be |
| Access control | Prevention of unauthorised use of a resource |
| Data confidentiality | Protection from unauthorised disclosure |
| Data integrity | Data received is exactly as sent by an authorised entity |
| Non-repudiation | Neither party can deny having participated |

*(Availability is also treated as a security property.)*

**4. Security mechanisms** — the means of implementing services.
- **Specific** (layer-bound): encipherment, digital signature, access control,
  data integrity, authentication exchange, traffic padding, routing control,
  notarization
- **Pervasive** (not layer-specific): trusted functionality, security labels,
  event detection, security audit trail, security recovery

**Relationship to close on:** *services* implement **security policy** and are
themselves implemented by *mechanisms*; **no single mechanism** provides all
services, but **cryptographic techniques underlie most of them**.

### C2. Explain IPsec: architecture, AH vs ESP, the two modes, and IKE.

**Purpose.** IPsec provides security at the **network layer**, so protection is
**transparent to applications** and covers all IP traffic. Used for VPNs,
site-to-site links and remote access.

**Security Association.** A **one-way** logical relationship defining the
protection applied, identified by the triple **(SPI, destination IP, protocol)**.
Two SAs are required for bidirectional traffic. The **SAD** stores active SAs;
the **SPD** stores the policy deciding what is protected, bypassed or discarded.

**The two protocols.**

| | AH (proto 51) | ESP (proto 50) |
|---|---|---|
| Confidentiality | ✗ | ✓ |
| Integrity + origin authentication | ✓ | ✓ (optional, always used) |
| Anti-replay | ✓ | ✓ |
| Authenticates outer IP header | ✓ (immutable fields) | ✗ |
| NAT-friendly | ✗ breaks | ✓ with NAT-T |

**The two modes.**

- **Transport mode** protects only the **payload**, keeping the original IP
  header. Host-to-host, **end-to-end**.
- **Tunnel mode** encapsulates the **entire original packet** inside a **new
  outer IP header**. Gateway-to-gateway VPNs; also provides **traffic-flow
  confidentiality** because the real endpoints are hidden.

```
ESP tunnel:  [ new IP hdr | ESP | IP hdr | TCP hdr | Data | ESP trl | ESP auth ]
                                 <--------- encrypted --------->
                           <---------- authenticated ---------->
```

**Anti-replay** uses a monotonically increasing **sequence number** with a
**sliding receive window** (default 64), discarding duplicates and stale packets.

**IKE.** Manual keying does not scale, so **IKE** (UDP **500**, plus **4500** for
NAT-T) negotiates SAs automatically. It combines **ISAKMP** (message framework),
**Oakley** (key determination, based on **Diffie–Hellman**) and **SKEME**.

- **Phase 1** authenticates the peers and builds a protected channel — the **IKE
  SA** — via **main mode** (6 messages, identities protected) or **aggressive
  mode** (3 messages, faster, identities exposed).
- **Phase 2** uses that channel to negotiate the actual **IPsec SAs** in **quick
  mode** (3 messages).

**IKEv2** collapses this into a 4-message exchange with built-in NAT traversal,
EAP support and DoS protection via cookies. Because IKE is built on D-H, it must
**authenticate** the exchange (pre-shared key, RSA signature or certificate) to
prevent **man-in-the-middle**, and it achieves **perfect forward secrecy** when a
fresh D-H exchange is performed per session.

### C3. Describe five network-layer attacks and their countermeasures.

*Pick five and give mechanism + countermeasure for each — do not merely list.*

| Attack | Mechanism | Countermeasure |
|---|---|---|
| **ARP poisoning** | Forged unsolicited ARP replies bind the gateway's IP to the attacker's MAC, redirecting LAN traffic | **DAI** + DHCP snooping; static ARP; port security; encryption |
| **DNS cache poisoning** | Forged response accepted and cached by a resolver, redirecting all its clients until TTL expiry | **DNSSEC**; source-port randomisation; 0x20 encoding; restrict recursion |
| **TCP session hijacking** | Spoofed packet with the correct next sequence number desynchronises the real client and takes over an authenticated session | **Randomised ISNs**; encrypt the session (SSH/TLS/IPsec); short timeouts |
| **SYN flood** | Spoofed SYNs fill the backlog with half-open connections | **SYN cookies**; larger backlog; shorter timeout; ingress filtering |
| **Smurf** | ICMP echo to a **broadcast** address with the victim's spoofed source; all hosts reply to the victim | Disable **directed broadcasts**; ingress filtering; rate-limit ICMP |
| **MITM** | Attacker relays between two parties who believe they talk directly | **Mutual authentication**; TLS with certificate validation; HSTS; pinning |
| **VLAN hopping** | DTP trunk negotiation, or double 802.1Q tagging via the native VLAN | Disable DTP; change native VLAN; avoid VLAN 1 |

**Common thread to state in your conclusion:** every one of these exploits the
**absence of authentication** in the original TCP/IP design — the protocols were
built for a small trusted network. The general remedy is to **authenticate
identity cryptographically rather than trusting an address**, and to **encrypt**
so intercepted traffic has no value.

### C4. Discuss the layer at which security should be implemented, with trade-offs.

| Layer | Example | Advantages | Implications |
|---|---|---|---|
| **Application** | PGP, S/MIME, Kerberos | True **end-to-end**; per-user granularity; understands data semantics | Must modify **every application**; logic duplicated |
| **Transport** | SSL/TLS | Protects whole session; no change to app protocol; ubiquitous | **TCP only**; app must be TLS-aware |
| **Network** | **IPsec** | **Transparent to applications**; protects *all* traffic; deploy once at a gateway | **No per-user granularity**; breaks **NAT**; endpoints must trust the gateway |
| **Data link** | WPA2, MACsec | Fast, hardware-assisted; protects the entire link | **Per-hop only** — plaintext at every intermediate node |

**The trade-off to articulate:** moving *up* the stack gives **finer granularity
and genuine end-to-end protection**, at the cost of **modifying applications**.
Moving *down* gives **transparency and broad coverage**, at the cost of
**coarser control** and protection that may cover only one hop.

**Conclusion:** there is no single correct layer — **defence in depth** combines
them. A typical enterprise runs IPsec for site-to-site VPNs, TLS for
application sessions, and PGP/S/MIME where end-to-end message security must
survive intermediate servers.

---

# Section D — Numerical problems (Diffie–Hellman)

### D1. `q = 23`, `α = 5`, Alice's private `xA = 6`, Bob's private `xB = 15`.
Find both public keys and the shared secret.

**Solution**

- `yA = 5^6 mod 23 = 15625 mod 23 = **8**`
- `yB = 5^15 mod 23 = **19**`
  *(5² = 2, 5⁴ = 4, 5⁸ = 16; 5¹⁵ = 5⁸·5⁴·5²·5¹ = 16·4·2·5 = 640 mod 23 = 19)*
- Alice computes `K = yB^xA mod 23 = 19^6 mod 23`.
  Since `19 ≡ −4 (mod 23)`, `(−4)^6 = 4^6 = 4096`, and `4096 mod 23 = **2**`
- Bob computes `K = yA^xB mod 23 = 8^15 mod 23 = 2^45 mod 23`.
  Since `2^11 = 2048 ≡ 1 (mod 23)`, `2^45 = (2^11)^4 · 2 ≡ **2**` ✓

**Shared secret K = 2.**

### D2. `q = 11`, `α = 2`, `xA = 9`, `xB = 4`.

**Solution**

- Verify `2` is a primitive root of 11: its powers give 2, 4, 8, 5, 10, 9, 7, 3,
  6, 1 — all ten non-zero residues. ✓
- `yA = 2^9 mod 11 = 512 mod 11 = **6**`
- `yB = 2^4 mod 11 = **5**`
- `K = yB^xA = 5^9 mod 11 = **9**`
  *(5² = 3, 5⁴ = 9, 5⁸ = 4; 5⁹ = 4·5 = 20 mod 11 = 9)*
- Check: `K = yA^xB = 6^4 mod 11 = 1296 mod 11 = **9**` ✓

**Shared secret K = 9.**

### D3. Follow-up (frequently asked): is this exchange secure? Justify.

**No — not on its own.** The mathematics resists a **passive** eavesdropper, who
would have to solve the **discrete logarithm problem** to recover `xA` or `xB`
from the public values, which is infeasible for large `q`.

But D-H is **unauthenticated**, so it fails against an **active**
man-in-the-middle: Darth intercepts `yA` and `yB`, substitutes his own public
value in each direction, and establishes **one shared key with Alice and a
different one with Bob**. He decrypts, reads or alters, and re-encrypts — while
both parties believe they share a secret.

**Remedy:** authenticate the exchanged public values — digital signatures,
certificates, or the station-to-station protocol. This is precisely why **IKE
authenticates its D-H exchange** with pre-shared keys, RSA signatures or
certificates.

*(Note also the toy moduli above are trivially breakable by brute force; real
deployments use `q` of 2048 bits or more.)*
