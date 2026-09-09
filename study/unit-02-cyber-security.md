# Unit II — Cyber Security

**12 lectures · mid-sem scope · maps to CO2 and CO3 · the largest unit**

> ⚠ **No lecture deck exists for this unit.** Every section below is written from
> the syllabus topic list against TB1 (Stallings 8e) and TB2 (Whitman & Mattord).
> The terminology follows the standard Security+ / network-defence framing the
> syllabus uses. Cross-check emphasis with your teacher's class notes.

Three natural blocks: **vulnerabilities** → **attacks** → **defences**.

---

# Part A — Vulnerabilities

## 1. Introduction to cyber security

**Cyber security** protects systems, networks and data in cyberspace from
attack, damage or unauthorised access. Where *network security* concerns data in
transit, cyber security is broader: people, process and technology across the
whole digital estate.

The **CIA triad** — the goals every control serves:

| Goal | Meaning | Broken by |
|---|---|---|
| **Confidentiality** | Only authorised parties can read the data | Sniffing, theft, disclosure |
| **Integrity** | Data is accurate and unaltered | Modification, MITM, poisoning |
| **Availability** | Systems accessible when needed | DoS/DDoS, ransomware, outage |

Extended with **AAA** — Authentication, Authorisation, Accounting — and
**non-repudiation**.

**Key vocabulary (learn the distinctions):**

| Term | Definition |
|---|---|
| **Asset** | Anything of value to the organisation |
| **Vulnerability** | A weakness that can be exploited |
| **Threat** | A potential danger that may exploit a vulnerability |
| **Threat agent** | The specific actor who carries it out |
| **Attack** | The act of exploiting a vulnerability |
| **Exploit** | The technique/code used |
| **Risk** | Likelihood × impact of a threat exploiting a vulnerability |

**Threat actors:** script kiddies · hacktivists · insiders · organised crime ·
**APTs** / nation-states · competitors.

**Attack surface** = the sum of all points where an attacker can interact.
**Defence in depth** = layered controls so no single failure is fatal.

## 2. Media-Based Vulnerabilities

Weaknesses in the **physical transmission medium** itself — attacks below the
protocol layer, which encryption at higher layers may not address.

| Medium | Vulnerability | Notes |
|---|---|---|
| **Coaxial / twisted pair (copper)** | **Inductive tapping** — a clamp-on tap reads the signal without cutting the cable; emits **EMI** that can be captured at a distance | UTP worst; STP shielding reduces but doesn't eliminate |
| **Fibre optic** | Must **bend or splice** the fibre to leak light — detectable as signal loss | No EMI, hardest to tap → most secure medium |
| **Wireless** | **Broadcast** medium; no physical access needed at all | Most vulnerable by far |

**Attack techniques on the media/L2 path:**

- **Wiretapping / cable tapping** — passive taps are near-undetectable
- **Port mirroring (SPAN)** — abuse of a legitimate switch feature to copy all
  traffic to an attacker-controlled port
- **Network taps** — inline hardware that duplicates traffic
- **Hub environments** — every frame reaches every port; trivially sniffable
- **Crosstalk** and **EMI/RFI** — signal leakage between adjacent conductors
- **Van Eck phreaking / TEMPEST** — reconstructing data from electromagnetic
  emanations
- **Physical damage / cable cuts** — an availability attack

**Countermeasures:** prefer fibre for sensitive links · lock wiring closets and
patch panels · conduit and shielded cable · **encrypt in transit so tapping
yields ciphertext** · monitor for unexplained link-state or loss changes ·
disable unused switch ports.

## 3. Network Device Vulnerabilities

Routers, switches, firewalls, APs and modems are themselves computers — and are
frequently the weakest link because they are configured once and forgotten.

