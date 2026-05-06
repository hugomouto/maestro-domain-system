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
| Novo domínio (qualquer) | Usar `create_domain.py`, não criar manualmente |

## Zona Proibida — nunca criar, modificar ou referenciar em contexto

| Diretório | Regra |
|---|---|
| `{dominio}/data/raw/` | Dados brutos — imutáveis, nunca em contexto |
| `{dominio}/archive/` | Só mover conteúdo com instrução explícita do usuário |
| `{dominio}/ops/history/` | Só mover tarefas concluídas com instrução explícita |

## Nomenclatura

Seguir `.maestro-core/ops/templates/STRUCTURE.md`:
- Sempre minúsculas com underscore
- Tarefa: `{descricao}_{id}.md`
- Template: `template_{nome}.md`
- Dado processado: `{fonte}_YYYY-MM-DD.md`
- Relatório: `report_YYYY-MM-DD.md`
