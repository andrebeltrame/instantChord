/* Roda o motor ES5 do device (max/instantchord.js) sobre os casos de
   max/test/cases.json e grava o resultado em max/test/engine-output.json.
   O protótipo faz o mesmo no navegador e compara nota por nota — o
   comparador está em max/test/compare-in-browser.js.

       node max/test/parity.js
*/
var fs = require("fs");
var path = require("path");
var IC = require("../instantchord.js");

var ROOT = path.join(__dirname, "..", "..");
var cases = JSON.parse(fs.readFileSync(path.join(__dirname, "cases.json"), "utf8"));

var BASE = {
  motion: 0, spread: 0, density: 0.08,
  gate: 0.70, hum: 0.12, dir: "up",
  voiceLead: true, bass: true, seed: 20260830, preferRel: null
};

function runCase(c){
  var st = IC.defaults(), k;
  for (k in BASE) st[k] = BASE[k];

  if (c.chords){
    var r = IC.applyChords(st, c.chords);
    if (!r.ok) throw new Error("caso '" + c.name + "': nenhuma cifra reconhecida");
    if (r.bad.length) throw new Error("caso '" + c.name + "': não li " + r.bad.join(", "));
  } else {
    st.root = c.key.root; st.scale = c.key.scale; st.count = c.key.count;
    for (var i = 0; i < c.slots.length; i++) st.slots[i] = JSON.parse(JSON.stringify(c.slots[i]));
  }
  for (k in (c.macros || {})) st[k] = c.macros[k];

  var m = IC.generate(st);
  return {
    name: c.name,
    key: IC.keyName(st),
    cifras: IC.progressionText(st, m),
    romans: m.chords.map(function(ch){ return ch.roman; }),
    total: m.totalBeats,
    events: m.events.map(function(e){
      return [e.slot, round6(e.t), e.pitch, round6(e.dur), e.vel, e.bass ? 1 : 0];
    })
  };
}

function round6(x){ return Math.round(x * 1e6) / 1e6; }

var out = cases.map(runCase);
var dest = path.join(__dirname, "engine-output.json");
fs.writeFileSync(dest, JSON.stringify(out, null, 1));

var notes = out.reduce(function(a, r){ return a + r.events.length; }, 0);
console.log("motor ES5: " + out.length + " casos, " + notes + " notas");
out.forEach(function(r){
  console.log("  " + pad(r.name, 30) + pad(r.key, 12) + pad(r.events.length + " notas", 11) + r.cifras);
});
console.log("\ngravado em " + path.relative(ROOT, dest));
console.log("agora compare no navegador — veja max/README.md");

function pad(s, n){ s = String(s); while (s.length < n) s += " "; return s; }
