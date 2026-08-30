"""Leitura e escrita do container .amxd — três chunks com tamanho little-endian.
   Verificado contra o 'Max MIDI Effect.amxd' de fábrica, byte a byte."""
import struct, json

def read(path):
    raw = open(path, 'rb').read()
    pos, chunks = 0, {}
    while pos < len(raw):
        tag = raw[pos:pos+4].decode('ascii', 'replace')
        size = struct.unpack('<I', raw[pos+4:pos+8])[0]
        chunks[tag] = raw[pos+8:pos+8+size]
        pos += 8 + size
    return json.loads(chunks['ptch'].rstrip(b'\x00').decode('utf-8'))

def write(path, patcher):
    js = json.dumps(patcher, indent=1, ensure_ascii=False).encode('utf-8') + b'\x00'
    out = (b"ampf" + struct.pack('<I', 4) + b"mmmm"
         + b"meta" + struct.pack('<I', 4) + b"\x00\x00\x00\x00"
         + b"ptch" + struct.pack('<I', len(js)) + js)
    open(path, 'wb').write(out)
    return len(out)
