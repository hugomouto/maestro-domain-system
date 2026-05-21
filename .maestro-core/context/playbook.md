# Domínio .maestro-core

## Diretivas do Sistema

`context/instructions.md`
- Content: Protocolo de contexto, zonas de criação de arquivos e fluxos de uso (criar tarefa, domínio, relatório, trabalhar em domínio)
- Use: Carregar em toda sessão como referência de comportamento — define o que Claude Code pode, deve e não pode fazer neste repositório

`context/creation_rules.md`
- Content: Modelo de três zonas de permissão (Livre / Restrita / Proibida) com regras de nomenclatura e convenções de estrutura de arquivos
- Use: Consultar antes de criar ou mover qualquer arquivo — especialmente em context/, domain.yaml, CLAUDE.md ou data/raw/

`context/roadmap.md`
- Content: Itens priorizados em NOW / NEXT / LATER para o desenvolvimento do framework maestro
- Use: Verificar antes de propor novas features ou mudanças estruturais — evita duplicar trabalho planejado

`context/create_files.md`
- Content: Regras para criação e organização de arquivos no repositório, definindo zonas livre/restrita, nomenclatura, estrutura de frontmatter e proibindo criação na raiz.
- Use: Sempre que Claude for criar, mover ou modificar arquivos no repositório, garantindo conformidade com as zonas de permissão e convenções de nomeação.

`context/create_domain.md`
- Content: Instruções para criação de novos domínios usando script, registro em domain.yaml, e gestão de arquivos de contexto dentro de domínios existentes.
- Use: Claude deve carregar este arquivo ao criar novo domínio, modificar estrutura de domínio, ou registrar domínio em domain.yaml.