| Vulnerability | Explanation |
|---|---|
| **Default / weak passwords** | Shipped credentials (`admin/admin`, `cisco/cisco`) left unchanged — the single most exploited device weakness |
| **Back doors / hardcoded accounts** | Undocumented vendor maintenance accounts |
| **Insecure management protocols** | **Telnet, HTTP, SNMPv1/v2c, TFTP** send credentials in **cleartext**. SNMP community strings default to `public`/`private` |
| **Outdated firmware** | Unpatched known CVEs; devices rarely on a patch cycle |
| **Privilege escalation** | Moving from a limited account to full administrative control |
| **Default configuration** | Unnecessary services and ports enabled out of the box |
| **Physical access** | Console port access; documented **password-recovery procedures** become an attack when the device is reachable |
| **Weak/absent logging** | Attacks go unnoticed; no forensic trail |

**Hardening checklist:** change all defaults · **SSHv2 / HTTPS / SNMPv3** only ·
disable unused ports and services · patch firmware · restrict management to a
dedicated **out-of-band** network with ACLs · centralise logs to a syslog/SIEM ·
physically secure devices · use **AAA/RADIUS/TACACS+** with per-admin accounts.

---

# Part B — Attacks

## 4. Back Doors

A **back door** is a means of accessing a system that **bypasses normal
authentication**, usually hidden.

**How they arise:**

1. **Developer/maintenance hooks** — debugging shortcuts left in production code
2. **Installed by malware** — trojans and **RATs** (Back Orifice, NetBus, Sub7)
3. **Vendor-embedded** — hardcoded support credentials
4. **Attacker-installed post-compromise** — to guarantee re-entry after the
   original hole is patched; often hidden by a **rootkit**
5. **Supply-chain implants** — inserted before delivery

**Characteristics:** persistence across reboots · listens on an unusual port or
uses **reverse connections** (calling out to the attacker, defeating inbound
firewall rules) · disguised process names.

**Countermeasures:** source-code review and SDLC controls · **file-integrity
monitoring** (Tripwire/AIDE) · baseline and monitor listening ports (`netstat`) ·
**egress filtering** to catch reverse shells · rebuild rather than clean a
compromised host · change all default credentials.

## 5. Denial of Service (DoS) and DDoS

Attacks on **availability**. **DoS** = one source; **DDoS** = many compromised
hosts (**zombies/bots**) under a **botnet**, coordinated through
handlers/C&C — making it far harder to filter or trace.

### Three categories

| Category | Mechanism | Examples |
|---|---|---|
| **Volumetric** | Saturate **bandwidth** | UDP flood, ICMP flood, amplification |
| **Protocol / state exhaustion** | Consume **connection-table or CPU** state | **SYN flood**, Ping of Death, Smurf |
| **Application layer** | Exhaust the **app/server**, low traffic volume | HTTP GET/POST flood, **Slowloris** |

### Classic attacks to name in the exam

- **SYN flood** — attacker sends TCP **SYN** packets with **spoofed** source
  addresses. The server replies SYN/ACK and holds a **half-open** connection in
  its backlog awaiting an ACK that never comes. The backlog fills and legitimate
  connections are refused.
  *Defences:* **SYN cookies** (encode state in the ISN, allocate nothing until
  the ACK returns), larger backlog, shorter timeout, SYN proxying.

- **Smurf attack** — ICMP echo requests sent to a network's **broadcast address**
  with the **victim's spoofed source**; every host replies to the victim.
  **Amplification** by the size of the network.
  *Defence:* disable directed broadcasts (`no ip directed-broadcast`).
  **Fraggle** is the same idea using UDP echo.

- **Ping of Death** — oversized/malformed fragmented ICMP that overflows the
  reassembly buffer.
- **Teardrop** — **overlapping** fragment offsets crash the reassembly routine.
- **LAND attack** — packet with **source = destination**, making the host reply
  to itself in a loop.
- **Slowloris** — opens many HTTP connections and sends partial headers slowly,
  holding worker threads open with almost no bandwidth.

### Reflection and amplification

The attacker spoofs the victim's address in requests to public servers; the
**servers'** replies flood the victim. Chosen for a large **amplification
factor**: **DNS** (~50×), **NTP** monlist (~550×), **memcached** (~50,000×).
The victim sees traffic from innocent third parties.

**Defences overall:** ingress/egress filtering (**BCP 38** — drop spoofed
sources) · rate limiting · **anycast** and scrubbing centres · CDN absorption ·
blackhole/sinkhole routing · **RTBH** · over-provisioning · IDS/IPS signatures.

