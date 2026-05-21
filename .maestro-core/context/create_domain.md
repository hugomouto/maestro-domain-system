---
title: Criação e Gestão de Domínios
read_when: criar novo domínio, modificar estrutura de domínio existente, registrar domínio em domain.yaml
skip_if: tarefa não envolve estrutura ou criação de domínios
summary: criar domínio via script, registrar em domain.yaml, trabalhar dentro de um domínio
---

# Criação e Gestão de Domínios

## Criar novo domínio

Sempre rodar o script — nunca criar a estrutura manualmente:

```bash
python .maestro-core/ops/scripts/create_domain.py {nome_dominio}
```

Após criação:
1. Atualizar `domain.yaml` com o novo domínio — zona restrita, pedir confirmação antes
2. Preencher `{dominio}/context/playbook.md` com contexto inicial do domínio

## Trabalhar em um domínio específico

1. Ler `{dominio}/context/playbook.md` primeiro
2. Consultar `domain.yaml` para decidir quais `context_files` carregar
3. Não recarregar contexto durante a sessão

## Criar arquivo de contexto em `{dominio}/context/`

Se o conhecimento for perene ao domínio e fizer sentido ser revisitado futuramente:
1. Criar com extensão `.md` e frontmatter seguindo `create_files.md`
2. Registrar o novo arquivo em `{dominio}/context/playbook.md`
3. Zona restrita — pedir autorização antes de criar
