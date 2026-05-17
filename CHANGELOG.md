# Changelog

Todas as mudanças relevantes do Maestro são documentadas aqui.  
Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).  
Versionamento segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

---

## [Unreleased]

### Added
- Hook `auto-index-context.sh` — indexa automaticamente arquivos de contexto via PostToolUse
- `roadmap.md` atualizado com caminho enterprise (banco relacional via MCP)

---

## [0.5.0] — 2026-05-12

### Added
- Instalador Windows (`maestro-update.ps1`) — paridade com bash em PowerShell
- `playbook.md` populado com os três arquivos diretivos do core (instructions, creation_rules, roadmap)
- `domain.yaml` configurado como domínio vivo do próprio maestro-core

### Changed
- `context_routing` simplificado — removido `load_on_demand` e `never_load` do template
- Modelo de roteamento streamlined: foco em `always_load` e `on_request`
- `maestro-update.sh` passa a sincronizar `playbook.md` e `roadmap.md`
- README atualizado com instruções Windows e seção de atualização dedicada

---

## [0.4.0] — 2026-05-08

### Added
- Script de instalação `maestro-update.sh` — instala ou atualiza `.maestro-core/` via `curl | bash`
- Geração automática de `domain.yaml` durante instalação quando arquivo não existe
- Injeção do stub Maestro no `CLAUDE.md` existente sem sobrescrever o arquivo

### Fixed
- `domain.yaml` não era extraído do tarball do GitHub — corrigido path de extração

---

## [0.3.0] — 2026-04-28

### Added
- Templates padronizados: `template_domain.yml` e `template_playbook.md`
- `playbook.md` e `roadmap.md` criados em `.maestro-core/context/`
- `CLAUDE.md` com estrutura completa de roteamento por domínio
- `domain.yaml` movido para a raiz do repo (fonte única de verdade)
- `create_domain.py` refatorado para o novo diretório e estrutura de templates

### Changed
- Estrutura de diretórios consolidada: scripts em `.maestro-core/ops/scripts/`, templates em `.maestro-core/ops/templates/`

---

## [0.2.0] — 2026-04-19

### Added
- Suporte a argumentos CLI em `create_domain.py` para execução por LLMs sem interação
- README expandido com documentação completa do sistema

---

## [0.1.0] — 2026-04-12

### Added
- Estrutura inicial do repositório
- Conceito de context routing por domínios para agentes de IA

---

[Unreleased]: https://github.com/hugomouto/maestro-domain-system/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/hugomouto/maestro-domain-system/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/hugomouto/maestro-domain-system/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/hugomouto/maestro-domain-system/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/hugomouto/maestro-domain-system/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/hugomouto/maestro-domain-system/releases/tag/v0.1.0
