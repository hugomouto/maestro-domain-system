#!/usr/bin/env bash
# maestro-update — instala ou atualiza o .maestro-core no projeto atual
# Uso: curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash

set -euo pipefail

REPO="hugomouto/maestro-domain-system"
BRANCH="main"
TARBALL_URL="https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz"
STRIP_DIR="maestro-domain-system-$BRANCH"

CLAUDE_MARKER="## Context Budget Protocol"
CLAUDE_STUB='
## Context Budget Protocol

```
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
```

`data/raw/` nunca entra em contexto. Regras detalhadas de routing em `domain.yaml` § `context_routing`.

## Criação de Arquivos

Seguir `.maestro-core/context/create_files.md` sempre que a tarefa envolver criar, mover ou modificar arquivos.

## Criação de Domínios

Seguir `.maestro-core/context/create_domain.md` sempre que a tarefa envolver criar ou modificar domínios.'

echo "==> maestro-update: sincronizando .maestro-core/"

# Cria diretórios core se não existirem
mkdir -p .maestro-core/ops/scripts
mkdir -p .maestro-core/ops/templates
mkdir -p .maestro-core/context
mkdir -p .maestro-core/scripts/hooks

# Baixa o tarball e extrai arquivos core
curl -sSL "$TARBALL_URL" | tar xz \
  --strip-components=1 \
  --wildcards \
  "$STRIP_DIR/.maestro-core/context/create_files.md" \
  "$STRIP_DIR/.maestro-core/context/create_domain.md" \
  "$STRIP_DIR/.maestro-core/context/playbook.md" \
  "$STRIP_DIR/.maestro-core/context/roadmap.md" \
  "$STRIP_DIR/.maestro-core/ops/scripts/*" \
  "$STRIP_DIR/.maestro-core/ops/templates/*" \
  "$STRIP_DIR/.maestro-core/scripts/*" \
  "$STRIP_DIR/.maestro-core/scripts/hooks/*" \
  2>/dev/null || true

echo "==> .maestro-core/ atualizado"

# CLAUDE.md
if [ ! -f "CLAUDE.md" ]; then
  echo "==> CLAUDE.md não encontrado — criando"
  cat > CLAUDE.md <<'EOF'
# CLAUDE.md

## Context Budget Protocol

```
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
```

`data/raw/` nunca entra em contexto. Regras detalhadas de routing em `domain.yaml` § `context_routing`.

## Criação de Arquivos

Seguir `.maestro-core/context/create_files.md` sempre que a tarefa envolver criar, mover ou modificar arquivos.

## Criação de Domínios

Seguir `.maestro-core/context/create_domain.md` sempre que a tarefa envolver criar ou modificar domínios.
EOF
  echo "==> CLAUDE.md criado"
elif ! grep -qF "$CLAUDE_MARKER" CLAUDE.md; then
  echo "==> Adicionando seções do Maestro no CLAUDE.md existente"
  printf '%s\n' "$CLAUDE_STUB" >> CLAUDE.md
  echo "==> CLAUDE.md atualizado"
else
  echo "==> CLAUDE.md já tem configuração do Maestro — sem alterações"
fi

# domain.yaml
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

# .claude/settings.json — registrar hooks do Maestro
SETTINGS=".claude/settings.json"
HOOK_CMD="bash .maestro-core/scripts/hooks/pre-write-creation-rules.sh"

mkdir -p .claude

if ! command -v jq &>/dev/null; then
  echo "==> AVISO: jq não encontrado — hooks não registrados"
  echo "    Instale jq e rode maestro-update novamente."
else
  if [ ! -f "$SETTINGS" ]; then
    echo '{"hooks":{}}' > "$SETTINGS"
  fi

  ALREADY=$(jq -r --arg cmd "$HOOK_CMD" '
    .hooks.PreToolUse // [] | map(.hooks[]?.command) | flatten | any(. == $cmd)
  ' "$SETTINGS" 2>/dev/null || echo "false")

  if [ "$ALREADY" = "true" ]; then
    echo "==> Hooks do Maestro já registrados — sem alterações"
  else
    jq --arg cmd "$HOOK_CMD" '
      .hooks.PreToolUse = ((.hooks.PreToolUse // []) + [
        {"matcher": "Write|Edit", "hooks": [{"type": "command", "command": $cmd}]}
      ])
    ' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
    echo "==> Hooks do Maestro registrados em .claude/settings.json"
  fi
fi

echo ""
echo "Maestro instalado. Para criar um domínio:"
echo "  python .maestro-core/ops/scripts/create_domain.py"
