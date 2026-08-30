# Engine — especificação

Contrato entre o protótipo (`prototype/instantchord.html`) e a implementação
em Max. Tudo aqui já está implementado em JavaScript no protótipo; a porta
para o objeto `v8` deve ser cópia, não reescrita.

## 1. Escalas

Semitons acima da tônica:

| Escala | Passos |
| --- | --- |
| Maior | 0 2 4 5 7 9 11 |
| Menor | 0 2 3 5 7 8 10 |

Só duas, de propósito. Modos gregos são uma porta que o usuário-alvo não
abre, e cada escala a mais é uma linha a mais na detecção de tonalidade
disputando com as duas que importam. O que soa modal continua acessível
por acorde: basta digitar a cifra, que entra como acorde fora do tom.

A entrada por grau vai de 1 a 7 e é relativa à escala. Para entrada por
nome de acorde, ver a seção 2.

## 2. Cifras

A entrada por grau é o caminho para compor; a entrada por **cifra** é o
caminho para *pegar* — trazer uma progressão que você ouviu em outra música.
Os dois convivem: cada slot tem um `mode`.

| `mode` | Como o acorde é definido | Como é editado |
| --- | --- | --- |
| `deg` | Grau na escala + extensão + sus | Botões do inspetor |
| `abs` | Fundamental + intervalos absolutos | Ao mexer em grau/extensão/sus, converte para `deg` |

### Sintaxe

```
Fm Eb Db Ab                 quatro compassos, um acorde cada
Dm7 G7 Cmaj7 A7             idem
Am/C                        baixo invertido
```

Um acorde por compasso, separados por espaço. Sem separador de compasso e
sem sintaxe para decorar: a duração de cada acorde se ajusta depois, no
inspetor (meio, um ou dois compassos). Vírgula e `|` são tolerados como
espaço, mas não significam nada — quem digita não precisa saber disso.

### Cifras aceitas

Tríades `C Cm Cdim Caug Csus2 Csus4 C5` · sétimas `C7 Cmaj7 CM7 CΔ Cm7 Cdim7
Cm7b5 Cø` · extensões `C9 C11 C13 Cmaj9 C6 C6/9 Cadd9` · alterações
`C7b9 C7#9 C7#11 C7b13 Cm7b5 C7#5` · baixo invertido `/G`.

Regras que não são óbvias: o `M` maiúsculo sozinho é sétima maior (`CM7` =
`Cmaj7`), o `m` minúsculo é menor; o 11 sai do 13 maior mas fica no 13
menor; `dim7` leva sétima diminuta (9 semitons) e `m7b5` leva menor (10).

### Detecção de tonalidade

Testa as 12 tônicas × 2 escalas e pontua:

| Sinal | Peso |
| --- | --- |
| Acorde inteiro dentro da escala | 2, menos **1.5 por nota de fora** (piso −1) |
| Fundamental do acorde na escala | 1 |
| Primeiro acorde na tônica candidata | 1.3 |
| Último acorde na tônica candidata | 0.6 |
| **Acorde dominante uma quinta acima da candidata** | **1.6** |

A penalidade por nota fora tem que ser **maior** que o bônus de primeiro
acorde, senão a ordem dos acordes ganha da harmonia: com a penalidade
proporcional que havia antes, `Db Eb Fm Ab` saía como ré♭ maior — uma
tonalidade que nem contém o acorde Eb.

O peso da cadência V7→I é o que faz `Dm7 G7 Cmaj7` ser lido como dó maior.
Progressões genuinamente ambíguas continuam ambíguas — os seletores de
tônica e escala mandam mais que a detecção.

### Relativas

Fá menor e lá♭ maior têm exatamente as mesmas sete notas. `Fm Eb Db Ab`
pode ser lido como `i VII VI III` em fá menor ou `vi V IV I` em lá♭ maior,
e nenhuma das duas leituras é errada — outros programas de reconhecimento
de acorde costumam reportar a relativa maior. O desempate aqui é o bônus de
primeiro acorde, que dá fá menor.

Como a escolha muda só rótulo e cor, o botão **⇄** ao lado do tom troca
entre as relativas sem transpor nem alterar acorde nenhum: os slots por
grau são remapeados (`i → vi` indo para maior, `I → iii` voltando), e os
slots por cifra nem precisam ser tocados, já que suas alturas são
absolutas.

