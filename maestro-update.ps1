# maestro-update.ps1 — instala ou atualiza o .maestro-core no projeto atual
# Uso: irm https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.ps1 | iex

$ErrorActionPreference = "Stop"

$REPO   = "hugomouto/maestro-domain-system"
$BRANCH = "main"
$ZIP_URL    = "https://github.com/$REPO/archive/refs/heads/$BRANCH.zip"
$STRIP_DIR  = "maestro-domain-system-$BRANCH"
$TEMP_ZIP   = Join-Path $env:TEMP "maestro-update-$(Get-Random).zip"
$TEMP_DIR   = Join-Path $env:TEMP "maestro-update-$(Get-Random)"

Write-Host "==> maestro-update: sincronizando .maestro-core/"

# Cria diretórios core se não existirem
@(".maestro-core/ops/scripts", ".maestro-core/ops/templates", ".maestro-core/context") | ForEach-Object {
    New-Item -ItemType Directory -Force -Path $_ | Out-Null
}

# Baixa e extrai o zip
Write-Host "==> Baixando repositório..."
Invoke-WebRequest -Uri $ZIP_URL -OutFile $TEMP_ZIP -UseBasicParsing
Expand-Archive -Path $TEMP_ZIP -DestinationPath $TEMP_DIR -Force

$SRC_BASE = Join-Path $TEMP_DIR $STRIP_DIR

# Copia arquivos de contexto
@(
    ".maestro-core/context/instructions.md",
    ".maestro-core/context/creation_rules.md",
    ".maestro-core/context/playbook.md",
    ".maestro-core/context/roadmap.md"
) | ForEach-Object {
    $src = Join-Path $SRC_BASE $_
    if (Test-Path $src) { Copy-Item $src -Destination $_ -Force }
}

# Copia diretórios (scripts e templates)
@(".maestro-core/ops/scripts", ".maestro-core/ops/templates") | ForEach-Object {
    $src = Join-Path $SRC_BASE $_
    if (Test-Path $src) { Copy-Item "$src\*" -Destination $_ -Recurse -Force }
}

# Limpeza
Remove-Item $TEMP_ZIP  -Force          -ErrorAction SilentlyContinue
Remove-Item $TEMP_DIR  -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "==> .maestro-core/ atualizado"

# CLAUDE.md
$CLAUDE_MARKER = ".maestro-core/context/instructions.md"
if (-not (Test-Path "CLAUDE.md")) {
    Write-Host "==> CLAUDE.md não encontrado — criando"
    Set-Content "CLAUDE.md" -Encoding UTF8 -Value @"
# CLAUDE.md

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
"@
    Write-Host "==> CLAUDE.md criado"
} elseif (-not (Select-String -Path "CLAUDE.md" -Pattern ([regex]::Escape($CLAUDE_MARKER)) -Quiet)) {
    Write-Host "==> Adicionando referência ao Maestro no CLAUDE.md existente"
    $stub = @"

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
"@
    Add-Content "CLAUDE.md" -Value $stub
    Write-Host "==> CLAUDE.md atualizado"
} else {
    Write-Host "==> CLAUDE.md já aponta para instructions.md — sem alterações"
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

Write-Host ""
Write-Host "Maestro instalado. Para criar um domínio:"
Write-Host "  python .maestro-core/ops/scripts/create_domain.py"
