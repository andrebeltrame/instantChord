# Engine — especificação

Contrato entre o protótipo (`prototype/instantchord.html`) e a implementação
em Max. Tudo aqui já está implementado em JavaScript no protótipo; a porta
para o objeto `v8` deve ser cópia, não reescrita.

## 1. Escalas

Semitons acima da tônica:

| Escala | Passos |
| --- | --- |
| Maior | 0 2 4 5 7 9 11 |
| Menor natural | 0 2 3 5 7 8 10 |
| Dórico | 0 2 3 5 7 9 10 |
| Mixolídio | 0 2 4 5 7 9 10 |
| Menor harmônico | 0 2 3 5 7 8 11 |
| Frígio | 0 1 3 5 7 8 10 |

A entrada é sempre por **grau** (1–7), nunca por nome de acorde. Você pensa
em função, o device soletra.

## 2. Construção do acorde

Índices relativos ao grau, empilhando terças na escala:

- tríade → `[0, 2, 4]`
- 7 → `+[6]` · 9 → `+[8]` · 11 → `+[10]` · 13 → `+[12]`
- `sus2` substitui o índice 2 por 1; `sus4` por 3

A qualidade (m, dim, aug, maj7, 7…) é **derivada** dos intervalos
resultantes, não declarada. Em menor harmônico o III sai `III+` sozinho,
porque é isso que a escala produz.

## 3. Função harmônica

Determina a cor do pad e da nota. Depende do modo:

```
V                        → dominante
VII                      → dominante se houver sensível (7º passo = 11),
                           caso contrário predominante (backdoor)
II, IV                   → predominante
VI                       → predominante em modo menor, tônica em maior
I, III                   → tônica
```

Sem a regra do sensível, o `VII` de `Fm Eb Db Ab` sairia pintado como
dominante, o que está musicalmente errado.

## 4. Vozes

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

## 5. Os três macros

### Motion — articulação

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

### Spread — abertura

`Fechado` · `Drop 2` · `Drop 2+4` · `Aberto`. Ver pipeline de vozes acima.

### Density — número de vozes e ataques

Máscaras de 16 semicolcheias por compasso:

| Faixa | Nome | Máscara |
| --- | --- | --- |
| < 0.18 | Semibreve | `1··· ···· ···· ····` |
| < 0.40 | Mínimas | `1··· ···· 1··· ····` |
| < 0.62 | Sincopado | `1··· ··1· ···· 1···` |
| < 0.84 | Colcheias | `1·1· ··1· 1·1· ··1·` |
| ≥ 0.84 | Denso | `1·1· 1·11 1·1· 1·11` |

Em modo arpejo a máscara é ignorada — a grade vira 1/8 ou 1/16 corridas.

## 6. Controles secundários

- **Gate** — duração da nota, `0.15 + gate^1.3 × 1.35` da janela do evento.
  Acima de 1.0 as notas se sobrepõem (legato).
- **Humanize** — ±0.045 tempo de timing e ±34 de velocity, escalados pelo
  valor. Determinístico: derivado do **seed**.
- **Direção** — `↑` `↓` `↕` `rnd`, vale para dedilhado e arpejo.
- **Seed** — `↺ Variar` avança o seed por LCG. Mesmo seed, mesmo resultado —
  dá para voltar a uma variação que você gostou.

## 7. Velocity

```
base 96
+14 na cabeça do compasso, +5 nos demais tempos, −3 fora do tempo
−4 por voz, de baixo para cima
± humanize
clamp 24 … 127
```

## 8. Saída

Um array de eventos, direto para `add_new_notes`:

```js
{ slot, fn, pitch, t, dur, vel, bass }
```

- `t` e `dur` em **tempos**, com origem no início do primeiro slot
- `pitch` em nota MIDI
- `fn` é só para a cor da interface, não vai para a clip
- `bass` marca a nota fundamental grave (timbre diferente na audição)

O botão **Lista de notas** no protótipo mostra exatamente esse array.

## 9. Aleatoriedade

`mulberry32` semeado pelo `seed` do estado. Nada de `Math.random()` — a
mesma progressão com o mesmo seed tem que dar o mesmo MIDI, sempre.