## 6. Spoofing

**Spoofing** = masquerading as a trusted entity by **falsifying identifying
data**. It underpins most other attacks in this unit.

| Type | What is forged | Purpose |
|---|---|---|
| **IP spoofing** | Source IP address | Hide origin; abuse IP-based trust; enable reflection |
| **MAC spoofing** | NIC hardware address | Defeat MAC filtering / port security; impersonate a host |
| **ARP spoofing** | IP↔MAC mapping | MITM on the LAN (§8) |
| **DNS spoofing** | Name→IP resolution | Redirect victims to attacker sites (§9) |
| **Email spoofing** | `From:` header | Phishing, BEC |
| **Web / URL spoofing** | Site appearance, look-alike domain | Credential harvesting; **typosquatting**, homograph attacks |
| **Caller ID / SMS** | Originating number | Vishing/smishing |

**Blind vs non-blind:** in **blind** spoofing the attacker cannot see replies
(they go to the real address owner) and must predict sequence numbers; in
**non-blind** the attacker is on the path and sees everything.

**Defences:** **ingress filtering** at the network edge · **uRPF** (reverse-path
check) · authenticate by **cryptographic identity, never by address** ·
**SPF/DKIM/DMARC** for email · **DNSSEC** · **DAI** for ARP · TLS certificates.

## 7. Man-in-the-Middle and Replay

### Man-in-the-Middle (MITM)

The attacker sits **between** two parties, relaying and possibly altering
traffic, while each believes it is talking directly to the other.

```
   Alice  <------>  ATTACKER  <------>  Bob
        two separate sessions; attacker
        decrypts, reads/alters, re-encrypts
```

**How the position is obtained:** **ARP poisoning** (LAN) · **DNS spoofing** ·
**rogue AP / evil twin** · **SSL stripping** (downgrading HTTPS to HTTP) · rogue
DHCP server handing out attacker's gateway · **BGP hijacking** (internet scale).

**Note the link to Unit I:** unauthenticated **Diffie–Hellman is defeated
exactly this way**, which is why real protocols authenticate the exchange.

**Defences:** **mutual authentication** · TLS with proper **certificate
validation**, **HSTS**, certificate **pinning** · avoid untrusted Wi-Fi / use
VPN · DAI and DHCP snooping · out-of-band verification of key fingerprints.

### Replay attack

The attacker **captures a valid message** (an authentication token, a session
cookie, a funds-transfer request) and **retransmits it later** to gain the same
effect. The attacker need not decrypt or understand it — a captured encrypted
password hash still works if the protocol accepts it.

**Defences — make every message unique and time-bound:**

- **Nonces** (number used once) and **challenge–response**
- **Timestamps** with a validity window (used by **Kerberos**)
- **Sequence numbers** with a sliding window (used by **IPsec anti-replay**)
- Per-session keys and short-lived tokens

## 8. Protocol-Based Attacks and ARP Poisoning

### Why TCP/IP is attackable by design

The core protocols were designed for a **small, trusted** research network:
**no authentication, no integrity, no confidentiality**. Attacks exploit the
*design*, not a bug — which is why they persist.

| Protocol | Design weakness | Resulting attack |
|---|---|---|
| **ARP** | Stateless; **any** reply is accepted, even unsolicited | ARP poisoning |
| **IP** | Source address never verified | IP spoofing, DoS |
| **TCP** | Trusts sequence numbers only | Session hijacking, SYN flood |
| **DNS** | UDP, no authentication of responses | Spoofing, cache poisoning |
| **DHCP** | No server authentication | Rogue DHCP, starvation |
| **ICMP** | Trusted control messages | Smurf, redirect attacks |
| **SNMPv1/2c, Telnet, FTP, HTTP** | **Cleartext** credentials | Sniffing |

### ARP poisoning (ARP cache poisoning / ARP spoofing)

ARP maps an **IP address to a MAC address** on a LAN. It is **stateless and
unauthenticated**: a host caches *any* ARP reply it receives, including
**gratuitous ARP** it never asked for.

**The attack:**

1. Attacker sends forged ARP replies to the **victim**: *"the gateway's IP is at
   my MAC"*
