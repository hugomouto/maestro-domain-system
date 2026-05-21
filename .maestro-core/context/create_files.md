---
title: Regras de Criação de Arquivos
read_when: criar, mover ou modificar arquivos no repositório
skip_if: tarefa não envolve criação ou modificação de arquivos
summary: zonas livre e restrita, nomenclatura, estrutura de frontmatter, nunca criar na raiz
---

# Regras de Criação de Arquivos

**Nunca criar arquivos fora de um diretório de domínio existente.** A raiz do repositório é zona proibida.

## Zona Livre — criar sem pedir

| Diretório | Tipo de conteúdo |
|---|---|
| `{dominio}/ops/tasks/` | Tarefas, itens de trabalho, rascunhos |
| `{dominio}/ops/templates/` | Templates e boilerplates |
| `{dominio}/reports/` | Relatórios e dashboards gerados |
| `{dominio}/data/processed/` | Dados processados prontos para uso |

## Zona Restrita — pedir autorização antes de criar ou modificar

| Arquivo / Diretório | Motivo |
|---|---|
| `{dominio}/context/` | Altera regras de context routing do domínio |
| `{dominio}/ops/routines/` | Automações com efeitos colaterais (cron, etc.) |
| `domain.yaml` | Mapeamento global — impacto em todos os domínios |
| `CLAUDE.md` | Instruções do sistema |
| `{dominio}/data/raw/` | Dados brutos — imutáveis, nunca em contexto |
| `{dominio}/archive/` | Só mover conteúdo com instrução explícita do usuário |
| `{dominio}/ops/history/` | Só mover tarefas concluídas com instrução explícita |
| Raiz do repositório | Proibido — todo arquivo pertence a um domínio |

## Nomenclatura

Seguir `.maestro-core/ops/templates/STRUCTURE.md`:
- Sempre minúsculas com underscore
- Tarefa: `{descricao}_{id}.md`
- Template: `template_{nome}.md`
- Dado processado: `{fonte}_YYYY-MM-DD.md`
- Relatório: `report_YYYY-MM-DD.md`

## Estrutura de Arquivos

Todos os `.md` e `.yml` devem começar com frontmatter:
```yaml
---
title: Brand Voice
read_when: generating or reviewing copy, bios, posts, headlines
skip_if: technical task with no user-facing text output
summary: tone of voice, brand attributes, editorial guide, banned words list
---
```

Scripts devem começar com metadados adaptados à linguagem:
```python
"""
purpose: Scaffold a new domain directory structure
run: python create_domain.py <domain_name>
"""
```

## Casos de Uso

### Criar tarefa ou item de trabalho
Criar em `{dominio}/ops/tasks/` como `{descricao}_{id}.md` — zona livre, sem pedir autorização.

### Criar relatório ou análise
Criar em `{dominio}/reports/` como `report_YYYY-MM-DD.md` — zona livre, sem pedir autorização.

### Criar arquivo de contexto de domínio
Criar em `{dominio}/context/` com frontmatter — zona restrita, pedir antes.
Após criação, atualizar `{dominio}/context/playbook.md` com referência ao novo arquivo.
