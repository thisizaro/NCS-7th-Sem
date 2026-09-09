---
name: ncs-decks-syllabus-mismatch
description: The ch01-ch10 decks are Stallings crypto chapters, not the NCS syllabus units - Unit II has no slides
metadata:
  type: project
---

The ten `.ppt` decks in this repo are the **original Stallings 4/e cryptography
chapters** (Lawrie Brown's overheads), NOT the NCS syllabus units. Verified by
extracting slide titles, 2026-09-09.

`ch01` Introduction/OSI Security Architecture · `ch02` Classical Encryption ·
`ch03` DES · `ch04` Finite Fields · `ch05` AES · `ch06` Contemporary Symmetric
Ciphers · `ch07` Confidentiality · `ch08` Number Theory · `ch09` Public-Key/RSA ·
`ch10` Key Management + Diffie-Hellman

Against the mid-sem scope ([[ncs-mid-sem-exam-scope]]) this means:

- **Unit I** — only partly covered: `ch01` supplies the network-security and
  network-access-security models plus the attack taxonomy; `ch10` supplies
  Diffie-Hellman. TCP/IP stack and IPsec (AH/ESP/IKE) appear in **no deck**.
- **Unit II** — **no deck whatsoever.** All 12 lectures of it.
- `ch02`-`ch09` are off-syllabus and not examinable; kept for reference only.

Do not assume a deck exists for a topic. Check `slides/*.md` before citing one.