2. And to the **gateway**: *"the victim's IP is at my MAC"*
3. Both caches are poisoned; all traffic flows **through the attacker**
4. Attacker enables IP forwarding to stay transparent

```
Before:   Victim  <-------------->  Gateway
After:    Victim  <---> ATTACKER <--->  Gateway
```

**Consequences:** MITM · sniffing on a **switched** network (which normally
prevents it) · session hijacking · selective DoS by mapping to a non-existent
MAC. **Tools:** Ettercap, Cain & Abel, arpspoof, Bettercap.

**Defences:** **Dynamic ARP Inspection (DAI)** with **DHCP snooping** — the
switch validates ARP against a trusted binding table · **static ARP entries** for
critical hosts · **port security** · VLAN segmentation to shrink the broadcast
domain · encryption so intercepted traffic is useless · `arpwatch` monitoring.

## 9. DNS Attacks — spoofing, poisoning and beyond

DNS resolves names to IPs. It runs over **UDP/53**, is **connectionless** and
**unauthenticated** — a response is accepted if it matches the **query ID**,
**source port** and question. That is all an attacker must forge.

### DNS spoofing

The attacker sends a **forged response** to a resolver's query, **racing** the
legitimate server. If the forgery arrives first and matches the transaction ID,
it is accepted and the victim is silently redirected to the attacker's IP.
Affects only that one query.

### DNS cache poisoning

The forged record is **stored in the resolver's cache**, so **every user** of
that resolver is redirected until the **TTL** expires. Far more damaging.

The **Kaminsky attack (2008)** made this practical: by querying random
non-existent subdomains and flooding forged replies carrying a malicious
**authority/glue record** for the whole zone, the attacker gets unlimited retries
against a 16-bit transaction ID.

**Mitigations:** **source-port randomisation** (adds ~16 bits of entropy) ·
**0x20 encoding** (random query-name capitalisation) · **DNSSEC** — cryptographic
signatures on records, the only real fix · shorter TTLs.

### Other DNS attacks

| Attack | Description |
|---|---|
| **DNS amplification** | Small spoofed queries → large responses flood the victim (§5) |
| **DNS hijacking** | Altering registrar records or the client's configured resolver |
| **DNS tunnelling** | Encoding data in DNS queries to **exfiltrate** past firewalls |
| **Zone transfer (AXFR)** | Misconfigured server leaks the entire zone — reconnaissance |
| **Typosquatting** | Registering misspelled domains |
| **NXDOMAIN / random subdomain flood** | Exhausts resolver resources |

**Defences:** **DNSSEC** · **DoH/DoT** (encrypted DNS) · restrict recursion to
internal clients · **split-horizon DNS** · restrict zone transfers to
authorised secondaries · patch and monitor resolvers · registrar lock + MFA.

## 10. TCP/IP Hijacking (session hijacking)

Taking over an **already established, already authenticated** TCP session — so
the attacker never needs the credentials.

**Requirements:** knowledge of the **source/destination IP and port**, and the
current **sequence and acknowledgement numbers**.

**Mechanism:** the attacker injects a spoofed packet with the correct next
sequence number. The server accepts it as legitimate. The real client's packets
now carry "wrong" sequence numbers and are discarded — the session is
**desynchronised** and the attacker has taken the client's place. Rapid
mismatched ACKs between the real endpoints produce an **ACK storm**, a
recognisable symptom.

| | **Non-blind hijacking** | **Blind hijacking** |
|---|---|---|
| Attacker position | On the path — **can see** the traffic | Off-path — **cannot see** replies |
| Sequence numbers | Read directly | Must be **predicted/guessed** |
| Difficulty | Easier | Hard against **randomised ISNs** |

Often combined with a **DoS on the legitimate client** to stop it objecting.
**Tools:** Hunt, Juggernaut, Ettercap, Shijack.

**Defences:** **random initial sequence numbers** (RFC 6528) · **encrypt the
session** — SSH, TLS, IPsec — so injected plaintext fails integrity checks ·
TCP timestamps · short session timeouts · re-authenticate for sensitive actions ·
bind session tokens to client attributes.

