import re, sys, zlib

def unescape(s):
    out = bytearray(); i = 0
    mp = {0x6e:10,0x72:13,0x74:9,0x62:8,0x66:12,0x28:0x28,0x29:0x29,0x5c:0x5c}
    while i < len(s):
        c = s[i]
        if c == 0x5c and i+1 < len(s):
            n = s[i+1]
            if n in mp: out.append(mp[n]); i += 2; continue
            if 0x30 <= n <= 0x37:
                j = i+1; o = b''
                while j < len(s) and len(o) < 3 and 0x30 <= s[j] <= 0x37:
                    o += bytes([s[j]]); j += 1
                out.append(int(o,8) & 0xFF); i = j; continue
            out.append(n); i += 2; continue
        out.append(c); i += 1
    return bytes(out)

def text_of(operand):
    """Decode the operand of a Tj/TJ: literal strings, hex strings, kerning nums."""
    parts = []
    for m in re.finditer(rb'\((?:\\.|[^\\()])*\)|<[0-9A-Fa-f\s]*>|-?\d+(?:\.\d+)?', operand, re.S):
        tok = m.group(0)
        if tok.startswith(b'('):
            parts.append(unescape(tok[1:-1]).decode('latin-1'))
        elif tok.startswith(b'<'):
            hx = re.sub(rb'[^0-9A-Fa-f]', b'', tok)
            if len(hx) % 2: hx += b'0'
            try: parts.append(bytes.fromhex(hx.decode()).decode('latin-1'))
            except Exception: pass
        else:
            if float(tok) < -180: parts.append(' ')   # wide kern == space
    return ''.join(parts)

data = open(sys.argv[1], 'rb').read()
pages = []
for m in re.finditer(rb'stream\r?\n', data):
    s = m.end(); e = data.find(b'endstream', s)
    if e == -1: continue
    try: ch = zlib.decompress(data[s:e])
    except Exception: continue
    if b'BT' not in ch or b'Tf' not in ch: continue
    sam = ch[:4000]
    if sum(1 for b in sam if 32 <= b < 127 or b in (9,10,13)) < len(sam)*0.85: continue

    lines = {}   # y-coordinate -> list of (x, text)
    for tm in re.finditer(
        rb'1 0 0 1 (-?[\d.]+) (-?[\d.]+) Tm(.*?)(?:ET|Tm)', ch, re.S):
        x, y = float(tm.group(1)), float(tm.group(2))
        body = tm.group(3)
        for op in re.finditer(rb'(\[.*?\]|\(.*?\))\s*(TJ|Tj)', body, re.S):
            t = text_of(op.group(1))
            if t.strip(): lines.setdefault(round(y, 1), []).append((x, t))
    if not lines: continue
    out = []
    for y in sorted(lines, reverse=True):          # top of page downward
        row = sorted(lines[y], key=lambda p: p[0])  # left to right
        out.append(''.join(t for _, t in row))
    pages.append('\n'.join(out))

for i, p in enumerate(pages, 1):
    print(f"\n{'='*70}\n--- PAGE {i} ---\n{'='*70}")
    print(p)
