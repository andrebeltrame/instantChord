# InstantChord — Max for Live

Device de teste. Funciona; ainda não é bonito. A interface visual é a do
protótipo (`prototype/`); aqui o objetivo é validar o motor dentro do Live e
principalmente a escrita no clip.

```
max/
  InstantChord.amxd      o device — arraste para uma track MIDI
  InstantChord.maxpat    o mesmo patcher, para abrir e editar no Max
  instantchord.js        o motor + a cola do Max (precisa ficar AO LADO do .amxd)
  build/                 o gerador do .amxd
  test/                  paridade com o protótipo
```

## Como testar

1. No Live, **Session View**, crie uma track MIDI com um instrumento nela
   (um piano do Core Library serve).
2. Arraste **`max/InstantChord.amxd`** para a track. O `.js` tem que estar
   na mesma pasta — o Max procura ao lado do device.
3. **Clique num slot de clip vazio** da mesma track para selecioná-lo.
4. No device: digite as cifras e dê Enter, depois **Escrever no clip**.
5. Toque o clip.

O campo já vem com `Fm Eb Db Ab`. Os botões:

| Botão | O que faz |
| --- | --- |
| **Escrever no clip** | Escreve a progressão no slot selecionado, criando a clip se estiver vazio |
| **Ouvir** | Toca a progressão pelo instrumento da track, sem transporte |
| **Parar** | Corta a audição |
| **Variar** | Novo seed do humanize |
| **relativa** | Troca fá menor ⇄ lá♭ maior sem transpor |

Os cinco dials são Toque, Abertura, Ritmo, Gate e Humanize — a mesma coisa do
protótipo, com o mesmo alcance 0–1.

## O que foi verificado e o que não foi

Verificado aqui:

- **Formato do container.** `build/amxd.py` lê e reescreve o
  `Max MIDI Effect.amxd` de fábrica byte a byte idêntico. O `.amxd` gerado
  usa exatamente o mesmo cabeçalho.
- **Patcher.** Relido depois de gravado; todas as 47 conexões apontam para
  objetos que existem.
- **Motor.** `node max/test/parity.js` roda o motor ES5 sobre 8 casos e o
  protótipo roda os mesmos no navegador: **789 notas, zero divergências** —
  altura, início, duração, velocity e o humanize inteiro.

Não verificado — não tenho como abrir o Live daqui:

- Se o `live.text` em modo botão manda `1` ou `bang` (o JS aceita os dois).
- Se o `textedit` entrega o texto do jeito esperado ao dar Enter.
- Os caminhos da Live API na escrita do clip.
- A aparência do painel.

Se algo não funcionar, o mais provável é um destes quatro. O `@autowatch 1`
no objeto `js` recarrega o motor quando você salva o arquivo, então dá para
consertar sem fechar o Live.

## Regerar o device

```bash
python3 max/build/build_device.py
```

O `.amxd` é gerado, nunca editado à mão. Se você mexer no patch dentro do Max
e salvar por lá, o arquivo passa a divergir do gerador — nesse caso vale
trazer a mudança de volta para `build/build_device.py`.

## Rodar a paridade

```bash
node max/test/parity.js
```

Grava `max/test/engine-output.json`. Depois, com o protótipo servido em
`http://localhost:8788`, cole `max/test/compare-in-browser.js` no console da
página: ele compara nota por nota e devolve `divergencias: []` se estiver
tudo igual.

## Notas de implementação

- **ES5 puro** em `instantchord.js`: o mesmo arquivo roda no objeto `js`, no
  `v8` do Max 9 e no Node. Trocar `js` por `v8` na caixa do objeto funciona.
- **`Math.imul` não existe no motor do objeto `js`.** Tem um polyfill, e é
  ele que garante que o gerador de aleatórios produza a mesma sequência do
  navegador — sem isso o humanize divergiria e a paridade quebraria.
- **A escrita usa o idioma clássico da Live API** (`select_all_notes` →
  `replace_selected_notes` → `notes n` → `note …` → `done`), que funciona do
  Live 9 ao 12, em vez de `add_new_notes`, que exige passar um dicionário.
- **Estado não é salvo com o set ainda.** Os dials são parâmetros do Live e
  se salvam sozinhos; o campo de cifras não. É a primeira coisa da v0.2
  (`pattr` no textedit).