---

# Part C — Defences and Secure Network Design

## 11. Virtual LAN (VLAN)

A **VLAN** logically segments one physical switch infrastructure into multiple
**broadcast domains**. Ports in different VLANs cannot communicate without a
**router or L3 switch**, regardless of physical location.

**802.1Q** inserts a 4-byte tag carrying a 12-bit **VLAN ID** (1–4094).
**Access ports** carry one untagged VLAN to an end device; **trunk ports** carry
many tagged VLANs between switches. The **native VLAN** travels untagged.

**Security benefits:** contains broadcast traffic · limits sniffing and ARP
poisoning to one VLAN · **separates traffic classes** (users, servers, VoIP,
management, guests) · enforces policy at the inter-VLAN routing point · limits
**lateral movement** after a compromise.

**VLAN hopping attacks:**

| Attack | Mechanism | Mitigation |
|---|---|---|
| **Switch spoofing** | Attacker's port negotiates a **trunk** via **DTP**, gaining all VLANs | **Disable DTP**: `switchport mode access`, `switchport nonegotiate` |
| **Double tagging** | Two 802.1Q tags; the first is stripped by the native VLAN, the second delivers the frame into the target VLAN (one-way) | Change the **native VLAN** to an unused ID; don't use **VLAN 1**; tag the native VLAN |

Also: **private VLANs (PVLAN)** isolate ports *within* a VLAN — useful in a DMZ
so compromised servers cannot reach each other.

## 12. Demilitarized Zone (DMZ)

A **DMZ** is a **semi-trusted subnet** between the untrusted Internet and the
trusted internal network, hosting services that **must** be publicly reachable —
web, mail relay, external DNS, FTP, reverse proxy.

**The core principle:** the Internet never touches the internal network
directly, and a **compromised public server does not yield internal access**.

**Two architectures:**

```
Single firewall (three-legged):

   Internet ---[ Firewall ]--- Internal LAN
                    |
                   DMZ

Dual firewall (screened subnet) - more secure:

   Internet ---[ FW1 ]--- DMZ ---[ FW2 ]--- Internal LAN
```

The dual-firewall design is stronger: an attacker must defeat **two** devices,
ideally from **different vendors** so one vulnerability doesn't breach both.

**Rule set — the examinable part:**

| Direction | Policy |
|---|---|
| Internet → DMZ | **Permitted**, only to specific services/ports |
| Internet → Internal | **Denied** |
| Internal → DMZ | **Permitted** |
| **DMZ → Internal** | **Denied** (or a tightly restricted, logged exception, e.g. web server to a DB proxy) |
| DMZ → Internet | Restricted to what the service requires |

**Extranet** — a DMZ-like zone for partner access. **Bastion host** — a hardened,
minimal, exposed host in the DMZ.

## 13. Network Access Control (NAC)

**NAC** decides **whether a device may join the network at all**, based on its
**identity and security posture** — not merely whether the user has a password.

**Posture checks:** antivirus installed and up to date · OS patch level · host
firewall enabled · required agent present · no prohibited software · valid
certificate.

**Enforcement outcomes:** **Allow** (full access) · **Quarantine** (a remediation
VLAN with only patch/AV servers reachable) · **Deny** · **Restrict** (limited
guest access).

| Dimension | Options |
|---|---|
| **Timing** | **Pre-admission** (checked before access) vs **post-admission** (continuous re-checks) |
| **Client** | **Agent-based** (persistent or dissolvable, deep inspection) vs **agentless** (scan-based, no install) |
| **Enforcement** | **Inline** appliance vs **out-of-band** (instructs the switch) |

**802.1X** is the standard port-based mechanism, with three roles:

- **Supplicant** — the client requesting access
- **Authenticator** — the switch or AP controlling the port
- **Authentication server** — **RADIUS**, validating credentials

Credentials are carried by **EAP** (PEAP, EAP-TLS with certificates, EAP-TTLS).
Until authentication succeeds, the port passes only EAP traffic.

**Benefits:** blocks unmanaged/rogue devices · enforces patch hygiene · handles
BYOD and guests · limits worm spread.
**Challenges:** IoT and printers that can't run agents (need MAB — MAC
Authentication Bypass, which is spoofable) · complexity · user friction.

