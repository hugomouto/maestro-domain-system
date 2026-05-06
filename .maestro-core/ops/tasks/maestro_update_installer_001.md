# Task: maestro-update — Instalador e Atualizador Remoto

## Objetivo

Transformar este repo em um pacote instalável remotamente via `curl | bash`, permitindo que qualquer projeto receba o `.maestro-core/` atualizado sem precisar clonar o repo maestro previamente.

---

## Arquivos a criar / modificar

### 1. `.maestro-core/context/instructions.md` — CRIAR
**Ação:** Extrair todas as instruções de uso do Claude Code que estão no `CLAUDE.md` atual e mover para cá.

Conteúdo a mover:
- Context Budget Protocol
- Regras de Criação de Arquivos (resumo + zonas)
- Casos de Uso (IF-THEN: criar tarefa, relatório, domínio, trabalhar em domínio)
- Referência ao `domain.yaml` e ao `create_domain.py`

Este arquivo é "core" — atualizado a cada `maestro-update`.

---

### 2. `CLAUDE.md` (neste repo) — MODIFICAR
**Ação:** Deixar apenas o bloco de identidade do repositório + stub de referência ao instructions.md.

O que fica:
- Descrição do repositório (`## O que é este repositório`)
- Stub: `## Maestro — Carregar .maestro-core/context/instructions.md`

O que sai (vai para `instructions.md`):
- Context Budget Protocol
- Regras de Criação de Arquivos
- Casos de Uso

---

### 3. `maestro-update.sh` — CRIAR (raiz do repo)
**Ação:** Script principal de instalação e atualização remota.

Lógica:

```
REPO = hugomouto/maestro-domain-system
BRANCH = main

1. Baixar tarball do GitHub
2. Extrair apenas os arquivos "core" do .maestro-core/ no diretório atual:
   - ops/scripts/         (create_domain.py e futuros scripts)
   - ops/templates/       (templates de domínio)
   - context/instructions.md
   - context/creation_rules.md

3. Lógica do CLAUDE.md:
   - Se CLAUDE.md NÃO existe → criar com conteúdo mínimo apontando para instructions.md
   - Se CLAUDE.md existe E não contém o apontamento → acrescentar o bloco ao final
   - Se CLAUDE.md existe E já contém o apontamento → não tocar

4. Nunca tocar:
   - playbook.md, roadmap.md (contexto do projeto)
   - reports/, ops/tasks/, ops/history/, data/ (conteúdo do projeto)
   - Resto do CLAUDE.md (instruções do projeto)
```

**Invocação:**
```bash
curl -sSL https://raw.githubusercontent.com/hugomouto/maestro-domain-system/main/maestro-update.sh | bash
```

---

## Stub mínimo do CLAUDE.md (template para instalação nova)

```markdown
# CLAUDE.md

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
```

---

## Marcador de apontamento no CLAUDE.md existente

O script verifica a presença desta string exata antes de acrescentar:

```
.maestro-core/context/instructions.md
```

Se não encontrar, acrescenta ao final:

```markdown

## Maestro

Carregar `.maestro-core/context/instructions.md` no início de cada sessão.
```

---

## Ordem de execução

1. Criar `instructions.md` (extrai do CLAUDE.md atual)
2. Modificar `CLAUDE.md` deste repo (deixar só identidade + stub)
3. Criar `maestro-update.sh`
4. Testar localmente apontando para um diretório vazio e para um com CLAUDE.md existente

---

## Fora do escopo desta task

- Autenticação para repos privados
- Versionamento semântico do maestro
- Changelog de updates
