# Decisão de plataforma

## O problema com o formato atual

O M2TM Chord Generator é um **MIDI Tool (Generator)** do Live 12: mora no
painel *Generate* dentro do clip editor e escreve notas direto na clip. O
fluxo é ótimo — clique e o MIDI aparece. O formato é que é apertado: aquele
painel tem cerca de 120 px de largura. Não cabe uma grade de pads, não cabem
knobs, não cabe piano roll. A interface do M2TM é feia por limitação de
moldura, não por descuido do autor.

## As opções

| Formato | Clique escreve na clip? | Espaço de UI | Roda fora do Live? | Custo |
| --- | --- | --- | --- | --- |
| MIDI Tool (painel *Generate*) | Sim, nativo | ~120 px — inviável | Não | Baixo |
| **Device M4L na track + Live API** | Sim, via `add_new_notes` | ~700 × 170 px, ou janela flutuante | Não | Médio |
| VST3/AU (JUCE) | Não no Live — só drag-and-drop de `.mid` | Ilimitado | Sim | Alto |

## A escolha

**Device Max for Live normal, na cadeia de MIDI da track.**

Dois modos de operação no mesmo device:

1. **Ao vivo** — o device toca a progressão enquanto você mexe nos macros.
   Feedback imediato, nada é gravado, nada é destruído.
2. **Write** — um botão chama a Live API na clip selecionada e escreve a
   progressão inteira. É o "clique gera MIDI" que você já usa, só que com
   uma interface do tamanho certo.

Depois, opcionalmente, uma **casca MIDI Tool** minúscula para o painel
*Generate*: mesma engine, UI reduzida, para quem prefere aquele fluxo.

VST3 fica fora do v1. Custa cerca de cinco vezes mais para construir e, no
Ableton, perde exatamente a característica central — escrever na clip. Só
faz sentido se o objetivo virar vender o plugin fora do ecossistema Live.

## Stack dentro do Max

| Camada | Escolha | Por quê |
| --- | --- | --- |
| Engine | JavaScript no objeto `v8` (Max 9) | É o código do protótipo, sem reescrita. `v8` é bem mais rápido que o `js` antigo |
| Interface | `jsui` + mgraphics | Desenho vetorial com a mesma lógica de canvas do protótipo; pads, knobs e roll saem quase iguais |
| Controles nativos | `live.*` onde couber | Herdam undo, automação e Push de graça |
| Escrita na clip | Live API via `live.object` / `live.path` | `add_new_notes` na clip selecionada |

Descartado: `jweb` (HTML dentro do Max). Daria liberdade visual total, mas é
frágil em redraw, foco de teclado e performance. Não vale para uma UI que
precisa responder a arraste em tempo real.
