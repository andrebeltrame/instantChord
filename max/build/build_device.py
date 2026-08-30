#!/usr/bin/env python3
"""Gera max/InstantChord.amxd.

O container .amxd é escrito por amxd.py, cujo formato foi verificado byte a
byte contra o 'Max MIDI Effect.amxd' de fábrica. O patcher em si é montado
aqui para poder ser versionado e regerado — editar JSON de patcher na mão é
caminho para erro silencioso.
"""
import os, sys, json
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import amxd

HERE = os.path.dirname(os.path.abspath(__file__))
OUT  = os.path.join(HERE, "..", "InstantChord.amxd")

# ── medidas do painel ───────────────────────────────────────────────────
W, H = 616, 148
boxes, lines = [], []
_n = [0]

def nid():
    _n[0] += 1
    return "obj-%d" % _n[0]

def add(box, px=None, py=None, pw=None, ph=None):
    """Registra a caixa; se receber coordenadas, também a mostra no painel."""
    if px is not None:
        box["presentation"] = 1
        box["presentation_rect"] = [float(px), float(py), float(pw), float(ph)]
    boxes.append({"box": box})
    return box["id"]

def link(src, sout, dst, din=0):
    lines.append({"patchline": {"destination": [dst, din], "source": [src, sout]}})

# posição no canvas de edição — só para o patch não virar um novelo
_row = [20]
def pat(w=140, h=22):
    y = _row[0]; _row[0] += 30
    return [30.0, float(y), float(w), float(h)]

def newobj(text, ins=1, outs=1, outtypes=None, rect=None):
    return {"id": nid(), "maxclass": "newobj", "text": text,
            "numinlets": ins, "numoutlets": outs,
            "outlettype": outtypes if outtypes is not None else [""] * outs,
            "patching_rect": rect or pat()}

def comment(text, w=200, fontsize=None):
    b = {"id": nid(), "maxclass": "comment", "text": text,
         "numinlets": 1, "numoutlets": 0, "patching_rect": pat(w, 20)}
    if fontsize: b["fontsize"] = float(fontsize)
    return b

def live_comment(text, w=90):
    return {"id": nid(), "maxclass": "live.comment", "text": text,
            "numinlets": 1, "numoutlets": 0, "textjustification": 0,
            "patching_rect": pat(w, 18)}

def live_dial(longname, short, init, unit=1):
    return {"id": nid(), "maxclass": "live.dial",
            "numinlets": 1, "numoutlets": 2, "outlettype": ["", "float"],
            "parameter_enable": 1, "patching_rect": pat(48, 48),
            "varname": longname,
            "saved_attribute_attributes": {"valueof": {
                "parameter_initial": [init], "parameter_initial_enable": 1,
                "parameter_longname": longname, "parameter_shortname": short,
                "parameter_mmin": 0.0, "parameter_mmax": 1.0,
                "parameter_modmode": 0, "parameter_type": 0,
                "parameter_unitstyle": unit}}}

def live_numbox(longname, short, init, mn, mx):
    return {"id": nid(), "maxclass": "live.numbox", "appearance": 1,
            "numinlets": 1, "numoutlets": 2, "outlettype": ["", "float"],
            "parameter_enable": 1, "patching_rect": pat(56, 17),
            "varname": longname,
            "saved_attribute_attributes": {"valueof": {
                "parameter_initial": [init], "parameter_initial_enable": 1,
                "parameter_longname": longname, "parameter_shortname": short,
                "parameter_mmin": mn, "parameter_mmax": mx,
                "parameter_modmode": 0, "parameter_type": 1,
                "parameter_unitstyle": 0}}}

def live_toggle(longname, short, init):
    return {"id": nid(), "maxclass": "live.toggle",
            "numinlets": 1, "numoutlets": 1, "outlettype": [""],
            "parameter_enable": 1, "patching_rect": pat(15, 15),
            "varname": longname,
            "saved_attribute_attributes": {"valueof": {
                "parameter_enum": ["off", "on"], "parameter_initial": [init],
                "parameter_initial_enable": 1,
                "parameter_longname": longname, "parameter_shortname": short,
                "parameter_mmax": 1, "parameter_modmode": 0, "parameter_type": 2}}}

