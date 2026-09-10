# NCS Mid-Sem: Complete Topic Checklist

**Scope: Unit I (6 lectures) + Unit II (12 lectures). 20 marks.**
Topic list taken from the official 2026 lesson plan (`syllabus/syllabus-extracted-raw.txt`),
expanded to subtopic level. Nothing here is optional. Tick as you go.

Notes: [unit-01-network-security.md](unit-01-network-security.md) ·
[unit-02-cyber-security.md](unit-02-cyber-security.md) ·
[cheatsheet-tables-diagrams.md](cheatsheet-tables-diagrams.md) ·
[flashcards.md](flashcards.md) · [practice-qa.md](practice-qa.md)

**Deep dives** (mermaid diagrams + verified external links): [deep-dive-ipsec.md](deep-dive-ipsec.md) covers topics **7 and 8**.

---

# UNIT I - Introduction to Network Security (6 lectures, CO1)

## 1. Introduction to Network Security

- [ ] Computer security vs network security vs internet security (the three definitions)
- [ ] The four goals of security measures: deter, prevent, detect, correct
- [ ] OSI Security Architecture (ITU-T **X.800**): why it exists
- [ ] The three headings: security **attack**, security **mechanism**, security **service**
- [ ] RFC 2828 definition of a security service
- [ ] The relationship: services implement **policies**, services are implemented by **mechanisms**

### 1a. Security attacks

- [ ] Passive vs active: full comparison table
- [ ] Passive sub-types: release of message contents, **traffic analysis**
- [ ] Active sub-types: **masquerade, replay, modification of messages, denial of service**
- [ ] The detection/prevention asymmetry (passive: prevent; active: detect and recover)
- [ ] Traffic analysis in detail, and **traffic padding** as its countermeasure
- [ ] Trap: DoS is active; traffic analysis is passive

### 1b. Security services (X.800)

- [ ] **Authentication**: peer entity vs data origin authentication
- [ ] **Access control** (unauthorised **use**)
- [ ] **Data confidentiality** (unauthorised **disclosure**), incl. traffic-flow confidentiality
- [ ] **Data integrity** (no modification, insertion, deletion, replay); connection-oriented vs connectionless
- [ ] **Non-repudiation**: origin and destination variants
- [ ] Availability as a service/property; the **CIA triad**
- [ ] X.800 defines 14 specific services inside these 5 categories

### 1c. Security mechanisms (X.800)

- [ ] Specific vs pervasive: what the split means
- [ ] The 8 **specific** mechanisms: encipherment, digital signature, access control, data integrity, authentication exchange, traffic padding, routing control, notarization
- [ ] The 5 **pervasive** mechanisms: trusted functionality, security labels, event detection, security audit trail, security recovery
- [ ] No single mechanism supports all services; cryptography underlies most
- [ ] Service-to-mechanism mapping (which mechanisms deliver which service)

## 2. Model for Network Security

- [ ] Draw the full diagram: sender, recipient, security-related transform, information channel, trusted third party, opponent
- [ ] Role of the **trusted third party** (arbiter, key distributor)
- [ ] The **four basic tasks**: design algorithm, generate secret info, distribute/share secret info, specify protocol

## 3. Model for Network Access Security

- [ ] Draw the diagram: opponent (human vs software), gatekeeper function, computing resources, internal security controls
- [ ] Opponent types: human attacker vs software (virus, worm) threats
- [ ] The **two tasks**: select gatekeeper functions, implement internal security controls
- [ ] Role of trusted computer systems
- [ ] **Contrast**: network security model protects data **in transit**; access security model protects **resources on a system**

## 4. Real-time Communication Security: TCP/IP protocol stack

- [ ] The layers and their functions: application, transport, internet/network, network access/link, physical
- [ ] Security protocol at each layer (PGP/S-MIME/Kerberos, SSL/TLS, IPsec, WPA2/MACsec)
- [ ] TCP/IP vs OSI layer correspondence
- [ ] Encapsulation and headers, layer by layer

## 5. Implementation layers for security protocols and implications

