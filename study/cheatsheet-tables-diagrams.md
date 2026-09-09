# NCS Mid-Sem — One-Page Cheat Sheet

Every comparison table and diagram worth memorising, in one place.
For the reasoning behind them see `unit-01-network-security.md` and
`unit-02-cyber-security.md`.

---

## The X.800 tree

```
                    OSI Security Architecture (X.800)
                                 |
        +------------------------+------------------------+
        |                        |                        |
  Security ATTACK        Security MECHANISM         Security SERVICE
        |                        |                        |
  +-----+-----+          +-------+-------+          Authentication
  |           |          |               |          Access Control
Passive     Active   Specific        Pervasive      Confidentiality
  |           |      (8, layer-      (5, not        Integrity
  |           |       bound)          layer-bound)  Non-repudiation
  |           |
  |           +-- Masquerade / Replay / Modification / DoS
  +-- Release of message contents / Traffic analysis
```

**Specific mechanisms (8):** Encipherment · Digital signature · Access control ·
Data integrity · Authentication exchange · Traffic padding · Routing control ·
Notarization

**Pervasive mechanisms (5):** Trusted functionality · Security labels ·
Event detection · Security audit trail · Security recovery

## Passive vs active — the mirror

| | Passive | Active |
|---|---|---|
| Data altered | No | Yes |
| Detect | **Hard** | Easy |
| Prevent | Easy | **Hard** |
| Strategy | **Prevent** | **Detect & recover** |

## Two models of Unit I

| | Network Security model | Network **Access** Security model |
|---|---|---|
| Protects | Data **in transit** | **Resources on a system** |
| Threat | Opponent on the channel | Hacker, virus, worm |
| Key element | Security transformation + trusted third party | **Gatekeeper** + internal controls |
| Tasks | 4 (algorithm, keys, distribution, protocol) | 2 (gatekeeper functions, access controls) |

## Diffie–Hellman in five lines

```
Public:   prime q, primitive root α
Alice:    private xA  ->  public yA = α^xA mod q
Bob:      private xB  ->  public yB = α^xB mod q
Shared:   K = yB^xA = yA^xB = α^(xA·xB) mod q
Security: discrete logarithm problem.  WEAKNESS: MITM (unauthenticated)
```

Stallings example: `q=353, α=3, xA=97, xB=233` → `yA=40, yB=248`, **K = 160**

## IPsec at a glance

| | **AH** (51) | **ESP** (50) |
|---|---|---|
| Encryption | ✗ | ✓ |
| Integrity/auth | ✓ | ✓ (optional) |
| Anti-replay | ✓ | ✓ |
| Outer IP header authenticated | ✓ | ✗ |
| NAT | ✗ breaks | ✓ with NAT-T |

| | **Transport mode** | **Tunnel mode** |
|---|---|---|
| Protects | Payload only | **Entire packet** |
| New IP header | No | **Yes** |
| Use | Host-to-host, end-to-end | **Gateway VPN**, site-to-site |
| Hides endpoints | No | **Yes** |

**SA triple:** (SPI, destination IP, protocol) · one-way · SAD + SPD
**IKE:** UDP 500/4500 · ISAKMP + Oakley + SKEME · Phase 1 (main 6 / aggressive 3)
= IKE SA · Phase 2 (quick, 3) = IPsec SA

## Security layer trade-off

```
  Application (PGP)   ^  more granular, end-to-end, per-user
  Transport   (TLS)   |  ...but must modify applications
  Network     (IPsec) |
  Data link   (WPA2)  v  more transparent, covers all traffic
                         ...but coarser, per-hop only
```

## DoS families

| Volumetric | Protocol/state | Application |
|---|---|---|
| UDP/ICMP flood, amplification | **SYN flood**, Ping of Death, Smurf, LAND, Teardrop | HTTP flood, **Slowloris** |
| Saturates **bandwidth** | Exhausts **connection tables** | Exhausts **the app** |

**Amplification factors:** DNS ~50× · NTP ~550× · memcached ~50,000×

## Attack → defence quick map

| Attack | Primary defence |
|---|---|
| ARP poisoning | **Dynamic ARP Inspection** + DHCP snooping |
| DNS cache poisoning | **DNSSEC** + source-port randomisation |
| SYN flood | **SYN cookies** |
| Smurf | Disable **directed broadcasts** |
| IP spoofing | **Ingress filtering (BCP 38)**, uRPF |
| Session hijacking | **Random ISNs** + encrypt the session |
| MITM | **Mutual authentication**, cert validation, HSTS |
| Replay | **Nonce / timestamp / sequence number** |
| VLAN hopping (switch spoofing) | Disable **DTP** |
| VLAN hopping (double tagging) | Change **native VLAN**, avoid VLAN 1 |
| Sniffing | **Encryption** (sniffing itself is undetectable) |
| Rogue device on LAN | **NAC / 802.1X** |

## DMZ traffic rules

```
Internet ---[ FW1 ]--- DMZ ---[ FW2 ]--- Internal LAN
```

| Internet→DMZ | Internet→Internal | Internal→DMZ | **DMZ→Internal** |
|---|---|---|---|
| ✓ specific ports | ✗ **denied** | ✓ | ✗ **denied** ← the whole point |

## IDS / IPS / NIDS / HIDS

| | IDS | IPS |
|---|---|---|
| Position | Out-of-band (SPAN/tap) | **Inline** |
| Action | Alert | **Block** |

| | NIDS | HIDS |
|---|---|---|
| Scope | Network segment | One host |
| Blind to | **Encrypted traffic** | Anything off that host |

| Detection | Catches zero-day? | False positives |
|---|---|---|
| **Signature** | ✗ No | Low |
| **Anomaly** | ✓ Yes | **High** |

**False positive** = benign flagged · **False negative** = attack **missed** (worse)

## 802.1X three roles

```
  Supplicant  <-->  Authenticator  <-->  Authentication Server
  (client)          (switch / AP)         (RADIUS)
        <------------ EAP ------------>
```
NAC outcomes: **Allow · Quarantine (remediation VLAN) · Deny · Restrict**

## Proxy directions

| Forward proxy | Reverse proxy |
|---|---|
| In front of **clients** | In front of **servers** |
| Hides the client | Hides the server |
| Filtering, caching, monitoring | Load balancing, TLS offload, WAF |

## Honeypot types

| By interaction | By purpose |
|---|---|
| **Low** — emulated, safe, limited data | **Production** — divert & detect |
| **High** — real OS, rich data, **risky** | **Research** — study attackers |

Defining property: **no production value → any interaction is suspicious**

## Media security ranking

```
  Wireless  <  UTP copper  <  STP copper  <  Fibre optic
  (worst)                                      (best)
  broadcast    EMI + inductive tap    must bend/splice, no EMI
```