def live_button(longname, label):
    return {"id": nid(), "maxclass": "live.text", "mode": 0,
            "numinlets": 1, "numoutlets": 2, "outlettype": ["", ""],
            "parameter_enable": 1, "patching_rect": pat(70, 20),
            "varname": longname,
            "saved_attribute_attributes": {"valueof": {
                "parameter_enum": [label, label], "parameter_initial": [0],
                "parameter_initial_enable": 1,
                "parameter_longname": longname, "parameter_shortname": label,
                "parameter_mmax": 1, "parameter_modmode": 0, "parameter_type": 2}}}

def textedit():
    return {"id": nid(), "maxclass": "textedit", "outputmode": 1, "bangmode": 1,
            "numinlets": 1, "numoutlets": 4, "outlettype": ["", "int", "", ""],
            "parameter_enable": 0, "tabmode": 0, "fontsize": 13.0,
            "fontname": "Ableton Sans Medium", "text": "Fm Eb Db Ab",
            "bgcolor": [0.13, 0.13, 0.13, 1.0],
            "textcolor": [0.85, 0.85, 0.85, 1.0],
            "bordercolor": [0.29, 0.29, 0.29, 1.0],
            "patching_rect": pat(300, 24)}

# ═══ o motor ════════════════════════════════════════════════════════════
JS = add(newobj("js instantchord.js @autowatch 1", 1, 2, ["", ""], [420.0, 300.0, 200.0, 22.0]))

# ═══ passagem de MIDI ═══════════════════════════════════════════════════
MIN  = add(newobj("midiin", 1, 1))
MOUT = add(newobj("midiout", 1, 0, []))
MFMT = add(newobj("midiformat", 8, 1))
link(MIN, 0, MOUT)
link(JS, 0, MFMT)          # audição: lista (pitch, velocity)
link(MFMT, 0, MOUT)

# ═══ linha 1 — cifras e ações ═══════════════════════════════════════════
add(comment("CIFRAS", 60, 9), 8, 5, 60, 12)
TE = add(textedit(), 8, 19, 300, 24)
PRE_C = add(newobj("prepend cifras"))
link(TE, 0, PRE_C); link(PRE_C, 0, JS)

def action(varname, label, msg, px, py, pw=70, ph=24):
    b = add(live_button(varname, label), px, py, pw, ph)
    p = add(newobj("prepend " + msg))
    link(b, 0, p); link(p, 0, JS)
    return b

action("Escrever",  "Escrever no clip", "escrever", 314, 19, 118, 24)
action("Ouvir",     "Ouvir",            "tocar",    436, 19, 56, 24)
action("Parar",     "Parar",            "parar",    496, 19, 52, 24)
action("Variar",    "Variar",           "variar",   552, 19, 56, 24)

# ═══ linha 2 — tom e leitura ════════════════════════════════════════════
C_TOM  = add(comment("—", 130, 11), 8, 51, 120, 16)
action("Relativa", "relativa", "relativa", 132, 49, 76, 20)
C_INFO = add(comment("—", 380, 11), 216, 51, 392, 16)

ROUTE = add(newobj("route tom cifras info", 1, 4, ["", "", "", ""]))
link(JS, 1, ROUTE)
for i, dest in enumerate([C_TOM, TE, C_INFO]):
    s = add(newobj("prepend set"))
    link(ROUTE, i, s); link(s, 0, dest)

# ═══ linha 3 — os macros ════════════════════════════════════════════════
DIALS = [("Toque", "Toque", "toque", 0.0), ("Abertura", "Abertura", "abertura", 0.0),
         ("Ritmo", "Ritmo", "ritmo", 0.08), ("Gate", "Gate", "gate", 0.70),
         ("Humanizar", "Humanize", "humanizar", 0.12)]
