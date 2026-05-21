#!/usr/bin/env bash
# PreToolUse:Write,Edit — injeta regras de criação de arquivos antes de qualquer operação de escrita

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
RULES="$REPO_ROOT/.maestro-core/context/create_files.md"

[ -f "$RULES" ] || exit 0

cat "$RULES"
