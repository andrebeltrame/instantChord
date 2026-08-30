/* Comparador de paridade — cole no console do protótipo servido em
   http://localhost:8788/prototype/index.html (com `node max/test/parity.js`
   já rodado). Roda o motor do protótipo sobre os mesmos casos e confere
   nota por nota contra a saída do motor ES5 do device.

   Devolve { casos, notas, divergencias }. `divergencias` vazio = paridade. */
(async () => {
  const D = window.__instantchord;
  const q = s => document.querySelector(s);
  const base = "http://localhost:8788/max/test/";
  const cases = await (await fetch(base + "cases.json")).json();
  const es5   = await (await fetch(base + "engine-output.json")).json();

  const BASE = { motion:0, spread:0, density:.08, gate:.70, hum:.12,
                 dir:"up", voiceLead:true, bass:true, seed:20260830, preferRel:null };

  const r6 = x => Math.round(x * 1e6) / 1e6;
  const diffs = [];
  let notas = 0;

  cases.forEach((c, ci) => {
    Object.assign(D.state, BASE);
    if (c.chords){
      q("#chart").value = c.chords;
      q("#chart-apply").click();
    } else {
      D.state.root = c.key.root; D.state.scale = c.key.scale; D.state.count = c.key.count;
      c.slots.forEach((s, i) => { D.state.slots[i] = JSON.parse(JSON.stringify(s)); });
    }
    Object.assign(D.state, c.macros || {});

    const m = D.generate(D.state);
    const mine = m.events.map(e => [e.slot, r6(e.t), e.pitch, r6(e.dur), e.vel, e.bass ? 1 : 0]);
    const theirs = es5[ci].events;
    notas += mine.length;

    const add = (campo, a, b) => diffs.push({ caso: c.name, campo, prototipo: a, device: b });

    if (es5[ci].name !== c.name)                    add("ordem dos casos", c.name, es5[ci].name);
    if (m.totalBeats !== es5[ci].total)             add("total de tempos", m.totalBeats, es5[ci].total);
    if (mine.length !== theirs.length)              add("número de notas", mine.length, theirs.length);
    const rom = m.chords.map(x => x.roman).join(" ");
    if (rom !== es5[ci].romans.join(" "))           add("algarismos romanos", rom, es5[ci].romans.join(" "));

    const n = Math.min(mine.length, theirs.length);
    for (let i = 0; i < n; i++){
      const a = mine[i], b = theirs[i];
      for (let j = 0; j < 6; j++){
        if (a[j] !== b[j]){
          add("nota " + i + " campo " + ["slot","t","pitch","dur","vel","bass"][j], a[j], b[j]);
          i = n; break;                       // uma divergência por caso já basta
        }
      }
    }
  });

  return { casos: cases.length, notas, divergencias: diffs };
})()
