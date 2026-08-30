# Roadmap

## v1 — o device

Escopo fechado. Tudo abaixo já está resolvido no protótipo.

- [x] Porta do motor para ES5 (`max/instantchord.js`), com paridade testada
- [x] Gerador do `.amxd` (`max/build/`), formato do container verificado
- [x] Escrita no clip pela Live API
- [ ] Rodar dentro do Live e corrigir o que quebrar
- [ ] Grade de 8 pads em `jsui`, com os gestos: clique, arraste vertical
      (inversão), shift+arraste (extensão), alt+clique (grau vizinho)
- [ ] Três macros — Motion, Spread, Density
- [ ] Gate, Humanize, Direção, Seed
- [ ] Condução de vozes automática (ligada por padrão)
- [ ] Tonalidade e escala; entrada por grau
- [ ] Campo de cifras: digitar a progressão, detectar o tom, transpor
- [ ] Preview ao vivo na cadeia MIDI da track
- [ ] Botão **Write** → `add_new_notes` na clip selecionada
- [ ] Persistência do campo de cifras no set (`pattr`) — os dials já salvam
- [ ] Persistência do estado completo (`pattrstorage`)

## v2 — o que dá para adicionar depois

- Casca MIDI Tool para o painel *Generate*
- Empréstimo modal por pad: acordes de fora da escala sem trocar a tonalidade
- Dominantes secundárias (V/x) como variação no alt+clique
- Probabilidade por voz — vozes agudas que caem às vezes
- Padrões rítmicos nomeados, editáveis, salvos com o set
- Bibliotecas de progressão do usuário
- Mapeamento para o Push
- Arraste do device para a track, exportando `.mid`

## Fora de escopo

- VST3/AU. Ver [`decisao-plataforma.md`](decisao-plataforma.md).
- Detecção de acorde a partir de MIDI de entrada.
- Geração por IA. O objetivo é controle, não sugestão.