## 14. Proxy Server

A **proxy** is an intermediary that terminates the client's request and makes its
own request onward. The two parties never communicate directly.

| | **Forward proxy** | **Reverse proxy** |
|---|---|---|
| Sits in front of | **Clients** (internal users → Internet) | **Servers** (Internet → your servers) |
| Hides | The client from the server | The server from the client |
| Typical use | Content filtering, caching, monitoring outbound use | Load balancing, TLS offload, WAF, protecting the DMZ |

**Security functions:** hides internal addressing (like NAT, at the application
layer) · **content filtering** (§18) · **caching** (bandwidth and latency) ·
**logging/auditing** of all requests · **malware scanning** · **access control**
by user, time or category · **SSL/TLS inspection** (decrypt–inspect–re-encrypt).

Because a proxy understands the **application protocol**, it can make far finer
decisions than a packet filter — this is exactly the **application-level gateway**
idea that returns in Unit V.

**Limitations:** a **single point of failure** and a performance bottleneck ·
TLS inspection raises **privacy** concerns and breaks certificate pinning ·
must be enforced (via WPAD/policy) or users bypass it · **anonymous open
proxies** let attackers hide.

## 15. Honeypot

A **honeypot** is a decoy system with **no production value**. It advertises
apparent vulnerability to attract attackers.

**The defining property:** since nothing legitimate should ever touch it,
**any interaction is by definition suspicious** — giving an extremely low
**false-positive** rate and a small, high-value dataset.

| Classification | Types |
|---|---|
| **By interaction** | **Low-interaction** — emulated services only; safe, limited data (Honeyd). **High-interaction** — a real OS and applications; rich data, **risky** (can be used as a pivot) |
| **By purpose** | **Production** — divert and detect attackers in a live network. **Research** — study attacker tools and motives |

**Related:** a **honeynet** is a whole network of honeypots behind a *honeywall*
that controls outbound traffic; a **honeytoken** is fake *data* (a bogus record
or credential) whose use signals a breach; a **tarpit** deliberately slows
attackers.

**Advantages:** few false positives · small data volume · captures **novel/zero-day**
techniques and malware samples · wastes attackers' time.
**Disadvantages / risks:** only sees attacks that reach it — **narrow view** ·
if compromised it can be used to **attack third parties** (liability) ·
fingerprintable by skilled attackers · legal concerns around entrapment and
monitoring. **Place it in an isolated segment with strict egress control.**

## 16. NIDS and Host-based Intrusion Prevention

### IDS vs IPS — the fundamental distinction

| | **IDS** (Detection) | **IPS** (Prevention) |
|---|---|---|
| Placement | **Out-of-band** — fed by a **tap or SPAN port** | **Inline** — traffic passes through it |
| Action | **Detects and alerts** (passive) | **Blocks/drops** in real time (active) |
| Risk | Attack proceeds until someone responds | A **false positive blocks legitimate traffic**; a failure can break the link |

### Network-based vs Host-based

| | **NIDS/NIPS** | **HIDS/HIPS** |
|---|---|---|
| Monitors | Traffic on a **network segment** | A **single host**: logs, file integrity, registry, system calls, processes |
| Sees | Many hosts at once | Deep detail on one host, **including after decryption** |
| Blind to | **Encrypted** payloads; traffic that doesn't cross it | Anything not touching that host |
| Examples | Snort, Suricata, Zeek | OSSEC, Tripwire, endpoint HIPS |

**HIPS** is the key answer to the encryption blind spot: it inspects data on the
endpoint *after* TLS termination, and can block malicious system calls.

### Detection methodologies

| Method | How | Strength | Weakness |
|---|---|---|---|
| **Signature / misuse-based** | Matches known attack patterns | Accurate, **few false positives**, names the attack | **Cannot detect novel/zero-day** attacks; needs constant updates |
| **Anomaly-based** | Builds a **baseline** of normal, flags deviation | **Can detect unknown attacks** and insider misuse | **High false-positive rate**; needs a clean training period |
| **Stateful protocol analysis** | Compares against vendor **protocol specifications** | Catches protocol misuse | Resource-heavy; can't catch attacks that obey the spec |

