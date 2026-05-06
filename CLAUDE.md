# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working in this repository.

## O que e este repositorio

Sistema de context routing por domínios para agentes de IA. Cada domínio encapsula suas regras, dados e tarefas em uma estrutura padronizada. O `domain.yaml` controla quais arquivos entram em contexto — evitando sobrecarga e mantendo as sessões focadas.

## Mapa de domínios

A estrutura completa do repositório está em **`domain.yaml`** — ele lista todos os domínios, arquivos-chave, regras de context routing e convenções de nomeação.

| Dominio | Entrada | O que contem |
|---|---|---|

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
