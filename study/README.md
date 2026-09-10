# NCS Mid-Semester Study Pack

**Scope: Unit I + Unit II only.** 20 marks. Units III–V are end-semester.

## Files, in the order you should use them

| File | Use it for |
|---|---|
| [unit-01-network-security.md](unit-01-network-security.md) | Unit I notes — X.800, both models, Diffie–Hellman, IPsec |
| [unit-02-cyber-security.md](unit-02-cyber-security.md) | Unit II notes — vulnerabilities, attacks, defences (the big one) |
| [cheatsheet-tables-diagrams.md](cheatsheet-tables-diagrams.md) | **Final-hours revision** — every table and diagram on one page |
| [flashcards.md](flashcards.md) | Rapid self-testing; cover the right column |
| [practice-qa.md](practice-qa.md) | Model answers at 2 / 5 / 10-mark length + D-H numericals |
| [mid-sem-topic-checklist.md](mid-sem-topic-checklist.md) | **Complete topic inventory** for Units I + II, tickable, with resource links |
| [deep-dive-ipsec.md](deep-dive-ipsec.md) | Deep dive on IPsec AH/ESP/modes/IKE (checklist topics 7-8), mermaid diagrams |

## Where the material came from

- **Unit I** — grounded in `slides/ch01.md` (security models, X.800, attack
  taxonomy) and `slides/ch10.md` (Diffie–Hellman). Sections marked ⚠ (TCP/IP
  stack, implementation layers, IPsec) are **not in any deck** and were written
  from TB1, Stallings 8e.
- **Unit II** — **no deck exists.** Written entirely from the syllabus topic list
  against TB1 and TB2 (Whitman & Mattord). **Cross-check emphasis with your
  teacher's class notes**, since slide-level detail could not be verified.

`decks/ch02`–`ch09` (classical ciphers, DES, AES, number theory, RSA) are the
original Stallings chapters and are **off-syllabus** — ignore them for this exam.

## Compressed revision plan

**If you have three days**

| Day | Work |
|---|---|
| 1 | Unit I notes end to end. Draw both models from memory. Do D1–D3 numericals. |
| 2 | Unit II Parts A & B (vulnerabilities + attacks). Attack→defence map until fluent. |
| 3 | Unit II Part C (defences). All of `practice-qa.md` under time. Cheat sheet last. |

**If you have one day**

1. `cheatsheet-tables-diagrams.md` — read it twice (45 min)
2. `flashcards.md` — self-test, mark every miss (45 min)
3. `practice-qa.md` Sections B and C — write real answers, don't just read (2 hr)
4. Re-read only the flashcards you missed (30 min)

**If you have two hours** — cheat sheet, then flashcards, then Section A answers.

## The highest-yield topics

Ranked by how reliably they appear:

1. **Passive vs active attacks** + the four active sub-types
2. **X.800** services and specific-vs-pervasive mechanisms
3. **Diffie–Hellman** numerical + the MITM weakness
4. **AH vs ESP**, transport vs tunnel mode
5. **ARP poisoning** — mechanism, diagram, DAI as the fix
6. **DNS spoofing vs cache poisoning** — the scope difference
7. **SYN flood** and SYN cookies
8. **DMZ** — draw it, state the DMZ→Internal denial
9. **IDS vs IPS**, signature vs anomaly, false positive vs negative
10. **VLAN hopping** — both methods

## How to answer for marks

- **2 marks** — two or three precise sentences. Define, then distinguish.
- **5 marks** — a **table** wherever the question says "compare" or
  "distinguish". Tables earn marks faster than prose and are harder to mismark.
- **10 marks** — structure it: definition → mechanism → **diagram** → 
  countermeasures → one-line conclusion. Always draw the diagram; it is often
  worth marks on its own.
- Name the **standard or RFC** where you know it (X.800, BCP 38, 802.1Q, 802.1X,
  RFC 2828) — specificity reads as mastery.