- [ ] **Application layer** (PGP, S/MIME, Kerberos): advantages and drawbacks
- [ ] **Transport layer** (SSL/TLS): advantages and drawbacks
- [ ] **Network layer** (IPsec): advantages and drawbacks
- [ ] **Data link layer** (WPA2, MACsec, L2TP): advantages and drawbacks
- [ ] The general trade-off: higher layer = more granular and end-to-end but needs app changes; lower layer = more transparent and general but coarser
- [ ] End-to-end vs per-hop protection
- [ ] "At which layer should security be placed?" as a discussion answer

## 6. Diffie-Hellman key exchange

- [ ] History: Diffie and Hellman 1976; Williamson/CESG 1970, declassified 1987
- [ ] **It is key distribution only** - cannot exchange an arbitrary message
- [ ] Public parameters: prime `q`, **primitive root** `alpha`; what a primitive root is
- [ ] The algorithm: private keys `xA`, `xB`; public keys `yA = alpha^xA mod q`, `yB = alpha^xB mod q`
- [ ] Shared secret: `K = yB^xA mod q = yA^xB mod q = alpha^(xA*xB) mod q`
- [ ] Proof of why both sides agree
- [ ] Security basis: the **discrete logarithm problem**
- [ ] Worked numerical: `q=353, alpha=3, xA=97, xB=233` giving `yA=40, yB=248, K=160`
- [ ] **Be able to do a numerical with small numbers by hand** (modular exponentiation by repeated squaring)
- [ ] **MITM weakness**: plain D-H is unauthenticated; how Darth mounts it; two separate keys
- [ ] Fixes: digital signatures, certificates, station-to-station protocol
- [ ] Same key on repeat use; **ephemeral D-H (DHE)** and forward secrecy

## 7. IPsec: AH and ESP

