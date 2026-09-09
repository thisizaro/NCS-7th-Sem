# NCS — Network and Cyber Security (CS40017)

7th Semester, School of Computer Engineering, KIIT.
Course teacher: Prof. (Dr.) Prachet Bhuyan. Contact: 3 hrs/week (LTP 3-0-0).

**Marks:** Internal 30 + Mid-semester 20 + End-semester 50 = 100.

## Syllabus units

| Unit | Topic | Lectures | Mid-sem? |
|---|---|---:|---|
| I | Intro to Network Security; models for network & network-access security; real-time communication security; TCP/IP protocol stack; implementation layers for security protocols; **Diffie-Hellman**; IPsec (AH, ESP, IKE) | 6 | yes |
| II | Cyber Security: media-based & network-device vulnerabilities; back doors; DoS; spoofing; MITM & replay; protocol-based attacks; DNS attack/spoofing/poisoning; ARP poisoning; TCP/IP hijacking; VLAN; DMZ; NAC; proxy server; honeypot; NIDS/HIPS; protocol analyzers; internet content filters | 12 | yes |
| III | Cyber Law and Ethics: policy vs. law; types of law; computer crime laws; US copyright law; UK computer security laws; ethics & education; codes of ethics | 4 | no |
| IV | Authentication: Kerberos; X.509; port scanning; port knocking; P2P security; email security (privacy, source auth, integrity, non-repudiation, proof of submission/delivery, anonymity); PGP | 10 | no |
| V | Firewalls and Web Security: packet filters; application-level gateways; encrypted tunnels; cookies | 4 | no |

**Mid-semester exam covers Units I and II only.**

## Course outcomes

- **CO1** Distinguish and analyze network / network-layer security such as IPSec
- **CO2** Analyze and evaluate the cyber security needs of an organization
- **CO3** Assess threats and vulnerabilities of a network, explain countermeasures
- **CO4** Illustrate legal, ethical and professional issues in cyber security
- **CO5** Assess authentication in networks and secure mail services
- **CO6** Justify the usage of firewalls and gateways

## Textbooks

- **TB1** Stallings, *Cryptography and Network Security: Principles and Practice*, 8e, Pearson 2023
- **TB2** Whitman & Mattord, *Principles of Information Security*, 7e, Cengage 2023
- R1 Kahate, *Cryptography and Network Security*, 4e · R3 Kaufman/Perlman/Speciner, *Network Security: Private Communication in a Public World*, 3e

## Important: the decks do not match the syllabus

`decks/ch01..ch10.ppt` are the **original Stallings 4/e cryptography chapters**, not the NCS units:

`ch01` Introduction/OSI Security Architecture · `ch02` Classical Encryption · `ch03` DES · `ch04` Finite Fields · `ch05` AES · `ch06` Contemporary Symmetric Ciphers · `ch07` Confidentiality · `ch08` Number Theory · `ch09` Public-Key & RSA · `ch10` Key Management + **Diffie-Hellman**

Only `ch01` (security models, OSI architecture, attack taxonomy) and `ch10` (Diffie-Hellman) are on the mid-sem syllabus. **Unit II has no deck at all** — the notes in `study/` cover it from TB1/TB2 knowledge instead. `ch02`-`ch09` are off-syllabus and kept only for reference.

## Repo layout

```
decks/      original .ppt lecture slides (source of truth)
slides/     decks converted to Markdown, incl. Lawrie Brown's speaker notes
syllabus/   official syllabus PDF + extracted text
study/      exam material: notes, practice Q&A, tables, flashcards
scripts/    setup-sync.sh, extract-slides.ps1, pdf-to-text.py
.claude/memory/   Claude's memory, synced through this repo
```

## Working in this repo

- Study material lives in `study/`, organized **by syllabus unit**, never by deck number.
- When citing a deck, reference the Markdown (`slides/ch01.md`), not the binary `.ppt`.
- Re-extract slides with `scripts/extract-slides.ps1` (needs Windows PowerPoint via WSL interop).
- **New machine:** clone, then `bash scripts/setup-sync.sh` to link Claude's memory directory.
