# NCS Mid-Sem — Flashcards

Cover the right column. Aim for instant recall — these are the
definition-and-name questions that carry easy marks.

---

## Unit I — Definitions and X.800

| Prompt | Answer |
|---|---|
| Computer security | Tools designed to protect data and thwart hackers |
| Network security | Measures to protect data **during transmission** |
| Internet security | Protection across a **collection of interconnected networks** |
| X.800 is | ITU-T "Security Architecture for OSI" |
| X.800's three headings | Security **attack**, **mechanism**, **service** |
| Security attack | Any action that compromises the security of information owned by an organisation |
| Security mechanism | A process designed to **detect, prevent or recover** from an attack |
| Security service | A service that enhances security, countering attacks using one or more mechanisms |
| The 2 passive attacks | Release of message contents · **Traffic analysis** |
| The 4 active attacks | **Masquerade · Replay · Modification · Denial of service** |
| Passive attacks are hard to ___ | **Detect** (so prevent them instead) |
| Active attacks are hard to ___ | **Prevent** (so detect and recover instead) |
| The 5 X.800 services | Authentication · Access control · Data confidentiality · Data integrity · Non-repudiation |
| The 8 specific mechanisms | Encipherment, digital signature, access control, data integrity, authentication exchange, traffic padding, routing control, notarization |
| The 5 pervasive mechanisms | Trusted functionality, security labels, event detection, security audit trail, security recovery |
| Specific vs pervasive | Specific are **protocol-layer bound**; pervasive are **not** |
| Counter to traffic analysis | **Traffic padding** |
| CIA triad | Confidentiality, Integrity, Availability |

## Unit I — Models, D-H, IPsec

| Prompt | Answer |
|---|---|
| 4 tasks of the network security model | Design algorithm · generate keys · distribute keys · specify protocol |
| 2 tasks of the network access model | Select **gatekeeper** functions · implement **internal controls** |
| D-H was published in | **1976** by Diffie & Hellman (Williamson, UK CESG, secretly 1970) |
| D-H public parameters | Prime `q` and **primitive root** `α` |
| D-H shared key formula | `K = α^(xA·xB) mod q` |
| D-H security rests on | The **discrete logarithm problem** |
| D-H's fatal weakness | **Man-in-the-middle** — it is unauthenticated |
| Can D-H send a chosen message? | **No** — key agreement only |
| Stallings D-H example answer | q=353, α=3, xA=97, xB=233 → **K = 160** |
| AH protocol number | **51** |
| ESP protocol number | **50** |
| AH provides encryption? | **No** — integrity and authentication only |
| Which IPsec protocol breaks NAT | **AH** |
| SA identified by | **(SPI, destination IP, protocol)** — and it is **one-way** |
| SAD / SPD | SA Database (active SAs) / Security Policy Database (what to protect) |
| Tunnel mode adds | A **new outer IP header** |
| Mode giving traffic-flow confidentiality | **Tunnel mode** |
| IKE ports | UDP **500**, and **4500** for NAT-T |
| IKE's 3 components | **ISAKMP** (framework) · **Oakley** (D-H key determination) · **SKEME** |
| IKE Phase 1 produces | The **IKE SA** (main mode 6 msgs / aggressive 3) |
| IKE Phase 2 produces | The **IPsec SAs** (quick mode, 3 msgs) |
| IPsec anti-replay uses | **Sequence numbers + sliding window** (default 64) |

## Unit II — Vocabulary

| Prompt | Answer |
|---|---|
| Vulnerability | A **weakness** that can be exploited |
| Threat | A **potential** danger that may exploit a vulnerability |
| Attack | The **act** of exploiting a vulnerability |
| Risk | **Likelihood × impact** |
| Attack surface | Sum of all points where an attacker can interact |
| Defence in depth | **Layered** controls so no single failure is fatal |
| APT | Advanced Persistent Threat — stealthy, long-term, usually nation-state |
| Most secure transmission medium | **Fibre optic** — no EMI, must bend/splice to tap |
| Least secure medium | **Wireless** — broadcast, no physical access needed |
| TEMPEST / Van Eck phreaking | Reconstructing data from **electromagnetic emanations** |
| Cleartext management protocols to avoid | **Telnet, HTTP, SNMPv1/v2c, TFTP, FTP** |
| Default SNMP community strings | `public` and `private` |
| Secure replacements | **SSHv2, HTTPS, SNMPv3** |
| Back door | Access method that **bypasses normal authentication** |
| Why reverse shells? | They **call outward**, defeating inbound firewall rules |
| Counter to back doors | File-integrity monitoring, **egress filtering**, rebuild the host |