> **Resources:** [deep-dive-ipsec.md](deep-dive-ipsec.md) sections 1-8 (architecture, SA, AH, ESP, both modes, all four packet layouts, anti-replay).
> Best external: [Firewall.cx IPSec modes](https://www.firewall.cx/networking/network-protocols/ipsec-modes.html) for the mode diagrams, [NetworkLessons IPsec](https://networklessons.com/vpn/ipsec-internet-protocol-security) for the walkthrough, [RFC 4302](https://datatracker.ietf.org/doc/html/rfc4302) / [RFC 4303](https://datatracker.ietf.org/doc/html/rfc4303) to settle details.

- [ ] What IPsec is, why network layer, transparency to applications
- [ ] Applications: VPNs, branch-office connectivity, remote access, extranet
- [ ] Benefits of IPsec (below transport layer, transparent to users, per-host)
- [ ] **Security Association (SA)**: one-way/simplex, two needed for bidirectional
- [ ] SA identified by the **triple**: SPI, destination IP address, security protocol identifier
- [ ] **SAD** (SA Database) vs **SPD** (Security Policy Database)
- [ ] **AH**: IP protocol **51**; integrity + data-origin authentication + anti-replay; authenticates immutable outer IP header fields; **no confidentiality**; breaks NAT
- [ ] AH header fields (next header, payload length, SPI, sequence number, ICV)
- [ ] **ESP**: IP protocol **50**; confidentiality + optional integrity/authentication + anti-replay; does not cover outer IP header; needs **NAT-T** (UDP 4500)
- [ ] ESP packet fields (SPI, sequence number, payload, padding, next header, ICV)
- [ ] **AH vs ESP comparison table**; why ESP won and AH is largely deprecated
- [ ] **Transport mode**: protects IP payload only; end-to-end, host-to-host
- [ ] **Tunnel mode**: protects the entire original packet; new outer IP header; gateway-to-gateway VPN
- [ ] **Transport vs tunnel comparison table**
- [ ] **Draw all four packet formats**: AH transport, AH tunnel, ESP transport, ESP tunnel (mark encrypted vs authenticated spans)
- [ ] Traffic-flow confidentiality: only tunnel mode provides it
- [ ] When tunnel mode is mandatory (either SA endpoint is a gateway)
- [ ] **Anti-replay**: monotonic sequence number + sliding receive window (default 64)

## 8. IPsec: IKE

> **Resources:** [deep-dive-ipsec.md](deep-dive-ipsec.md) section 9 (all four IKE sequence diagrams, message counts, IKEv1 vs IKEv2, cookies, auth methods).
> Best external: [Cisco, Understand IPsec IKEv1](https://www.cisco.com/c/en/us/support/docs/security-vpn/ipsec-negotiation-ike-protocols/217432-understand-ipsec-ikev1-protocol.html) is the authoritative free source, [Omnisecu IKEv1 modes](https://www.omnisecu.com/tcpip/ikev1-main-aggressive-and-quick-mode-message-exchanges.php) for per-message payloads, [RFC 7296](https://datatracker.ietf.org/doc/html/rfc7296) for IKEv2.

- [ ] Why IKE exists (manual keying does not scale)
- [ ] Runs over **UDP port 500**, plus **4500** with NAT-T
- [ ] The three components: **ISAKMP** (framework/message formats), **Oakley** (key determination, based on D-H), **SKEME** (key exchange techniques)
- [ ] **IKEv1 Phase 1**: authenticate peers, establish the **IKE SA**; **main mode** (6 messages, identity protected) vs **aggressive mode** (3 messages, faster, identity exposed)
- [ ] **IKEv1 Phase 2**: negotiate the IPsec SAs; **quick mode** (3 messages)
- [ ] **IKEv2** (RFC 7296): single 4-message exchange, built-in NAT traversal, EAP, DoS protection via **cookies**
- [ ] Authentication methods: pre-shared key, RSA signature, certificate
- [ ] **Perfect forward secrecy** from a fresh D-H per session
- [ ] Cookies as anti-clogging (DoS) protection
- [ ] ISAKMP header and payload types

---

# UNIT II - Cyber Security (12 lectures, CO2 + CO3)

## PART A: Vulnerabilities

### 9. Introduction to cyber security

- [ ] Definition and scope of cyber security vs network security vs information security
- [ ] Vocabulary, learn the exact distinctions: **asset, threat, threat agent/actor, vulnerability, exploit, risk, attack, control/countermeasure, exposure**
- [ ] Risk as a function of threat, vulnerability and impact
- [ ] **Threat actors**: script kiddies, hacktivists, insiders, organised crime, **APTs**/nation-states, competitors
- [ ] **Attack surface** and how to reduce it
- [ ] **Defence in depth** / layered security
- [ ] Security vs usability trade-off
- [ ] CIA triad applied to an organisation's needs (ties to CO2)

### 10. Media-Based Vulnerabilities

- [ ] Transmission media types and their relative security: coaxial, **twisted pair (UTP/STP)**, **fibre optic**, wireless
- [ ] Why fibre is hardest to tap; why copper radiates
- [ ] **Physical tapping / wiretapping**: vampire taps, inductive taps, fibre bend-coupling
- [ ] **Electromagnetic emanation** eavesdropping, **TEMPEST**
- [ ] **Crosstalk** and **EMI/RFI**
- [ ] Cable cutting and physical destruction (availability attack)
- [ ] Structured cabling and wiring-closet physical security
- [ ] Layer 2 attacks on the media path: **sniffing/eavesdropping**, **MAC flooding / CAM table overflow** (fail-open to hub behaviour), **MAC spoofing**, port stealing
- [ ] Wireless media issues: open SSIDs, WEP weakness, evil twin, jamming
- [ ] Countermeasures: fibre for sensitive links, locked wiring closets, **port security**, shielding, encryption everywhere

### 11. Network Device Vulnerabilities

- [ ] **Default accounts and default passwords**
- [ ] Weak/reused passwords, password storage on devices
- [ ] **Privilege escalation** on devices
- [ ] **Back doors and maintenance hooks** in devices and firmware
- [ ] **Plaintext management protocols**: Telnet, HTTP, FTP, **SNMPv1/v2c community strings**
- [ ] Firmware vulnerabilities and patch/upgrade management
- [ ] Unused open ports and unnecessary running services
- [ ] Physical access to devices, console ports, password recovery
- [ ] Misconfiguration as a vulnerability class
- [ ] **Hardening checklist**: change all defaults, SSHv2/HTTPS/SNMPv3 only, disable unused ports and services, AAA, patch regularly, config backup, logging

## PART B: Attacks

### 12. Back Doors

- [ ] Definition of a back door
- [ ] **Maintenance hooks** left by developers
- [ ] How back doors arise: developer convenience, malware-installed, supply chain, deliberate vendor access
- [ ] Characteristics: persistence across reboots, unusual listening port, hidden process, bypasses normal authentication
- [ ] Back door vs Trojan vs rootkit vs logic bomb
- [ ] Remote access Trojans (RATs) as examples
- [ ] Countermeasures: source-code review, SDLC controls, **file-integrity monitoring**, host firewall/egress filtering, port scanning your own hosts, IDS/IPS

### 13. Denial of Service (DoS) and DDoS

- [ ] DoS vs **DDoS**; which CIA property is attacked
- [ ] **Botnets**, command and control, zombies, handlers
- [ ] The **three categories**: volumetric/bandwidth, protocol/state exhaustion, application layer
- [ ] **SYN flood**: half-open connections and the backlog queue; the TCP three-way handshake
- [ ] **SYN cookies** as the defence
- [ ] **ICMP/ping flood**, **UDP flood**
- [ ] **Smurf attack** (ICMP directed broadcast) and **Fraggle** (UDP echo)
- [ ] **Ping of death**, **Teardrop** (fragment overlap), **LAND attack**
- [ ] **Slowloris** and slow-HTTP / low-and-slow attacks
- [ ] **HTTP flood** and application-layer floods
- [ ] **Reflection** and **amplification**: how they differ; **amplification factor**
- [ ] Amplifiers to name: **DNS, NTP (monlist), memcached, SSDP, CharGen**
- [ ] Defences: **ingress/egress filtering (BCP 38)**, rate limiting, SYN cookies, blackholing vs sinkholing, scrubbing centres, anycast, CDN, over-provisioning, disable directed broadcast

### 14. Spoofing

- [ ] Definition: masquerading by falsifying identifying information
- [ ] **IP spoofing**, and why it is easy (no source-address authentication in IP)
- [ ] **MAC spoofing**
- [ ] **ARP spoofing** (cross-reference ARP poisoning)
- [ ] **DNS spoofing** (cross-reference DNS attacks)
- [ ] **Email spoofing** (forged From: header)
- [ ] **Web spoofing / phishing sites**, caller-ID spoofing, GPS spoofing
- [ ] **Blind vs non-blind spoofing** (can the attacker see the replies?)
- [ ] Spoofing as an enabler for DoS reflection, hijacking and MITM
- [ ] Defences: **ingress filtering**, **uRPF** (unicast reverse-path forwarding), **SPF/DKIM/DMARC**, **DNSSEC**, **DAI**, TLS certificates, mutual authentication

### 15. Man-in-the-Middle and Replay

- [ ] **MITM** definition and the attacker's position (relay, read, modify)
- [ ] How the MITM position is obtained: **ARP poisoning** (LAN), **DNS spoofing**, rogue AP / **evil twin**, **BGP hijack**, malicious proxy, compromised CA
- [ ] **SSL stripping** and HTTPS downgrade; **HSTS** as the fix
- [ ] **Link to Unit I: unauthenticated Diffie-Hellman is defeated by MITM**
- [ ] MITM defences: **mutual authentication**, TLS with proper **certificate validation**, certificate pinning, HSTS, DAI, DNSSEC, out-of-band verification
- [ ] **Replay attack**: capture a valid message and resend it
- [ ] Why encryption alone does not stop replay
- [ ] Examples: replayed authentication token, replayed transaction, pass-the-hash
- [ ] Replay defences: **nonces**, **timestamps** (and clock sync), **sequence numbers**, session tokens, **challenge-response**, one-time passwords
- [ ] Replay is one of the four X.800 active attack types (link back to Unit I)

### 16. Protocol-Based Attacks and ARP Poisoning

- [ ] Why TCP/IP is attackable **by design**: no authentication, cleartext, implicit trust, predictable sequence numbers, no integrity
- [ ] The TCP **three-way handshake** and sequence/acknowledgement numbers
- [ ] TCP flag abuse and scanning (SYN, FIN, NULL, XMAS)
- [ ] ICMP-based attacks (redirect, unreachable, smurf)
- [ ] **ARP protocol**: purpose, request/reply, why it is **stateless and unauthenticated**, **gratuitous ARP**
- [ ] **ARP poisoning**: the step-by-step attack (forged replies mapping victim IP to attacker MAC)
- [ ] **Draw the ARP poisoning diagram** (before and after cache state)
- [ ] Consequences: MITM, sniffing on a **switched** network, session hijacking, DoS
- [ ] ARP poisoning vs MAC flooding (different mechanisms, same sniffing goal)
- [ ] Defences: **Dynamic ARP Inspection (DAI)** with **DHCP snooping**, static ARP entries, **arpwatch**, port security, VLAN segmentation, encryption

### 17. DNS Attacks: DNS Spoofing and DNS Poisoning

- [ ] How DNS works: resolver, recursive vs authoritative, iterative queries, TTL, UDP port 53
- [ ] DNS record types (A, NS, MX, CNAME) as needed
- [ ] **DNS spoofing**: forged response to a specific query, race against the real server; scope is one transaction
- [ ] **DNS cache poisoning**: the forged record is **stored in the resolver cache** and served to all clients until TTL expiry
- [ ] **The spoofing vs poisoning distinction** (transient/single victim vs persistent/many victims)
- [ ] Requirements for a successful forgery: correct query ID, port, question section, timing
- [ ] **Kaminsky attack** and the birthday-paradox angle
- [ ] Mitigations: **source-port randomisation** (~16 extra bits), **0x20 encoding**, short TTLs, **DNSSEC** (chain of trust, RRSIG), **DoH/DoT**, restrict recursion
- [ ] Other DNS attacks: **DNS hijacking** (resolver settings changed), domain hijacking/registrar attack, **typosquatting**, **DNS tunnelling** (exfiltration), **DNS amplification**, **NXDOMAIN / water-torture flood**, fast flux, subdomain takeover
- [ ] Why DNSSEC provides integrity but **not** confidentiality

### 18. TCP/IP Hijacking (session hijacking)

- [ ] Definition: taking over an established TCP session
- [ ] **Requirements**: source/destination IP and port, and the correct **sequence number**
- [ ] Sequence number prediction and why old stacks were vulnerable
- [ ] **Mechanism**: inject a spoofed packet with the correct next sequence number
- [ ] **Desynchronisation** and the **ACK storm**
- [ ] **Blind hijacking** vs hijacking with sniffing access
- [ ] **RST hijacking** / connection reset
- [ ] Application-layer session hijacking: **session-cookie theft**, XSS, sidejacking/Firesheep, session fixation
- [ ] Tools to name: Hunt, Juggernaut, Ettercap, Shijack
- [ ] Defences: **random initial sequence numbers (RFC 6528)**, encrypt the session (TLS/SSH/IPsec), TCP timestamps, secure/HttpOnly cookies, session timeouts, re-authentication

## PART C: Defences and Secure Network Design

### 19. Virtual LAN (VLAN)

- [ ] What a VLAN is: a logical broadcast domain independent of physical location
- [ ] **IEEE 802.1Q** tagging, the tag format, VLAN ID
- [ ] **Access ports** (one untagged VLAN) vs **trunk ports** (many tagged VLANs)
- [ ] **Native VLAN** and its risk
- [ ] Static (port-based) vs dynamic VLAN assignment
- [ ] Inter-VLAN routing, router-on-a-stick, SVIs
- [ ] Security benefits: contains broadcast domains, limits sniffing and ARP poisoning blast radius, segments users, enforces policy at routing boundaries
- [ ] **VLAN hopping, both methods**: **switch spoofing** (DTP, attacker pretends to be a trunk) and **double tagging** (two 802.1Q tags, exploits the native VLAN)
- [ ] Defences: disable DTP/auto-trunking, set unused ports to access mode, change the native VLAN to an unused ID, prune allowed VLANs on trunks, disable unused ports
- [ ] **Private VLANs (PVLAN)** and PVLAN edge/protected ports
- [ ] VLAN vs subnet vs physical LAN

### 20. Demilitarized Zone (DMZ)

- [ ] Purpose and definition of a DMZ
- [ ] **The core principle: the Internet never touches the internal network directly**
- [ ] **Architecture 1**: single three-legged firewall (one firewall, three interfaces)
- [ ] **Architecture 2**: dual firewall / **screened subnet** (front-end and back-end firewalls, ideally different vendors)
- [ ] Screened host architecture; **bastion host** (hardened, single-purpose, exposed)
- [ ] What belongs in a DMZ: public web, mail relay, external DNS, FTP, reverse proxy, VPN concentrator
- [ ] What must **not** be in the DMZ: databases, domain controllers, internal file servers
- [ ] **The rule set** (the examinable part): Internet -> DMZ **allow** (specific ports); DMZ -> Internal **DENY** (the critical rule); Internal -> DMZ allow; Internal -> Internet allow; Internet -> Internal **deny**
- [ ] Why the DMZ -> Internal denial is the whole point (a compromised DMZ host gains nothing)
- [ ] **Draw the DMZ diagram** with both architectures
- [ ] **Extranet** as a partner-access zone
- [ ] Defence in depth applied to DMZ design

### 21. Network Access Control (NAC)

- [ ] Definition: decides **whether a device may join the network at all**
- [ ] **Posture assessment / health checks**: antivirus present and updated, OS patch level, host firewall on, disk encryption, no prohibited software, certificate present
- [ ] **Pre-admission vs post-admission** NAC
- [ ] **Agent-based vs agentless** (and dissolvable agents)
- [ ] **IEEE 802.1X**: **supplicant**, **authenticator** (switch/AP), **authentication server** (RADIUS); **EAP** and EAP methods (EAP-TLS, PEAP)
- [ ] The 802.1X message flow, and the port staying unauthorised until success
- [ ] **Enforcement outcomes**: allow full access, **quarantine/remediation VLAN**, restricted/guest access, deny
- [ ] **MAB (MAC Authentication Bypass)** for printers and IoT
- [ ] Guest onboarding and captive portals
- [ ] Benefits: blocks rogue/unmanaged devices, enforces patch hygiene, BYOD control, visibility
- [ ] Challenges: devices that cannot run agents, complexity, cost, failure modes, MAC spoofing bypass

### 22. Proxy Server

- [ ] Definition: an intermediary that terminates and re-originates requests
- [ ] **Forward proxy vs reverse proxy** (who is being protected)
- [ ] Types: transparent, anonymous/high-anonymity, caching, **SOCKS**, **application-level gateway**
- [ ] How a proxy differs from a packet-filtering firewall and from NAT
- [ ] Security functions: hides internal addressing, content inspection and filtering, malware scanning, logging and auditing, authentication and access control, blocks direct connections
- [ ] Performance functions: **caching**, bandwidth saving, load balancing (reverse proxy), SSL/TLS offload
- [ ] Limitations: single point of failure, performance bottleneck, must be protocol-aware, HTTPS needs TLS interception, users can bypass it
- [ ] Cross-link to Unit V (application-level gateways) and to content filtering

### 23. Honeypot

- [ ] Definition and purpose
- [ ] **The defining property: nothing legitimate should ever touch it, so any interaction is suspicious** (hence very few false positives)
- [ ] **Low-interaction vs high-interaction** honeypots
- [ ] **Production vs research** honeypots
- [ ] Placement: outside the firewall, in the DMZ, or inside the network, and what each placement teaches you
- [ ] **Honeynet** and the **honeywall**
- [ ] **Honeytokens**, honeyfiles, honey credentials
- [ ] **Tarpits** (sticky honeypots)
- [ ] Advantages: few false positives, small high-value data volume, captures novel/zero-day techniques, distracts and delays attackers
- [ ] Disadvantages and risks: narrow view (sees only what reaches it), can be **fingerprinted and avoided**, risk of being **used as a pivot** to attack others, maintenance cost
- [ ] Legal and ethical issue: **entrapment** concerns and liability

### 24. NIDS and Host-based Intrusion Prevention (HIPS)

- [ ] **IDS vs IPS**: passive/out-of-band detect-and-alert vs inline detect-and-block
- [ ] IPS placement inline, and the availability risk (a false positive drops good traffic)
- [ ] **NIDS vs HIDS**: what each sees, where each is deployed
- [ ] **NIDS** sensor placement, SPAN/mirror ports, taps
- [ ] NIDS limitations: **encrypted traffic blind spot**, high-speed drops, switched networks, cannot see host-internal activity
- [ ] **HIPS/HIDS**: inspects data on the host after decryption, file integrity, system-call and registry monitoring; the answer to the encryption blind spot
- [ ] **Detection methodologies**: **signature/misuse-based**, **anomaly-based** (with a baseline/profile), **stateful protocol analysis**, heuristic/behavioural
- [ ] Signature vs anomaly: strengths and weaknesses, zero-day detection, false-positive rates
- [ ] **Error terminology, precisely**: true positive, **false positive** (false alarm), true negative, **false negative** (missed attack); which is worse and why
- [ ] Base-rate fallacy and alert fatigue
- [ ] **Evasion techniques**: fragmentation, insertion and evasion, protocol obfuscation, encoding, encryption, low-and-slow, DoS against the sensor
- [ ] Response actions: alert, log, drop, reset, reconfigure firewall
- [ ] Relationship to honeypots and to firewalls (a firewall is not an IDS)

### 25. Protocol Analyzers

- [ ] Definition and purpose (packet sniffers, network analyzers)
- [ ] Tools: **Wireshark**, tcpdump, **Ettercap**, Kismet, Microsoft Network Monitor
- [ ] **Promiscuous mode** (and monitor mode for wireless)
- [ ] Why sniffing was easy on a **hub** and harder on a **switch**
- [ ] Getting the traffic on a switched network: **SPAN / port mirroring**, **network tap**, **ARP poisoning**, MAC flooding
- [ ] Legitimate uses: troubleshooting, baselining, protocol debugging, forensics, IDS signature development
- [ ] Malicious uses: harvesting cleartext credentials, session tokens, confidential data; reconnaissance
- [ ] Detecting sniffers on a network (promiscuous-mode detection, latency tests)
- [ ] Defences: **encrypt everything** (the only real answer), switched infrastructure with port security, VLANs, DAI, disable unused ports

### 26. Internet Content Filters

- [ ] Definition and purpose of content filtering
- [ ] **Filtering methods**: URL/domain **blocklists and allowlists**, **keyword/pattern** matching, **category databases**, **DNS-based filtering / RPZ**, reputation scoring, MIME and file-type blocking, **deep packet inspection**
- [ ] **Deployment points**: proxy server or secure web gateway, firewall/UTM integration, DNS resolver, endpoint agent, cloud/SASE
- [ ] Purposes: acceptable-use and productivity enforcement, blocking malware and phishing, legal compliance and liability, bandwidth control, child protection
- [ ] Limitations: **HTTPS requires TLS inspection** (costly, privacy-invasive, breaks pinning), category databases lag new sites, **over-blocking and under-blocking**
- [ ] Bypass methods: **VPNs, Tor, proxy sites, using an IP instead of a name**, encrypted DNS, URL shorteners
- [ ] Privacy, censorship and ethical concerns; acceptable use policy as the human control
- [ ] Relationship to proxy servers and firewalls

---

# Cross-cutting items to prepare separately

- [ ] The **attack -> countermeasure map** for every Unit II attack (build it as one table and be able to reproduce it)
- [ ] Which **CIA property** each attack violates
- [ ] Which attacks are **passive vs active** in X.800 terms (Unit I framework applied to Unit II attacks)
- [ ] Standards and RFCs to name: **X.800**, RFC 2828, **BCP 38**, **802.1Q**, **802.1X**, RFC 6528, RFC 7296, DNSSEC
- [ ] Port numbers: DNS 53, IKE 500, NAT-T 4500, AH 51, ESP 50 (protocol numbers, not ports)
- [ ] Every **diagram** you may be asked to draw: both Unit I models, X.800 three headings, ESP/AH packet formats, D-H exchange, TCP three-way handshake and SYN flood, ARP poisoning, DNS cache poisoning, DMZ (both architectures), 802.1X flow, IDS placement
- [ ] Compare-and-contrast pairs: passive/active, service/mechanism, specific/pervasive, AH/ESP, transport/tunnel, IDS/IPS, NIDS/HIDS, signature/anomaly, false positive/false negative, DNS spoofing/cache poisoning, forward/reverse proxy, DoS/DDoS, reflection/amplification, blind/non-blind spoofing, switch spoofing/double tagging, single/dual firewall DMZ

---

# Explicitly NOT on the mid-sem

Do not spend any time on these tonight:

- **Units III, IV, V**: cyber law and ethics, Kerberos, X.509, port scanning and knocking, P2P security, email security, PGP, firewalls, packet filters, application-level gateways, encrypted tunnels, cookies. All end-semester.
- **decks/ch02 to ch09**: classical encryption, DES, finite fields, AES, contemporary symmetric ciphers, confidentiality, number theory, public-key and RSA. These are the original Stallings crypto chapters and are off-syllabus. Only **ch01** (introduction, X.800) and **ch10** (Diffie-Hellman) are in scope.
