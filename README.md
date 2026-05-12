# maestro-domain-system

![maestro-cover](maestro-cover.png)

Sistema de organização de contexto para agentes de IA baseado em **domínios**. Define uma estrutura de pastas padronizada e um arquivo de roteamento (`domain.yaml`) que instrui o agente quais arquivos de contexto carregar para cada área de trabalho.

---

## O que é

O `maestro-domain-system` é uma convenção de organização de projetos orientada a agentes. Em vez de jogar arquivos aleatórios em uma conversa, você estrutura o conhecimento em **domínios** (ex: `marketing`, `financeiro`, `produto`) e declara explicitamente o que o agente deve ler, pode ler sob demanda, e nunca deve ler.

O arquivo `domain.yaml` funciona como o "manifesto de roteamento de contexto" — o agente consulta esse arquivo para saber como se orientar dentro de um domínio.

---

## Estrutura de um domínio

```
{dominio}/
├── context/          ← regras permanentes, MCPs, RAGs
│   └── playbook.md   ← documento principal — sempre leia primeiro
├── data/
│   ├── raw/          ← dados brutos (NUNCA carregados como contexto)
│   └── processed/    ← dados prontos para agentes
├── ops/
│   ├── tasks/        ← trabalho em aberto (.md, .pdf, diretórios, etc.)
│   ├── routines/     ← rituais, rotinas, automações baseadas em cron
│   ├── templates/    ← boilerplates e esqueletos reutilizáveis
│   └── history/      ← tarefas concluídas
└── reports/
└── archive/
```

---

## Roteamento de contexto (`domain.yaml`)

O `domain.yaml` define, por domínio, quais arquivos o agente carrega:

```yaml
domain_map:
  marketing:
    description: Marketing, Campaigns, Leads, etc

context_routing:
  marketing:
    always_load:       # carregado em toda conversa do domínio
      - ./marketing/context/playbook.md
    load_on_demand:    # carregado apenas quando relevante
      - ./marketing/context/brand-strategy.md
      - ./marketing/context/brand-voice.md
      - ./marketing/context/visual-identity.md
    never_load:        # explicitamente bloqueado
      - ./marketing/data/raw/
```

| Chave | Comportamento |
|---|---|
| `always_load` | O agente lê esses arquivos no início de toda sessão do domínio |
| `load_on_demand` | O agente lê apenas se a tarefa exigir |
| `never_load` | Nunca incluir como contexto (ex: dados brutos grandes) |

---

## Convenções de nomeação

- Sempre **minúsculas com underscore**
- Playbook: `playbook.md`
- Tarefa: `{descricao}_{id}.md`
- Template: `template_{nome}.md`
- Dado processado: `{fonte}_YYYY-MM-DD.md`
- Relatório: `report_YYYY-MM-DD.md`

---

## Instalação

**Mac / Linux / WSL**

```bash
curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.ps1 | iex
```

O script:
- Cria `.maestro-core/` com scripts, templates e instruções
- Cria `CLAUDE.md` apontando para as instruções do Maestro — ou acrescenta o bloco se `CLAUDE.md` já existir

---

## Atualização

Para receber as últimas diretrizes e scripts do Maestro em um projeto já instalado, rode o mesmo comando na raiz do projeto.

**Mac / Linux / WSL**

```bash
curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash
```

**Windows (PowerShell)**

```powershell
irm https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.ps1 | iex
```

O script atualiza apenas os arquivos core (`.maestro-core/ops/scripts/`, `.maestro-core/ops/templates/`, instruções) e nunca toca em `CLAUDE.md`, `playbook.md`, tasks, reports ou qualquer conteúdo do projeto.

---

## Como Começar a Usar

### 1. Instale o Maestro

**Mac / Linux / WSL**
```bash
curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash
```

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.ps1 | iex
```

### 2. Crie um domínio

```bash
python .maestro-core/ops/scripts/create_domain.py
```

Ele abre um menu interativo no terminal:

```
=== Maestro: Gerador de Domínios ===

[1] Criar novo domínio do zero
[2] Estruturar dentro de domínio existente

Escolha:
```

- Opção **1**: informe o nome do domínio e toda a estrutura de pastas + `playbook.md` é criada automaticamente.
- Opção **2**: escolha uma pasta já existente para aplicar a estrutura padrão dentro dela.

### 3. Fluxo completo

1. Instale com `maestro-update.sh`
2. Rode `create_domain.py` para gerar a estrutura do domínio
3. Escreva o `playbook.md` com as regras e contexto permanente do domínio
4. Registre o domínio e suas rotas de contexto no `domain.yaml`
5. Ao iniciar uma sessão, informe ao agente qual domínio está ativo — ele saberá quais arquivos carregar
