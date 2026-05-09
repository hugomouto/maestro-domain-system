# NOW

- Atualizar o domain.yml com informações sobre o próprio maestro-core
- Configurar o CLAUDE.md para que funcione em uma lógica de IF-THEN apontando pros domínios ou casos de uso
  
# NEXT
- Ter um script em python que lê o domain.yaml e analisa quais arquivos não estão indexados lá
  - Esse script deve gerar um log em /.maestro-core/reports/ apontando quais arquivos não estão indexados por domínio.
  - Ele sempre deve ignorar a pasta /data/raw
- Quebrar o domain.yml:
  - domain_map: deve ficar na raiz, como está
  - context_routing: deve ser divido em cada um dos repositórios
- Criar tela que msotra consumo de tokens ao longo dos dias
- create_domain.py adicionar no domain.yml o que foi criado

# LATER
- Repositório/página com skills pro Maestro (ex.: metric system, etc.)