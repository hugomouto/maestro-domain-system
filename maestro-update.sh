#!/usr/bin/env bash
# maestro-update — instala ou atualiza o .maestro-core no projeto atual
# Uso: curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash

set -euo pipefail

REPO="hugomouto/maestro-domain-system"
BRANCH="main"
TARBALL_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
STRIP_DIR="maestro-domain-system-$BRANCH"

CLAUDE_MARKER=".maestro-core/context/instructions.md"
CLAUDE_STUB='
## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.'

echo "==> maestro-update: sincronizando .maestro-core/"

# Cria diretórios core se não existirem
mkdir -p .maestro-core/ops/scripts
mkdir -p .maestro-core/ops/templates
mkdir -p .maestro-core/context

# Baixa o tarball e extrai apenas os arquivos core
curl -sSL "$TARBALL_URL" | tar xz \
  --strip-components=1 \
  --wildcards \
  "$STRIP_DIR/.maestro-core/ops/scripts/*" \
  "$STRIP_DIR/.maestro-core/ops/templates/*" \
  "$STRIP_DIR/.maestro-core/context/instructions.md" \
  "$STRIP_DIR/.maestro-core/context/creation_rules.md" \
  "$STRIP_DIR/.maestro-core/context/playbook.md" \
  "$STRIP_DIR/.maestro-core/context/roadmap.md" \
  2>/dev/null || true

echo "==> .maestro-core/ atualizado"

# Lógica do CLAUDE.md
if [ ! -f "CLAUDE.md" ]; then
  echo "==> CLAUDE.md não encontrado — criando"
  cat > CLAUDE.md <<'EOF'
# CLAUDE.md

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
EOF
  echo "==> CLAUDE.md criado"
elif ! grep -qF "$CLAUDE_MARKER" CLAUDE.md; then
  echo "==> Adicionando referência ao Maestro no CLAUDE.md existente"
  printf '%s\n' "$CLAUDE_STUB" >> CLAUDE.md
  echo "==> CLAUDE.md atualizado"
else
  echo "==> CLAUDE.md já aponta para instructions.md — sem alterações"
fi

# Lógica do domain.yaml
if [ ! -f "domain.yaml" ]; then
  echo "==> domain.yaml não encontrado — criando"
  cat > domain.yaml <<'EOF'
# domain.yaml — roteamento de contexto do Maestro
# Registre seus domínios aqui após rodar create_domain.py

domain_map: {}

context_routing: {}
EOF
  echo "==> domain.yaml criado"
else
  echo "==> domain.yaml já existe — sem alterações"
fi

echo ""
echo "Maestro instalado. Para criar um domínio:"
echo "  python .maestro-core/ops/scripts/create_domain.py"