## Unit II — Attacks

| Prompt | Answer |
|---|---|
| DoS vs DDoS | Single source vs **many zombies in a botnet** |
| 3 DoS categories | **Volumetric · Protocol/state · Application layer** |
| SYN flood exploits | The **half-open connection backlog** |
| SYN flood defence | **SYN cookies** — encode state in the ISN, allocate nothing |
| Smurf attack | ICMP echo to a **broadcast address** with victim's spoofed source |
| Smurf defence | Disable **directed broadcasts** |
| Fraggle | Smurf, but using **UDP echo** |
| LAND attack | Packet with **source = destination** |
| Teardrop | **Overlapping fragment** offsets crash reassembly |
| Slowloris | Many partial HTTP headers sent slowly — **application layer** |
| Highest amplification factor | **Memcached** (~50,000×) |
| Anti-spoofing standard | **BCP 38** — ingress filtering |
| Blind vs non-blind spoofing | Attacker **cannot** vs **can** see the replies |
| ARP's flaw | **Stateless and unauthenticated** — accepts gratuitous replies |
| ARP poisoning enables | **MITM and sniffing on a switched network** |
| ARP poisoning defence | **Dynamic ARP Inspection** + DHCP snooping |
| DNS spoofing vs cache poisoning | **One query** vs **cached, affects all clients until TTL** |
| Kaminsky attack | Random subdomain queries + forged **authority record** → practical poisoning |
| Only complete DNS fix | **DNSSEC** |
| DNS tunnelling | Encoding data in DNS queries to **exfiltrate** past firewalls |
| Session hijacking needs | IPs, ports and the correct **sequence numbers** |
| ACK storm | Symptom of a **desynchronised** hijacked TCP session |
| Session hijacking defence | **Randomised ISNs** + encryption (SSH/TLS/IPsec) |
| Replay defence (three ways) | **Nonce · timestamp · sequence number** |
| Which protocol uses timestamps against replay | **Kerberos** |

## Unit II — Defences

| Prompt | Answer |
|---|---|
| VLAN separates | **Broadcast domains** |
| VLAN tagging standard | **802.1Q** (12-bit VLAN ID, 1–4094) |
| Two VLAN hopping attacks | **Switch spoofing** (DTP) · **Double tagging** (native VLAN) |
| Double tagging is | **Unidirectional** — send only, no replies |
| DMZ purpose | Public services reachable **without exposing the internal network** |
| The critical DMZ rule | **DMZ → Internal is denied** |
| Screened subnet | The **dual-firewall** DMZ design |
| Bastion host | A hardened, minimal, exposed host in the DMZ |
| NAC checks | **Posture**: AV, patches, firewall, configuration |
| NAC outcomes | **Allow · Quarantine · Deny · Restrict** |
| 802.1X three roles | **Supplicant · Authenticator · Authentication server (RADIUS)** |
| Protocol carrying 802.1X credentials | **EAP** |
| MAB and its weakness | MAC Authentication Bypass — **MACs are spoofable** |
| Forward vs reverse proxy | In front of **clients** vs in front of **servers** |
| Honeypot's defining property | No production value → **any interaction is suspicious** |
| Low vs high interaction honeypot | Emulated services vs a **real OS** (rich but risky) |
| Honeytoken | Fake **data** whose use signals a breach |
| IDS vs IPS | **Out-of-band + alert** vs **inline + block** |
| NIDS blind spot | **Encrypted traffic** |
| What solves that blind spot | **HIPS** — inspects after TLS termination on the host |
| Signature detection weakness | **Cannot detect zero-day** attacks |
| Anomaly detection weakness | **High false-positive rate** |
| False negative | A **real attack that was missed** — the dangerous error |
| Promiscuous mode | NIC accepts frames **not addressed to it** |
| Sniffing on a switch requires | **SPAN/port mirroring, a tap, or ARP poisoning** |
| Why sniffing can't be detected | It is **entirely passive** — encrypt instead |
| Content filtering methods | URL, category, keyword, MIME type, reputation, **DNS** |
| Content filter's main limitation | **HTTPS** needs TLS inspection; bypassable via VPN/Tor |
