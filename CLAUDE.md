# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## O que e este repositorio

{{DESCRIPTION}}

## Criar Domínio

Rode o script `.maestro-core/ops/scripts/create_domain.py`

## Mapa de dominios

A estrutura completa do repositorio esta em **`domain.yaml`** — ele lista todos os dominios, arquivos-chave, regras de context routing e convencoes de nomeacao.

| Dominio | Entrada | O que contem |
|---|---|---|


Cada dominio segue a estrutura padrao documentada em `STRUCTURE.md`:

```
{dominio}/
  context/        <- regras permanentes, playbook.md sempre primeiro
  data/raw/       <- dados brutos (NUNCA carregar em contexto)
  ops/tasks/      <- trabalho em aberto
  ops/routines/   <- rituais e rotinas recorrentes
  ops/templates/  <- modelos reutilizaveis
  reports/        <- relatorios datados
  archive/        <- material descontinuado
```

## Context Budget Protocol

```
1. Ler o playbook.md do dominio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessario
4. Executar
5. Encerrar — nao recarregar
```

`data/raw/` nunca entra em contexto. Regras detalhadas de routing em `domain.yaml` § `context_routing`.