**A escolha fica valendo.** Clicar no ⇄ grava `preferRel`, e toda detecção
seguinte é levada para aquele lado quando cai numa relativa. Quem usa um
programa de reconhecimento que reporta a relativa maior clica uma vez e o
InstantChord passa a concordar com ele em todas as progressões. Não é uma
preferência que precise de tela de configuração: o gesto de discordar da
detecção *é* o gesto de configurá-la.

Isso é diferente do seletor de tônica, que **transpõe**. Se o usuário
quisesse ler a mesma progressão em lá♭ e trocasse a tônica para Ab, ele
moveria a música três semitons — não é o que ele quer. Daí o botão
separado.

### Escrita — o caminho de volta

`writeChordSymbol` reconstrói a cifra a partir das alturas. É o que permite
duas coisas:

1. O campo de texto **acompanha** os pads: mexeu numa inversão ou extensão,
   a cifra se reescreve.
2. **Trocar a tônica transpõe** as cifras digitadas. Pegou a progressão em
   fá menor, joga para sol menor num clique.

A escolha entre sustenido e bemol vem da armadura do *relativo maior* do
modo, não da tônica sozinha: sol menor escreve `Gm F Eb Bb`, sol maior
escreve com sustenidos.

**Limitação conhecida:** as duas tonalidades de seis bemóis (mi♭ menor e
sol♭ maior) grafam um acorde enarmonicamente — `B` no lugar de `Cb`. Grafar
`Cb` exigiria rastrear nomes de letra, não classes de altura. Não vale o
custo para dois casos.

## 3. Construção do acorde

Índices relativos ao grau, empilhando terças na escala:

- tríade → `[0, 2, 4]`
- 7 → `+[6]` · 9 → `+[8]` · 11 → `+[10]` · 13 → `+[12]`
- `sus2` substitui o índice 2 por 1; `sus4` por 3

A qualidade (m, dim, aug, maj7, 7…) é **derivada** dos intervalos
resultantes, não declarada. Em menor harmônico o III sai `III+` sozinho,
porque é isso que a escala produz.

## 4. Função harmônica

Determina a cor do pad e da nota. Depende do modo:

```
V                        → tensão
VII                      → tensão se houver sensível (7º passo = 11, ou
                           seja, em maior), predominante em menor (backdoor)
II, IV                   → movimento
VI                       → movimento em menor, repouso em maior
I, III                   → repouso
```

Sem a regra do sensível, o `VII` de `Fm Eb Db Ab` sairia pintado como
dominante, o que está musicalmente errado. A regra é escrita em função do
7º passo da escala, e não com um `if (scale === "minor")`, para continuar
correta se um modo voltar para a lista.

## 5. Vozes

Pipeline, nesta ordem:

1. **Posição fundamental** centrada em torno de C4 (fundamental entre 54 e 66).
2. **Inversão** manual do slot (arraste vertical no pad).
3. **Condução de vozes** — testa todas as inversões × oitavas −1/0/+1 e
   escolhe a de menor deslocamento médio em relação ao acorde anterior, com
   penalidade para o baixo sair do registro (`|baixo − 55| × 0.08`).
   Descarta candidatos fora de MIDI 45–84.
4. **Spread** — `Fechado` → `Drop 2` → `Drop 2+4` → `Aberto` (vozes
   alternadas sobem uma oitava, abrindo ~3 oitavas).
5. **Density corta vozes** — mantém de 3 a 6, de baixo para cima.
6. **Baixo** — fundamental uma oitava abaixo da voz mais grave, piso em MIDI 28.

A condução de vozes é o item que mais muda o resultado. Sem ela a progressão
soa digitada; com ela soa tocada.

## 6. Os três macros

### Toque (`motion`) — articulação

| Faixa | Comportamento |
| --- | --- |
| < 0.12 | Bloco: todas as vozes juntas |
| 0.12 – 0.62 | Dedilhado: defasagem total de 0 a 1 **tempo**, curva `t^1.6` |
| 0.62 – 0.84 | Arpejo em 1/8 |
| > 0.84 | Arpejo em 1/16 |

A defasagem é medida em **tempos, não em milissegundos** — o gesto continua
soando igual quando o BPM muda. Dentro do acorde, a defasagem de cada voz
segue `(i / (n−1))^0.72`: acelera do grave para o agudo, como a mão de
verdade num violão. As vozes soltam juntas (a duração encolhe conforme o
atraso aumenta).

### Abertura (`spread`)

Quatro estágios — na interface aparecem como `Fechado`, `Aberto`,
`Bem aberto` e `Espalhado`; por dentro são posição fechada, drop 2,
drop 2+4 e abertura por oitavas alternadas. Ver pipeline de vozes acima.

