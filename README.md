# InstantChord

Gerador de progressões harmônicas para **Ableton Live**, entregue como device
**Max for Live**. Você clica num pad, ouve o acorde, molda a articulação com
três macros e escreve o MIDI direto na clip selecionada.

O ponto de partida foi o M2TM Chord Generator: ele resolve a geração, mas
entrega sempre acorde bloco e vive no painel *Generate* do clip editor, que
tem uns 120 px de largura. O InstantChord tira a engine dali e coloca numa
interface com espaço para trabalhar.

Duas maneiras de montar a progressão, e elas conversam:

- **Por grau** — clica nos pads I–VII dentro da tonalidade. Para compor.
- **Por cifra** — digita `Fm Eb Db Ab` ou `Dm7 G7 | Cmaj7`. Para pegar uma
  progressão de outra música. O device descobre o tom, e trocar a tônica
  transpõe tudo.

## Protótipo

`prototype/` traz um protótipo navegável e sonoro — a engine completa em
JavaScript, os pads, os macros e a piano roll com o MIDI que seria escrito.
É o mesmo código que vai rodar dentro do objeto `v8` no Max.

```bash
python3 -m http.server 8788
```

Depois abra <http://localhost:8788/prototype/index.html>.

- `prototype/instantchord.html` — fonte (corpo do documento, sem `<html>`)
- `prototype/index.html` — gerado, documento completo para abrir no browser
- `prototype/build-standalone.sh` — regenera o `index.html`

## Documentação

| Arquivo | Conteúdo |
| --- | --- |
| [`docs/decisao-plataforma.md`](docs/decisao-plataforma.md) | Por que Max for Live e não VST3 — e por que device na track, não MIDI Tool |
| [`docs/engine-spec.md`](docs/engine-spec.md) | Especificação da engine: escalas, vozes, macros, formato de saída |
| [`docs/roadmap.md`](docs/roadmap.md) | Escopo do v1 e o que fica para depois |

## Estado

Protótipo de interface, v0.1. Nada de Max ainda.
