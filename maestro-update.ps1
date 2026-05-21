# maestro-update.ps1 — instala ou atualiza o .maestro-core no projeto atual
# Uso: irm https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.ps1 | iex

$ErrorActionPreference = "Stop"

$REPO      = "hugomouto/maestro-domain-system"
$BRANCH    = "main"
$ZIP_URL   = "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"
$STRIP_DIR = "maestro-domain-system-$BRANCH"
$TEMP_ZIP  = Join-Path $env:TEMP "maestro-update-$(Get-Random).zip"
$TEMP_DIR  = Join-Path $env:TEMP "maestro-update-$(Get-Random)"

Write-Host "==> maestro-update: sincronizando .maestro-core/"

# Cria diretórios core se não existirem
@(
    ".maestro-core/ops/scripts",
    ".maestro-core/ops/templates",
    ".maestro-core/context",
    ".maestro-core/scripts/hooks"
) | ForEach-Object {
    New-Item -ItemType Directory -Force -Path $_ | Out-Null
}

# Baixa e extrai o zip
Write-Host "==> Baixando repositório..."
Invoke-WebRequest -Uri $ZIP_URL -OutFile $TEMP_ZIP -UseBasicParsing
Expand-Archive -Path $TEMP_ZIP -DestinationPath $TEMP_DIR -Force

$SRC_BASE = Join-Path $TEMP_DIR $STRIP_DIR

# Copia arquivos de contexto
@(
    ".maestro-core/context/create_files.md",
    ".maestro-core/context/create_domain.md",
    ".maestro-core/context/playbook.md",
    ".maestro-core/context/roadmap.md"
) | ForEach-Object {
    $src = Join-Path $SRC_BASE $_
    if (Test-Path $src) { Copy-Item $src -Destination $_ -Force }
}

# Copia diretórios (scripts, hooks e templates)
@(
    ".maestro-core/ops/scripts",
    ".maestro-core/ops/templates",
    ".maestro-core/scripts",
    ".maestro-core/scripts/hooks"
) | ForEach-Object {
    $src = Join-Path $SRC_BASE $_
    if (Test-Path $src) { Copy-Item "$src\*" -Destination $_ -Recurse -Force }
}

# Limpeza
Remove-Item $TEMP_ZIP -Force          -ErrorAction SilentlyContinue
Remove-Item $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "==> .maestro-core/ atualizado"

# CLAUDE.md
$CLAUDE_MARKER = "## Context Budget Protocol"
$CLAUDE_STUB = @"

## Context Budget Protocol

``````
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
``````

``data/raw/`` nunca entra em contexto. Regras detalhadas de routing em ``domain.yaml`` § ``context_routing``.

## Criação de Arquivos

Seguir ``.maestro-core/context/create_files.md`` sempre que a tarefa envolver criar, mover ou modificar arquivos.

## Criação de Domínios

Seguir ``.maestro-core/context/create_domain.md`` sempre que a tarefa envolver criar ou modificar domínios.
"@

if (-not (Test-Path "CLAUDE.md")) {
    Write-Host "==> CLAUDE.md não encontrado — criando"
    Set-Content "CLAUDE.md" -Encoding UTF8 -Value @"
# CLAUDE.md

## Context Budget Protocol

``````
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
``````

``data/raw/`` nunca entra em contexto. Regras detalhadas de routing em ``domain.yaml`` § ``context_routing``.

## Criação de Arquivos

Seguir ``.maestro-core/context/create_files.md`` sempre que a tarefa envolver criar, mover ou modificar arquivos.

## Criação de Domínios

Seguir ``.maestro-core/context/create_domain.md`` sempre que a tarefa envolver criar ou modificar domínios.
"@
    Write-Host "==> CLAUDE.md criado"
} elseif (-not (Select-String -Path "CLAUDE.md" -Pattern ([regex]::Escape($CLAUDE_MARKER)) -Quiet)) {
    Write-Host "==> Adicionando seções do Maestro no CLAUDE.md existente"
    Add-Content "CLAUDE.md" -Value $CLAUDE_STUB
    Write-Host "==> CLAUDE.md atualizado"
} else {
    Write-Host "==> CLAUDE.md já tem configuração do Maestro — sem alterações"
}

# domain.yaml
if (-not (Test-Path "domain.yaml")) {
    Write-Host "==> domain.yaml não encontrado — criando"
    Set-Content "domain.yaml" -Encoding UTF8 -Value @"
# domain.yaml — roteamento de contexto do Maestro
# Registre seus domínios aqui após rodar create_domain.py

domain_map: {}

context_routing: {}
"@
    Write-Host "==> domain.yaml criado"
} else {
    Write-Host "==> domain.yaml já existe — sem alterações"
}

# .claude/settings.json — registrar hooks do Maestro
$SETTINGS = ".claude/settings.json"
$HOOK_CMD = "bash .maestro-core/scripts/hooks/pre-write-creation-rules.sh"

New-Item -ItemType Directory -Force -Path ".claude" | Out-Null

if (-not (Test-Path $SETTINGS)) {
    Set-Content $SETTINGS -Encoding UTF8 -Value '{"hooks":{}}'
}

$json = Get-Content $SETTINGS -Raw | ConvertFrom-Json

# Garante que a estrutura existe
if (-not $json.hooks) { $json | Add-Member -NotePropertyName hooks -NotePropertyValue @{} }
if (-not $json.hooks.PreToolUse) { $json.hooks | Add-Member -NotePropertyName PreToolUse -NotePropertyValue @() }

# Verifica se o hook já está registrado
$alreadyRegistered = $json.hooks.PreToolUse | ForEach-Object {
    $_.hooks | Where-Object { $_.command -eq $HOOK_CMD }
} | Select-Object -First 1

if ($alreadyRegistered) {
    Write-Host "==> Hooks do Maestro já registrados — sem alterações"
} else {
    $newHook = [PSCustomObject]@{
        matcher = "Write|Edit"
        hooks   = @([PSCustomObject]@{ type = "command"; command = $HOOK_CMD })
    }
    $json.hooks.PreToolUse += $newHook
    $json | ConvertTo-Json -Depth 10 | Set-Content $SETTINGS -Encoding UTF8
    Write-Host "==> Hooks do Maestro registrados em .claude/settings.json"
}

Write-Host ""
Write-Host "Maestro instalado. Para criar um domínio:"
Write-Host "  python .maestro-core/ops/scripts/create_domain.py"
