# Tarefa: Consistência dos Arquivos de Diretivas

## Contexto

O repositório maestro-domain-system serve como base de domínios de conhecimento para LLMs. À medida que novos domínios e arquivos são adicionados (empresas, personas, filhos, áreas de conhecimento, etc.), os arquivos de diretiva ficam fora de sincronia — arquivos existem no disco mas não estão classificados em `domain.yaml`, tornando-os invisíveis para o sistema de routing.

**Princípio adotado:** `domain.yaml` é a fonte única de verdade. Tudo que pode ser derivado dele deve ser derivado — não duplicado manualmente.

---

## Mudanças pendentes de implementação

### 1. `CLAUDE.md` — remover tabela de domínios vazia
- Remove `| Dominio | Entrada | O que contem |` (vazia, nunca sincronizada)
- Substitui por linha apontando direto para `domain.yaml`
- **Impacto:** LLM não encontra mais tabela vazia que contradiz o estado real

### 2. `.maestro-core/context/instructions.md` — atualizar caso de uso "Criar novo domínio"
- Reflete que `create_domain.py` vai registrar automaticamente em `domain.yaml`.

### 3. `.maestro-core/ops/scripts/create_domain.py` — auto-registro em `domain.yaml`
- Ao criar domínio, pede descrição e grava automaticamente no `domain.yaml` (domain_map + context_routing)
- Ele cria também o arquivo `context/playbook.md` no novo domínio.

---

## Regra de implementação

Mostrar o que será alterado e o impacto antes de tocar em qualquer arquivo. Aguardar confirmação explícita.
