# Regras de Criação de Arquivos

Diretrizes para Claude Code: onde pode criar livremente, quando pedir autorização, e o que nunca tocar.

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
| Novo domínio (qualquer) | Usar `create_domain.py`, não criar manualmente |

## Nomenclatura

Seguir `.maestro-core/ops/templates/STRUCTURE.md`:
- Sempre minúsculas com underscore
- Tarefa: `{descricao}_{id}.md`
- Template: `template_{nome}.md`
- Dado processado: `{fonte}_YYYY-MM-DD.md`
- Relatório: `report_YYYY-MM-DD.md`

## Estrutura de Arquivos
- Todos os arquivos `.md` e `.yml` devem começar com um frontmatter seguindo o exemplo:
```
---
title: Brand Voice
read_when: generating or reviewing copy, bios, posts, headlines
skip_if: technical task with no user-facing text output
summary: tone of voice, brand attributes, editorial guide, banned words list
---
```
- Todos os scripts (python, js, etc) devem começar com metadados na estrutura de exemplo, adaptando a forma de comentário da linguagem:
```
"""
purpose: Scaffold a new domain directory structure
run: python create_domain.py <domain_name>
"""
```