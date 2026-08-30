/* ────────────────────────────────────────────────────────────────────────
   InstantChord — motor + cola do Max for Live.

   ES5 puro, de propósito: o mesmo arquivo roda no objeto `js` do Max, no
   `v8` do Max 9 e no Node (para o teste de paridade com o protótipo).
   Nada de const/let, arrow, template string, spread, Set ou includes.

   O motor é uma tradução direta de prototype/instantchord.html. Qualquer
   divergência é bug — max/test/parity.js compara os dois.
   ──────────────────────────────────────────────────────────────────────── */

var IC = (function () {

/* ═══ 1. TEORIA ═══════════════════════════════════════════════════════ */

var NAMES_S = ["C","C#","D","D#","E","F","F#","G","G#","A","A#","B"];
var NAMES_F = ["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"];

var SCALES = {
  major: { label:"Maior", steps:[0,2,4,5,7,9,11] },
  minor: { label:"Menor", steps:[0,2,3,5,7,8,10] }
};

var REL_MAJOR  = { major:0, minor:3 };
var FLAT_MAJORS = [5,10,3,8,1,6];          // F Bb Eb Ab Db Gb
var ROMAN = ["I","II","III","IV","V","VI","VII"];

function has(arr, v){ return arr.indexOf(v) >= 0; }
function mod12(n){ return ((n % 12) + 12) % 12; }

function useFlats(root, scale){
  return has(FLAT_MAJORS, mod12(root + (REL_MAJOR[scale] || 0)));
}

function noteName(pc, root, scale){
  return (useFlats(root, scale || "major") ? NAMES_F : NAMES_S)[mod12(pc)];
}

function step(scaleKey, i){
  var s = SCALES[scaleKey].steps;
  return s[((i % 7) + 7) % 7] + 12 * Math.floor(i / 7);
}

function functionOf(deg, scaleKey){
  var s = SCALES[scaleKey].steps;
  var minorTonic = s[2] === 3;
  var leadingTone = s[6] === 11;
  if (deg === 5) return "dom";
  if (deg === 7) return leadingTone ? "dom" : "sub";
  if (deg === 2 || deg === 4) return "sub";
  if (deg === 6) return minorTonic ? "sub" : "tonic";
  return "tonic";
}

function chordIndices(slot){
  var idx = [0,2,4];
  if (slot.sus === 2) idx[1] = 1;
  else if (slot.sus === 4) idx[1] = 3;
  if (slot.ext >= 7)  idx.push(6);
  if (slot.ext >= 9)  idx.push(8);
  if (slot.ext >= 11) idx.push(10);
  if (slot.ext >= 13) idx.push(12);
  return idx;
}

function center(pitches){
  var shift = 0, i, out = [];
  while (pitches[0] + shift > 66) shift -= 12;
  while (pitches[0] + shift < 54) shift += 12;
  for (i = 0; i < pitches.length; i++) out.push(pitches[i] + shift);
  return out;
}

function quality(semis, slot){
  var third = semis[1], fifth = semis[2], q = "", e = "", sev = semis[3];
  if (slot.sus) q = "sus" + slot.sus;
  else if (third === 3 && fifth === 6) q = "dim";
  else if (third === 3) q = "m";
  else if (third === 4 && fifth === 8) q = "aug";
  if (slot.ext >= 7)  e = (sev === 11 ? "maj7"  : "7");
  if (slot.ext >= 9)  e = (sev === 11 ? "maj9"  : "9");
  if (slot.ext >= 11) e = (sev === 11 ? "maj11" : "11");
  if (slot.ext >= 13) e = (sev === 11 ? "maj13" : "13");
  return q + e;
}

function roman(semis, slot){
  var third = semis[1], fifth = semis[2];
  var minorish = !slot.sus && third === 3;
  var r = minorish ? ROMAN[slot.deg-1].toLowerCase() : ROMAN[slot.deg-1];
  if (!slot.sus && third === 3 && fifth === 6) r += "°";
  if (!slot.sus && third === 4 && fifth === 8) r += "+";
  if (slot.sus) r += "sus" + slot.sus;
  if (slot.ext > 5) r += (semis[3] === 11 ? "maj" : "") + slot.ext;
  return r;
}

function buildChord(slot, st){
  if (slot.mode === "abs") return buildLiteral(slot, st);
  var idx = chordIndices(slot), d = slot.deg - 1;
  var rootSemi = step(st.scale, d), raw = [], semis = [], i;
  for (i = 0; i < idx.length; i++){
    raw.push(60 + st.root + step(st.scale, d + idx[i]));
    semis.push(step(st.scale, d + idx[i]) - rootSemi);
  }
  return {
    pitches: center(raw),
    rootPc: mod12(st.root + rootSemi),
    bassPc: null,
    quality: quality(semis, slot),
    sym: null,
    roman: roman(semis, slot),
    fn: functionOf(slot.deg, st.scale),
    diatonic: true
  };
}

function buildLiteral(slot, st){
  var r = analyse(slot, st), raw = [], i;
  for (i = 0; i < slot.ivs.length; i++) raw.push(60 + slot.rootPc + slot.ivs[i]);
  return {
    pitches: center(raw),
    rootPc: slot.rootPc,
    bassPc: slot.bassPc,
    quality: "",
    sym: slot.token,
    roman: r.roman,
    fn: r.fn,
    diatonic: r.diatonic
  };
}

function symbol(ch, st){
  return ch.sym ? ch.sym : noteName(ch.rootPc, st.root, st.scale) + ch.quality;
}

/* ═══ 2. CIFRAS ═══════════════════════════════════════════════════════ */

var LETTER_PC = { c:0, d:2, e:4, f:5, g:7, a:9, b:11 };

function parseChordSymbol(raw){
  var token = String(raw).replace(/^\s+|\s+$/g, "");
  var s = token
    .replace(/[Δ∆]/g, "maj7")
    .replace(/[øØ]/g, "m7b5")
    .replace(/[°º]/g, "dim")
    .replace(/♯/g, "#").replace(/♭/g, "b")
    .replace(/[–—−]/g, "-")
    .replace(/\s+/g, "");
  var m = /^([A-Ga-g])([#b]*)(.*)$/.exec(s);
  if (!m) return null;

  var rootPc = LETTER_PC[m[1].toLowerCase()], i;
  for (i = 0; i < m[2].length; i++) rootPc += (m[2].charAt(i) === "#" ? 1 : -1);
  rootPc = mod12(rootPc);

  var q = m[3], bassPc = null;
  var slash = /\/([A-Ga-g])([#b]*)$/.exec(q);
  if (slash){
    bassPc = LETTER_PC[slash[1].toLowerCase()];
    for (i = 0; i < slash[2].length; i++) bassPc += (slash[2].charAt(i) === "#" ? 1 : -1);
    bassPc = mod12(bassPc);
    q = q.slice(0, slash.index);
  }

  var alts = [];
  q = q.replace(/add(9|11|13)/gi, function(t){ alts.push(t.toLowerCase()); return ""; });
  q = q.replace(/(b5|#5|b9|#9|#11|b13)/g, function(t){ alts.push(t); return ""; });
  var sus = /sus2/i.test(q) ? 2 : (/sus/i.test(q) ? 4 : 0);
  q = q.replace(/sus[24]?/gi, "");
  var sixNine = /(6\/9|69)/.test(q);
  q = q.replace(/(6\/9|69)/g, "");

  var upperM = /^M(?![a-z])/.test(q);
  var isMaj7 = upperM || /maj/i.test(q);
  var isMin  = !isMaj7 && /^(-|min|m(?!aj))/i.test(q);
  var isDim  = /dim/i.test(q);
  var isAug  = /(aug|\+)/i.test(q);
  var ext    = /13/.test(q) ? 13 : (/11/.test(q) ? 11 : (/9/.test(q) ? 9 : (/7/.test(q) ? 7 : 0)));
  var six    = !ext && /6/.test(q);

  var ivs;
  if (sus === 2)      ivs = [0,2,7];
  else if (sus === 4) ivs = [0,5,7];
  else if (isDim)     ivs = [0,3,6];
  else if (isAug)     ivs = [0,4,8];
  else if (isMin)     ivs = [0,3,7];
  else                ivs = [0,4,7];

  if (six || sixNine) ivs.push(9);
  if (ext >= 7){
    if (isDim && !has(alts, "b5")) ivs.push(9);
    else if (isMaj7) ivs.push(11);
    else ivs.push(10);
  }
  if (ext >= 9 || sixNine) ivs.push(14);
  if (ext === 11 || (ext === 13 && isMin)) ivs.push(17);
  if (ext >= 13) ivs.push(21);
  if (has(alts, "add9"))  ivs.push(14);
  if (has(alts, "add11")) ivs.push(17);
  if (has(alts, "add13")) ivs.push(21);

  function swap(from, to){
    var k = ivs.indexOf(from);
    if (k >= 0) ivs[k] = to; else ivs.push(to);
  }
  if (has(alts, "b5"))  swap(7, 6);
  if (has(alts, "#5"))  swap(7, 8);
  if (has(alts, "b9"))  swap(14, 13);
  if (has(alts, "#9"))  swap(14, 15);
  if (has(alts, "#11")) swap(17, 18);
  if (has(alts, "b13")) swap(21, 20);

  var uniq = [];
  ivs.sort(function(a,b){ return a-b; });
  for (i = 0; i < ivs.length; i++) if (uniq.indexOf(ivs[i]) < 0) uniq.push(ivs[i]);

  return { mode:"abs", rootPc:rootPc, ivs:uniq, bassPc:bassPc, token:token };
}

function writeChordSymbol(c, keyRoot, keyScale){
  function h(n){ return has(c.ivs, n); }
  var isSus = !h(3) && !h(4);
  var dim = h(3) && h(6);
  var aug = h(4) && h(8) && !h(7);
  var adds = [], base, ext = "";

  if (isSus)             base = h(2) ? "sus2" : (h(5) ? "sus4" : "5");
  else if (dim && h(10)) base = "m7b5";
  else if (dim && h(9))  base = "dim7";
  else if (dim)          base = "dim";
  else if (aug)          base = "aug";
  else if (h(3))         base = "m";
  else                   base = "";

  if (!/m7b5|dim7/.test(base)){
    if (h(10) || h(11)){
      var top = h(21) ? 13 : (h(17) ? 11 : (h(14) ? 9 : 7));
      ext = (h(11) ? "maj" : "") + top;
    }
    else if (h(9) && h(14)) ext = "6/9";
    else if (h(9))          ext = "6";
    else if (h(14))         adds.push("add9");
  }
  if (h(13) && !h(14))        adds.push("b9");
  if (h(15) && !h(14))        adds.push("#9");
  if (h(18) && !h(17))        adds.push("#11");
  if (h(20) && !h(21))        adds.push("b13");
  if (h(6) && !dim && !isSus) adds.push("b5");
  if (h(8) && h(7))           adds.push("#5");

  var out = noteName(c.rootPc, keyRoot, keyScale) + base + ext + adds.join("");
  if (c.bassPc !== null && c.bassPc !== c.rootPc) out += "/" + noteName(c.bassPc, keyRoot, keyScale);
  return out;
}

function parseProgression(text){
  var slots = [], bad = [];
  var toks = String(text).replace(/^\s+|\s+$/g, "").split(/[\s,|]+/), i;
  for (i = 0; i < toks.length; i++){
    if (!toks[i]) continue;
    var c = parseChordSymbol(toks[i]);
    if (c){
      c.inv = 0; c.ext = 5; c.sus = 0; c.len = 4; c.on = true;
      slots.push(c);
    } else bad.push(toks[i]);
  }
  return { slots:slots, bad:bad };
}

function detectKey(chords){
  var best = { root:0, scale:"major", score:-1e9 };
  var keys = ["major","minor"], r, k, sc, i, j;
  for (r = 0; r < 12; r++){
    for (k = 0; k < keys.length; k++){
      sc = keys[k];
      var inScale = [], steps = SCALES[sc].steps;
      for (i = 0; i < 12; i++) inScale.push(false);
      for (i = 0; i < steps.length; i++) inScale[mod12(r + steps[i])] = true;

      var score = 0;
      for (i = 0; i < chords.length; i++){
        var c = chords[i], fora = 0;
        for (j = 0; j < c.ivs.length; j++) if (!inScale[mod12(c.rootPc + c.ivs[j])]) fora++;
        score += Math.max(-1, 2 - fora * 1.5);
        if (inScale[c.rootPc]) score += 1;
        if (i === 0 && c.rootPc === r) score += 1.3;
        if (i === chords.length - 1 && c.rootPc === r) score += 0.6;
        var dom = has(c.ivs, 4) && has(c.ivs, 10) && !has(c.ivs, 11);
        if (dom && mod12(c.rootPc + 5) === r) score += 1.6;
      }
      if (score > best.score) best = { root:r, scale:sc, score:score };
    }
  }
  return best;
}

function analyse(slot, st){
  var steps = SCALES[st.scale].steps, i;
  var inScale = [];
  for (i = 0; i < 12; i++) inScale.push(false);
  for (i = 0; i < steps.length; i++) inScale[mod12(st.root + steps[i])] = true;

  var iv = mod12(slot.rootPc - st.root), deg = -1, acc = "";
  for (i = 0; i < steps.length; i++) if (steps[i] % 12 === iv){ deg = i; break; }
  if (deg < 0){
    var above = -1;
    for (i = 0; i < steps.length; i++) if (steps[i] % 12 > iv){ above = i; break; }
    deg = above < 0 ? 6 : above;
    acc = "♭";
  }

  var ivs = slot.ivs;
  var minorish = has(ivs, 3), maj7 = has(ivs, 11);
  var r = acc + (minorish ? ROMAN[deg].toLowerCase() : ROMAN[deg]);
  if (has(ivs, 6) && minorish) r += has(ivs, 10) ? "ø" : "°";
  if (has(ivs, 8) && !has(ivs, 7)) r += "+";
  var m7 = maj7 ? "maj" : "";
  if (has(ivs, 21))      r += m7 + "13";
  else if (has(ivs, 17)) r += m7 + "11";
  else if (has(ivs, 14)) r += m7 + "9";
  else if (has(ivs, 10) || maj7) r += m7 + "7";

  var diat = !acc;
  if (diat) for (i = 0; i < ivs.length; i++) if (!inScale[mod12(slot.rootPc + ivs[i])]){ diat = false; break; }

  return { roman:r, fn:functionOf(deg + 1, st.scale), deg:deg + 1, diatonic:diat };
}

function relativeOf(root, scale){
  return scale === "minor" ? { root:mod12(root + 3), scale:"major" }
                           : { root:mod12(root + 9), scale:"minor" };
}

/* ═══ 3. VOZES ════════════════════════════════════════════════════════ */

function invert(pitches, n){
  var v = pitches.slice(), k = ((n % v.length) + v.length) % v.length, i;
  for (i = 0; i < k; i++) v.push(v.shift() + 12);
  return v.sort(function(a,b){ return a-b; });
}

function lead(pitches, prev){
  if (!prev) return pitches.slice();
  var best = null, bestCost = 1e9, inv, oct, i;
  for (inv = 0; inv < pitches.length; inv++){
    for (oct = -1; oct <= 1; oct++){
      var base = invert(pitches, inv), cand = [];
      for (i = 0; i < base.length; i++) cand.push(base[i] + oct * 12);
      if (cand[0] < 45 || cand[cand.length-1] > 84) continue;
      var cost = 0, n = Math.min(cand.length, prev.length);
      for (i = 0; i < n; i++) cost += Math.abs(cand[i] - prev[i]);
      cost = cost / n + Math.abs(cand[0] - 55) * 0.08;
      if (cost < bestCost){ bestCost = cost; best = cand; }
    }
  }
  return best || pitches.slice();
}

function spreadStage(s){ return s < 0.25 ? 0 : (s < 0.5 ? 1 : (s < 0.78 ? 2 : 3)); }

function applySpread(v, s){
  var st = spreadStage(s), out = v.slice(), i;
  if (st === 0) return out;
  if (st >= 1 && out.length >= 3) out[out.length - 2] -= 12;
  if (st >= 2 && out.length >= 4) out[out.length - 4] -= 12;
  if (st === 3){
    out.sort(function(a,b){ return a-b; });
    for (i = 2; i < out.length; i += 2) out[i] += 12;
  }
  return out.sort(function(a,b){ return a-b; });
}

function bassNote(pc, above){
  var p = mod12(pc);
  while (p < above - 12) p += 12;
  while (p > above - 7)  p -= 12;
  return Math.max(28, p);
}

function trimVoices(v, density){
  var target = Math.max(3, Math.min(v.length, 3 + Math.round(density * 3)));
  return v.length <= target ? v.slice() : v.slice(0, target);
}

/* ═══ 4. RITMO E ARTICULAÇÃO ══════════════════════════════════════════ */

var PATTERNS = [
  [1,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0],
  [1,0,0,0, 0,0,0,0, 1,0,0,0, 0,0,0,0],
  [1,0,0,0, 0,0,1,0, 0,0,0,0, 1,0,0,0],
  [1,0,1,0, 0,0,1,0, 1,0,1,0, 0,0,1,0],
  [1,0,1,0, 1,0,1,1, 1,0,1,0, 1,0,1,1]
];
function patternIndex(d){ return d < 0.18 ? 0 : (d < 0.40 ? 1 : (d < 0.62 ? 2 : (d < 0.84 ? 3 : 4))); }
function motionStage(m){ return m < 0.12 ? 0 : (m < 0.62 ? 1 : (m < 0.84 ? 2 : 3)); }

function strumBeats(m){
  if (m < 0.12) return 0;
  var t = Math.min(1, (m - 0.12) / 0.50);
  return Math.pow(t, 1.6);
}

/* Math.imul não existe no motor JS do objeto `js`; o polyfill mantém o
   mesmo fluxo de aleatórios que o protótipo, e portanto o mesmo MIDI. */
function imul(a, b){
  var ah = (a >>> 16) & 0xffff, al = a & 0xffff;
  var bh = (b >>> 16) & 0xffff, bl = b & 0xffff;
  return ((al * bl) + (((ah * bl + al * bh) << 16) >>> 0)) | 0;
}

function mulberry32(a){
  return function(){
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    var t = imul(a ^ (a >>> 15), 1 | a);
    t = (t + imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function arpOrder(v, dir, rnd){
  var a, i, j, tmp;
  if (dir === "down") return v.slice().reverse();
  if (dir === "updown") return v.concat(v.slice(1, -1).reverse());
  if (dir === "rand"){
    a = v.slice();
    for (i = a.length - 1; i > 0; i--){
      j = Math.floor(rnd() * (i + 1));
      tmp = a[i]; a[i] = a[j]; a[j] = tmp;
    }
    return a;
  }
  return v.slice();
}

/* ═══ 5. GERADOR ══════════════════════════════════════════════════════ */

function mkEvent(si, ch, pitch, start, dur, vel, st, rnd, isBass){
  var h = st.hum;
  var jT = (rnd() - 0.5) * 0.045 * h;
  var jV = (rnd() - 0.5) * 34 * h;
  return {
    slot: si, fn: ch.fn, pitch: pitch,
    t: Math.max(0, start + jT),
    dur: Math.max(0.05, dur),
    vel: Math.round(Math.max(24, Math.min(127, vel + jV))),
    bass: !!isBass
  };
}

function generate(st){
  var rnd = mulberry32(st.seed);
  var events = [], chords = [], t = 0, prev = null;
  var mStage = motionStage(st.motion);
  var strum = strumBeats(st.motion);
  var pat = PATTERNS[patternIndex(st.density)];
  var gateF = 0.15 + Math.pow(st.gate, 1.3) * 1.35;
  var si, i;

  for (si = 0; si < st.count; si++){
    var slot = st.slots[si];
    var ch = buildChord(slot, st);
    var v = invert(ch.pitches, slot.inv);
    if (st.voiceLead) v = lead(v, prev);
    prev = v.slice();

    var voices = trimVoices(applySpread(v, st.spread), st.density);
    if (st.bass) voices = [bassNote(ch.bassPc !== null && ch.bassPc !== undefined ? ch.bassPc : ch.rootPc, voices[0])].concat(voices);

    ch.voices = voices;
    chords.push(ch);

    if (!slot.on){ t += slot.len; continue; }

    var steps = Math.round(slot.len * 4), grid = [], s;
    if (mStage >= 2){
      var every = mStage === 2 ? 2 : 1;
      for (s = 0; s < steps; s += every) grid.push(s);
    } else {
      for (s = 0; s < steps; s++) if (pat[s % 16]) grid.push(s);
    }
    if (!grid.length) grid.push(0);

    var seq = arpOrder(voices, st.dir, rnd), arpI = 0, gi;

    for (gi = 0; gi < grid.length; gi++){
      s = grid[gi];
      var start = t + s / 4;
      var nextS = gi + 1 < grid.length ? grid[gi+1] : steps;
      var span = (nextS - s) / 4;
      var accent = (s % 16 === 0) ? 14 : (s % 4 === 0 ? 5 : -3);

      if (mStage >= 2){
        var p = seq[arpI % seq.length]; arpI++;
        events.push(mkEvent(si, ch, p, start, span * gateF, 92 + accent, st, rnd, false));
      } else {
        var ord = st.dir === "down" ? voices.slice().reverse() : voices.slice();
        for (i = 0; i < ord.length; i++){
          var curve = ord.length > 1 ? Math.pow(i / (ord.length - 1), 0.72) : 0;
          var off = strum * span * curve * (st.dir === "rand" ? rnd() * 1.6 : 1);
          var isBass = st.bass && ord[i] === voices[0] && st.dir !== "down";
          events.push(mkEvent(si, ch, ord[i], start + off,
                              Math.max(0.08, span * gateF - off),
                              96 + accent - i * 4, st, rnd, isBass));
        }
      }
    }
    t += slot.len;
  }

  var total = 0;
  for (si = 0; si < st.count; si++) total += st.slots[si].len;
  return { events:events, chords:chords, totalBeats:total };
}

/* ═══ 6. ESTADO ═══════════════════════════════════════════════════════ */

function defaults(){
  var slots = [], degs = [1,7,6,3,1,7,6,3], i;
  for (i = 0; i < 8; i++)
    slots.push({ mode:"deg", deg:degs[i], ext:5, sus:0, inv:0, len:4, on:true });
  return {
    root: 5, scale: "minor", bpm: 92, count: 4,
    slots: slots,
    motion: 0, spread: 0, density: 0.08,
    gate: 0.70, hum: 0.12, dir: "up",
    voiceLead: true, bass: true,
    preferRel: null, seed: 20260830
  };
}

/* Aplica uma linha de cifras ao estado: detecta o tom, respeita a relativa
   escolhida e troca os compassos. Devolve o que não conseguiu ler. */
function applyChords(st, text){
  var p = parseProgression(text), i;
  if (!p.slots.length) return { ok:false, bad:p.bad };
  var use = p.slots.slice(0, 8);
  var key = detectKey(use);
  if (st.preferRel && key.scale !== st.preferRel){
    var rel = relativeOf(key.root, key.scale);
    key.root = rel.root; key.scale = rel.scale;
  }
  st.root = key.root; st.scale = key.scale; st.count = use.length;
  for (i = 0; i < use.length; i++) st.slots[i] = use[i];
  return { ok:true, bad:p.bad, cut:p.slots.length > 8 };
}

function progressionText(st, model){
  var out = [], i;
  for (i = 0; i < st.count; i++)
    out.push(model.chords[i] ? symbol(model.chords[i], st) : "?");
  return out.join(" ");
}

function keyName(st){
  return noteName(st.root, st.root, st.scale) + " " + SCALES[st.scale].label.toLowerCase();
}

return {
  SCALES: SCALES, PATTERNS: PATTERNS,
  noteName: noteName, useFlats: useFlats,
  parseChordSymbol: parseChordSymbol, writeChordSymbol: writeChordSymbol,
  parseProgression: parseProgression, detectKey: detectKey, analyse: analyse,
  relativeOf: relativeOf, buildChord: buildChord, symbol: symbol,
  generate: generate, defaults: defaults, applyChords: applyChords,
  progressionText: progressionText, keyName: keyName,
  motionStage: motionStage, spreadStage: spreadStage, patternIndex: patternIndex
};

})();

if (typeof module !== "undefined" && module.exports) module.exports = IC;

/* ════════════════════════════════════════════════════════════════════════
   COLA DO MAX — daqui para baixo só roda dentro do objeto `js`.
   ════════════════════════════════════════════════════════════════════════ */

if (typeof outlet === "function") {

  autowatch = 1;
  inlets  = 1;
  outlets = 2;      // 0: nota (pitch vel) para midiformat · 1: mensagens de UI

  var S = IC.defaults();
  var M = IC.generate(S);
  var offTasks = [];

  function report(){
    M = IC.generate(S);
    outlet(1, "tom", IC.keyName(S));
    outlet(1, "cifras", IC.progressionText(S, M));
    outlet(1, "info", M.events.length + " notas · " + (M.totalBeats / 4) + " compassos");
  }

  function status(txt){ outlet(1, "info", txt); }

  /* Os botões live.text mandam 1 ao apertar e 0 ao soltar; um `button`
     mandaria bang. Isto aceita os dois e ignora o soltar. */
  function pressed(v){ return v === undefined || v === 1 || v === "bang"; }

  /* ── entrada ────────────────────────────────────────────────────── */

  function cifras(){
    var a = arrayfromargs(arguments), i, parts = [];
    for (i = 0; i < a.length; i++) parts.push(String(a[i]));
    var r = IC.applyChords(S, parts.join(" "));
    if (!r.ok){ status("não reconheci nenhuma cifra"); return; }
    report();
    if (r.bad.length) status("ignorei " + r.bad.join(", "));
    else if (r.cut)   status("cortei em 8 compassos");
  }
  cifras.local = 0;

  function toque(v){    S.motion  = clamp01(v); report(); }
  function abertura(v){ S.spread  = clamp01(v); report(); }
  function ritmo(v){    S.density = clamp01(v); report(); }
  function gate(v){     S.gate    = clamp01(v); report(); }
  function humanizar(v){S.hum     = clamp01(v); report(); }
  function suavizar(v){ S.voiceLead = !!v;      report(); }
  function baixo(v){    S.bass    = !!v;        report(); }

  function compassos(n){
    n = Math.max(1, Math.min(8, Math.round(n)));
    S.count = n;
    report();
  }

  function direcao(d){ if (d === undefined) return; S.dir = String(d); report(); }

  function variar(v){
    if (!pressed(v)) return;
    S.seed = (S.seed * 1103515245 + 12345) & 0x7fffffff;
    report();
    status("nova variação · seed " + S.seed);
  }

  function relativa(v){
    if (!pressed(v)) return;
    var rel = IC.relativeOf(S.root, S.scale), i, shift;
    S.preferRel = rel.scale;
    shift = S.scale === "minor" ? 5 : 2;
    for (i = 0; i < S.slots.length; i++)
      if (S.slots[i].mode === "deg") S.slots[i].deg = ((S.slots[i].deg - 1 + shift) % 7) + 1;
    S.root = rel.root; S.scale = rel.scale;
    report();
  }

  function clamp01(v){ v = parseFloat(v); return isNaN(v) ? 0 : Math.max(0, Math.min(1, v)); }

  /* ── audição: toca a progressão fora do transporte ───────────────── */

  function parar(v){
    if (arguments.length && !pressed(v)) return;
    var i;
    for (i = 0; i < offTasks.length; i++){
      try { offTasks[i].cancel(); } catch(e) {}
    }
    offTasks = [];
    for (i = 0; i < 128; i++) outlet(0, i, 0);
  }

  function tocar(v){
    if (!pressed(v)) return;
    parar();
    var bpm = liveTempo();
    var spb = 60000 / bpm;                       // ms por tempo
    var i;
    for (i = 0; i < M.events.length; i++) schedule(M.events[i], spb);
    status("tocando · " + Math.round(bpm) + " BPM");
  }

  function schedule(e, spb){
    var on = new Task(function(p, v){ outlet(0, p, v); }, this, e.pitch, e.vel);
    var off = new Task(function(p){ outlet(0, p, 0); }, this, e.pitch);
    on.schedule(e.t * spb);
    off.schedule((e.t + e.dur) * spb);
    offTasks.push(on, off);
  }

  function liveTempo(){
    try {
      var song = new LiveAPI(function(){}, "live_set");
      var t = song.get("tempo");
      if (t && t.length) return parseFloat(t[0]);
    } catch (e) {}
    return S.bpm;
  }

  /* ── escrita no clip ─────────────────────────────────────────────── */

  function escrever(v){
    if (!pressed(v)) return;
    var slot, clip, has, i, e;

    try { slot = new LiveAPI(function(){}, "live_set view highlighted_clip_slot"); }
    catch (err){ status("Live API indisponível"); return; }

    if (!slot || !slot.id || parseInt(slot.id, 10) === 0){
      status("selecione um slot de clip na Session"); return;
    }

    has = slot.get("has_clip");
    if (!has || parseInt(has[0], 10) === 0){
      slot.call("create_clip", M.totalBeats);
    }

    clip = new LiveAPI(function(){}, "live_set view highlighted_clip_slot clip");
    if (!clip || !clip.id || parseInt(clip.id, 10) === 0){
      status("não consegui abrir a clip"); return;
    }
    if (parseInt(clip.get("is_midi_clip")[0], 10) !== 1){
      status("a clip selecionada não é MIDI"); return;
    }

    // Abre espaço antes de escrever, senão as notas caem fora do loop.
    clip.set("loop_start", 0);
    clip.set("end_marker", M.totalBeats);
    clip.set("loop_end", M.totalBeats);

    clip.call("select_all_notes");
    clip.call("replace_selected_notes");
    clip.call("notes", M.events.length);
    for (i = 0; i < M.events.length; i++){
      e = M.events[i];
      clip.call("note", e.pitch, r3(e.t), r3(e.dur), e.vel, 0);
    }
    clip.call("done");

    status(M.events.length + " notas escritas · " + (M.totalBeats / 4) + " compassos");
  }

  function r3(x){ return Math.round(x * 1000) / 1000; }

  /* ── varredura ──────────────────────────────────────────────────── */

  function bang(){ report(); }

  function loadbang(){ report(); }

  function anything(){
    post("InstantChord: não entendi '" + messagename + "'\n");
  }
}