for i, (ln, sn, msg, init) in enumerate(DIALS):
    d = add(live_dial(ln, sn, init), 8 + i * 58, 74, 48, 48)
    p = add(newobj("prepend " + msg))
    link(d, 0, p); link(p, 0, JS)

# compassos
NB = add(live_numbox("Compassos", "Compassos", 4, 1, 8), 306, 78, 56, 17)
p = add(newobj("prepend compassos")); link(NB, 0, p); link(p, 0, JS)
add(live_comment("compassos", 70), 306, 98, 70, 16)

# suavizar / baixo
for i, (ln, msg, init) in enumerate([("Suavizar", "suavizar", 1), ("Baixo", "baixo", 1)]):
    t = add(live_toggle(ln, ln, init), 386, 78 + i * 22, 15, 15)
    p = add(newobj("prepend " + msg))
    link(t, 0, p); link(p, 0, JS)
    add(live_comment(ln.lower(), 70), 406, 78 + i * 22, 70, 16)

# direção
for i, d in enumerate(["up", "down", "updown", "rand"]):
    b = add(live_button("Dir" + d, {"up": "↑", "down": "↓", "updown": "↕", "rand": "rnd"}[d]),
            470 + i * 36, 78, 34, 20)
    m = add(newobj("prepend direcao " + d))
    link(b, 0, m); link(m, 0, JS)
add(live_comment("direção", 70), 470, 100, 70, 16)

# ═══ inicialização ══════════════════════════════════════════════════════
THIS = add(newobj("live.thisdevice", 1, 3, ["bang", "bang", ""]))
link(THIS, 0, JS)

add(comment("InstantChord v0.1 — o motor é instantchord.js, ao lado deste arquivo.", 420, 10),
    8, 126, 480, 14)

# ═══ patcher ════════════════════════════════════════════════════════════
patcher = {"patcher": {
    "fileversion": 1,
    "appversion": {"major": 8, "minor": 1, "revision": 2,
                   "architecture": "x64", "modernui": 1},
    "classnamespace": "box",
    "rect": [65.0, 100.0, 700.0, 560.0],
    "openrect": [0.0, 0.0, float(W), float(H)],
    "bglocked": 0,
    "openinpresentation": 1,
    "default_fontsize": 12.0,
    "default_fontface": 0,
    "default_fontname": "Arial",
    "gridonopen": 1,
    "gridsize": [15.0, 15.0],
    "gridsnaponopen": 1,
    "objectsnaponopen": 1,
    "statusbarvisible": 2,
    "toolbarvisible": 1,
    "lefttoolbarpinned": 0, "toptoolbarpinned": 0,
    "righttoolbarpinned": 0, "bottomtoolbarpinned": 0,
    "toolbars_unpinned_last_save": 0,
    "tallnewobj": 0, "boxanimatetime": 200,
    "enablehscroll": 1, "enablevscroll": 1,
    "devicewidth": 0.0,
    "description": "Gerador de progressões — digite as cifras e escreva no clip",
    "digest": "", "tags": "", "style": "", "subpatcher_template": "",
    "assistshowspatchername": 0,
    "boxes": boxes,
    "lines": lines,
    "dependency_cache": [],
    "autosave": 0,
}}

size = amxd.write(OUT, patcher)

# Mesma coisa como .maxpat, para abrir e editar direto no Max.
MAXPAT = os.path.join(HERE, "..", "InstantChord.maxpat")
with open(MAXPAT, "w") as f:
    json.dump(patcher, f, indent=1, ensure_ascii=False)

print("InstantChord.amxd  %d bytes  ·  %d objetos, %d conexões"
      % (size, len(boxes), len(lines)))
print("InstantChord.maxpat gerado ao lado, para inspeção no Max")

# relê e valida
back = amxd.read(OUT)["patcher"]
assert len(back["boxes"]) == len(boxes) and len(back["lines"]) == len(lines)
ids = set(b["box"]["id"] for b in back["boxes"])
for l in back["lines"]:
    for end in ("source", "destination"):
        assert l["patchline"][end][0] in ids, "conexão órfã: %s" % l
print("releitura ok · todas as conexões apontam para objetos existentes")
