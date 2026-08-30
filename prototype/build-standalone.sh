#!/usr/bin/env bash
# Gera prototype/index.html (documento completo) a partir de
# prototype/instantchord.html (corpo do Artifact, sem doctype/head/body).
set -euo pipefail
cd "$(dirname "$0")"
{
  printf '%s\n' '<!doctype html>' '<html lang="pt-BR">' '<head>' \
    '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width, initial-scale=1">' \
    '</head>' '<body>'
  cat instantchord.html
  printf '%s\n' '</body>' '</html>'
} > index.html
echo "index.html gerado ($(wc -c < index.html) bytes)"
