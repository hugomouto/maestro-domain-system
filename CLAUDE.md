---
description: 
alwaysApply: true
---

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## O que e este repositorio

Sistema de context routing por domínios para agentes de IA. Cada domínio encapsula suas regras, dados e tarefas em uma estrutura padronizada. O `domain.yaml` controla quais arquivos entram em contexto — evitando sobrecarga e mantendo as sessões focadas.

## Mapa de domínios

A estrutura completa do repositório está em **`domain.yaml`** — ele lista todos os domínios, arquivos-chave, regras de context routing e convenções de nomeação.

## Context Budget Protocol

```
1. Ler o playbook.md do domínio relevante
2. Decidir UMA VEZ quais context_files carregar (consultar domain.yaml)
3. Carregar apenas o necessário
4. Executar
5. Encerrar — não recarregar
```

`data/raw/` nunca entra em contexto. Regras detalhadas de routing em `domain.yaml` § `context_routing`.

## Criação de Arquivos

Seguir `.maestro-core/context/create_files.md` sempre que a tarefa envolver criar, mover ou modificar arquivos.

## Criação de Domínios

Seguir `.maestro-core/context/create_domain.md` sempre que a tarefa envolver criar ou modificar domínios.