### Ritmo (`density`) — número de vozes e ataques

Máscaras de 16 semicolcheias por compasso:

| Faixa | Nome na interface | Máscara |
| --- | --- | --- |
| < 0.18 | Um por compasso | `1··· ···· ···· ····` |
| < 0.40 | Dois por compasso | `1··· ···· 1··· ····` |
| < 0.62 | Sincopado | `1··· ··1· ···· 1···` |
| < 0.84 | Ritmado | `1·1· ··1· 1·1· ··1·` |
| ≥ 0.84 | Cheio | `1·1· 1·11 1·1· 1·11` |

Em modo arpejo a máscara é ignorada — a grade vira 1/8 ou 1/16 corridas.

## 7. Controles secundários

- **Gate** — duração da nota, `0.15 + gate^1.3 × 1.35` da janela do evento.
  Acima de 1.0 as notas se sobrepõem (legato).
- **Humanize** — ±0.045 tempo de timing e ±34 de velocity, escalados pelo
  valor. Determinístico: derivado do **seed**.
- **Direção** — `↑` `↓` `↕` `rnd`, vale para dedilhado e arpejo.
- **Seed** — `↺ Variar` avança o seed por LCG. Mesmo seed, mesmo resultado —
  dá para voltar a uma variação que você gostou.

## 8. Velocity

```
base 96
+14 na cabeça do compasso, +5 nos demais tempos, −3 fora do tempo
−4 por voz, de baixo para cima
± humanize
clamp 24 … 127
```

## 9. Saída

Um array de eventos, direto para `add_new_notes`:

```js
{ slot, fn, pitch, t, dur, vel, bass }
```

- `t` e `dur` em **tempos**, com origem no início do primeiro slot
- `pitch` em nota MIDI
- `fn` é só para a cor da interface, não vai para a clip
- `bass` marca a nota fundamental grave (timbre diferente na audição)

O botão **Lista de notas** no protótipo mostra exatamente esse array.

## 10. Aleatoriedade

`mulberry32` semeado pelo `seed` do estado. Nada de `Math.random()` — a
mesma progressão com o mesmo seed tem que dar o mesmo MIDI, sempre.

## 11. Linguagem e estado inicial

O device é para quem produz, não para quem estudou harmonia. Duas decisões
que valem para toda a interface:

**O nome do acorde vem primeiro.** No pad, `Fm` em corpo grande e `i` em
corpo miúdo ao lado. Nos botões de acorde do tom, o nome em cima e o
algarismo romano embaixo, discreto. Quem sabe ler cifra funciona sem
aprender nada; quem não sabe vai aprendendo de graça.

**Sem jargão na superfície.** A tabela abaixo é o vocabulário: à esquerda o
que aparece na tela, à direita o que é por dentro.

| Na tela | Por dentro |
| --- | --- |
| Toque · Abertura · Ritmo | motion · spread · density |
| Fechado / Aberto / Bem aberto / Espalhado | close / drop 2 / drop 2+4 / open |
| Um por compasso / Dois / Sincopado / Ritmado / Cheio | máscaras rítmicas |
| Repouso · Movimento · Tensão | tônica · predominante · dominante |
| fora do tom | acorde emprestado, não diatônico |
| suavizar | condução de vozes |
| simples · 7 · 9 · 11 · 13 | tríade e extensões |
| Compasso | slot |

**Começa reto.** O estado inicial é `motion 0`, `spread 0`, `density 0.08`:
um acorde bloco por compasso, posição fechada. É a saída que o usuário já
conhece de outros geradores. As possibilidades ficam a um giro de botão —
mas nenhuma delas está ligada quando o device abre.

**Tema único.** Os cinzas do Live e as cores da paleta de clip, sem
alternador claro/escuro. O device mora dentro do Ableton; não faz sentido
ter um tema que discorde do host.

## 12. Padrões de abertura

O device abre sempre no mesmo lugar, e esse lugar é o mais simples possível:

| | |
| --- | --- |
| Compassos | **4** |
| Escala | Menor |
| Toque · Abertura · Ritmo | 0 · 0 · 0.08 — bloco, fechado, um acorde por compasso |
| Gate | 0.70 |
| Humanize | 0.12 |
| Suavizar (condução) | ligado |
| Baixo | ligado |

Quatro compassos é o padrão em toda entrada: no estado inicial, em cada
progressão pronta e em qualquer coisa que o usuário não tenha mudado. O
seletor 2/4/6/8 e a linha de cifras são as únicas coisas que alteram isso.
