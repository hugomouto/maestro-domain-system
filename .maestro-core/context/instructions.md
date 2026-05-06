# Maestro — Instruções para Claude Code

Este arquivo contém as regras de comportamento do Claude Code em qualquer projeto que use o maestro-domain-system.

---

## Context Budget Protocol

```
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
```

`data/raw/` nunca entra em contexto. Regras detalhadas de routing em `domain.yaml` § `context_routing`.

---

## Criar Domínio

Rodar `.maestro-core/ops/scripts/create_domain.py` — nunca criar estrutura manualmente.

---

## Regras de Criação de Arquivos

Carregar `.maestro-core/context/creation_rules.md` sempre que a tarefa envolver criar, mover ou modificar arquivos do repositório.

Resumo:
- **Zona Livre** (criar sem pedir): `ops/tasks/`, `ops/templates/`, `reports/`, `data/processed/`
- **Zona Restrita** (pedir antes): `context/`, `ops/routines/`, `domain.yaml`, `CLAUDE.md`, novo domínio
- **Zona Proibida** (nunca): `data/raw/`, `archive/`, `ops/history/`

---

## Casos de Uso

### Criar nova tarefa ou item de trabalho
**Se**: o usuário pedir para criar uma tarefa, post, item ou qualquer trabalho em aberto  
**Então**:
1. Criar em `{dominio}/ops/tasks/`
2. Nomear como `{descricao}_{id}.md`
3. Zona livre — não pedir autorização

### Criar relatório ou análise
**Se**: o usuário pedir um relatório, análise, dashboard ou resumo  
**Então**:
1. Criar em `{dominio}/reports/`
2. Nomear como `report_YYYY-MM-DD.md`
3. Zona livre — não pedir autorização

### Criar novo domínio
**Se**: o usuário quiser criar um novo domínio  
**Então**:
1. Rodar `.maestro-core/ops/scripts/create_domain.py` — não criar estrutura manualmente
2. Após criação, atualizar `domain.yaml` com o novo domínio
3. Pedir confirmação antes de alterar `domain.yaml`

### Trabalhar em um domínio específico
**Se**: a conversa envolver um domínio específico  
**Então**:
1. Ler `{dominio}/context/playbook.md` primeiro
2. Consultar `domain.yaml` para decidir quais `context_files` carregar
3. Não recarregar contexto durante a sessão