**Errors to name precisely:**

- **False positive** — benign traffic flagged as an attack (causes alert fatigue)
- **False negative** — a real attack **missed** (the more dangerous error)

**Evasion techniques:** fragmentation · **insertion/evasion** (packets the IDS
and host interpret differently) · encryption · slow/low-and-slow attacks ·
polymorphism. **Placement:** outside the firewall sees all attempts (noisy);
inside sees what got through (actionable) — mature networks do both.

## 17. Protocol Analyzers

A **protocol analyzer** (packet sniffer) captures and decodes network traffic
frame by frame. **Wireshark**, **tcpdump**, tshark, Zeek.

**How capture works:** the NIC is placed in **promiscuous mode** to accept frames
not addressed to it (and **monitor mode** for wireless). On a **hub** all traffic
is visible; on a **switch** the attacker sees only their own traffic unless they
use **port mirroring/SPAN**, a **network tap**, or **ARP poisoning**.

| **Legitimate use** | **Malicious use** |
|---|---|
| Troubleshooting and latency analysis | Harvesting **cleartext credentials** (Telnet, FTP, HTTP, POP3, SNMPv1/2c) |
| Performance baselining | Session token / cookie theft |
| **Forensics** and incident response | Reconnaissance — mapping hosts, OS fingerprinting |
| Verifying that encryption is actually in use | Capturing data for **replay** attacks |
| Feeding IDS/IPS engines | Extracting transferred files |

**Defences:** **encrypt everything** — the only real answer, since sniffing is
passive and undetectable · use switches with **DAI**, **DHCP snooping** and port
security · disable unused ports and restrict SPAN configuration · segment with
VLANs · detect promiscuous-mode NICs (imperfectly, e.g. via ARP probes).

## 18. Internet Content Filters

**Content filtering** inspects and restricts the material users may access,
enforcing acceptable-use policy and blocking malicious content.

**Filtering methods:**

| Method | Basis |
|---|---|
| **URL filtering** | Allow/block lists of specific addresses |
| **Category filtering** | Vendor-maintained categories (gambling, adult, social media, malware) |
| **Keyword/content filtering** | Terms appearing in the page body |
| **MIME/file-type filtering** | Blocking `.exe`, archives, scripts |
| **Reputation filtering** | Dynamic scoring of a domain's history |
| **DNS filtering** | Refusing to resolve blocked domains — cheap and network-wide |

**Deployment points:** at a **proxy server** or secure web gateway · integrated
in the **firewall/UTM/NGFW** · as **DNS-layer** filtering · as **endpoint agent**
software (covers roaming laptops) · **cloud-based** (CASB/SWG).

**Purposes:** enforce acceptable use and productivity · **block malware,
phishing and C&C** domains · conserve bandwidth · **legal/regulatory
compliance** (e.g. CIPA in schools) · reduce liability for a hostile work
environment.

**Limitations:** **HTTPS** requires **TLS inspection** to see content — costly
and privacy-invasive · **over-blocking** (false positives) frustrates users and
blocks legitimate research; **under-blocking** misses new sites · bypassable via
**VPNs, Tor, proxy sites, IP-in-place-of-name** · category databases lag new
sites · ineffective for encrypted messaging apps.

---

## Unit II — likely exam targets

1. **Compare** passive vs active, or IDS vs IPS, or NIDS vs HIDS — table answers
2. **ARP poisoning** — mechanism, diagram, consequences, mitigation (DAI)
3. **DNS spoofing vs DNS cache poisoning** — the difference in *scope* matters
4. **SYN flood** step-by-step, and **SYN cookies** as the defence
5. **DMZ** — draw both architectures and state the traffic rules
6. **VLAN hopping** — both methods with mitigations
7. **Session hijacking** — blind vs non-blind, why randomised ISNs help
8. **Honeypot** — types and the "any interaction is suspicious" property
9. **NAC / 802.1X** — the three roles and the posture-check outcomes
10. Signature vs anomaly detection, with false positive/negative definitions
