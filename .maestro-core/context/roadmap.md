# NOW

- Ter um script em python que lê o domain.yaml e analisa quais arquivos não estão indexados lá
  - Esse script deve gerar um log em /.maestro-core/reports/ apontando quais arquivos não estão indexados por domínio.
  - Ele sempre deve ignorar a pasta /data/raw
- Quebrar o domain.yml:
  - domain_map: deve ficar na raiz, como está
  - context_routing: deve ser divido em cada um dos repositórios
- Atualizar o Maestro com a arquitetura do .maestro-core
  - pasta de scripts
  - skills /metrics-define e /metrics-update
  
# NEXT


# LATER