# STRUCTURE.md
Diretrizers de criação de arquivos

## Estrutura de um domínio

```
{dominio}/
├── context/          ← regras permanentes, MCPs, RAGs
│   └── playbook.md   ← documento principal — sempre leia primeiro
├── data/
│   ├── raw/          ← dados brutos (NUNCA em context_files)
│   ├── processed/    ← dados prontos para agentes
├── ops/
│   ├── tasks/        ← trabalho em aberto, posts, etc. (.md, .pdf, diretórios, etc)
│   ├── routines/     ← rituais, rotinas, automações e execuções baseadas em cron
│   ├── templates/    ← modelos reutilizáveis, boilerplates, esqueletos de conteúdos, etc.
│   ├── scripts/      ← scripts python, js, etc.
│   └── history/      ← concluídos
└── reports/          ← relatórios e dashboards gerados
└── archive/          ← arquivos e materiais descontinuados
    
```

## Nomeação

- Sempre minúsculas com underscore
- Playbook: `playbook.md`
- Tarefa: `{descricao}_{id}.md`
- Template: `template_{nome}.md`
- Dado processado: `{fonte}_YYYY-MM-DD.md`
- Relatório: `report_YYYY-MM-DD.md`
