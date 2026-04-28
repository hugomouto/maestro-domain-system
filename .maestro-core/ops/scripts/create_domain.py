import os
import sys

# Cores para o terminal
GREEN = "\033[92m"
BLUE = "\033[94m"
YELLOW = "\033[93m"
RESET = "\033[0m"

def create_file(path, content):
    if not os.path.exists(path):
        with open(path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  {GREEN}[Arquivo]{RESET} {os.path.basename(path)}")

def create_dir(path, root_reference):
    if not os.path.exists(path):
        os.makedirs(path)
        # Mostra o caminho relativo à raiz para ficar limpo
        rel_path = os.path.relpath(path, start=root_reference)
        print(f"{GREEN}[Pasta]{RESET} {rel_path}")

def generate_structure(target_path, root_ref):
    # --- Context ---
    context_dir = os.path.join(target_path, "context")
    create_dir(context_dir, root_ref)
    create_file(os.path.join(context_dir, "playbook.md"), "# Playbook\nSempre leia primeiro.")

    # --- Data ---
    data_dir = os.path.join(target_path, "data")
    create_dir(data_dir, root_ref)
    create_dir(os.path.join(data_dir, "raw"), root_ref)
    create_dir(os.path.join(data_dir, "processed"), root_ref)

    # --- Ops ---
    ops_dir = os.path.join(target_path, "ops")
    create_dir(ops_dir, root_ref)
    for sub in ["tasks", "routines", "templates", "history"]:
        create_dir(os.path.join(ops_dir, sub), root_ref)

    # --- Outros ---
    create_dir(os.path.join(target_path, "reports"), root_ref)
    create_dir(os.path.join(target_path, "archive"), root_ref)

def main():
    # AJUSTE AQUI: Sobe 3 níveis para sair de .maestro-core/ops/scripts e chegar na raiz
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, "..", "..", ".."))
    
    os.chdir(project_root) # Garante que estamos operando na raiz do projeto

    print(f"\n{BLUE}=== Maestro: Gerador de Domínios ==={RESET}")
    print(f"Raiz detectada: {YELLOW}{project_root}{RESET}")
    print(f"Local da instalação: {YELLOW}.maestro-core{RESET}\n")

    # Lista diretórios na raiz ignorando pastas ocultas (como .git ou .maestro-core)
    existing_dirs = [d for d in os.listdir('.') if os.path.isdir(d) and not d.startswith('.')]

    print("[1] Criar novo domínio do zero na raiz")
    if existing_dirs:
        print("[2] Estruturar dentro de domínio existente")
    
    choice = input("\nEscolha: ").strip()

    if choice == "2" and existing_dirs:
        print("\nDomínios detectados na raiz:")
        for i, d in enumerate(existing_dirs): print(f"({i+1}) {d}")
        try:
            idx = int(input("Número: ")) - 1
            target_name = existing_dirs[idx]
        except (ValueError, IndexError):
            print(f"{YELLOW}Seleção inválida. Abortando.{RESET}")
            return
    else:
        target_name = input("Nome do novo domínio: ").strip()

    if not target_name:
        print(f"{YELLOW}Nome vazio. Abortando.{RESET}")
        return

    target_path = os.path.join(project_root, target_name)
    
    if not os.path.exists(target_path):
        os.makedirs(target_path)
    
    generate_structure(target_path, project_root)
    print(f"\n{GREEN}✅ Sucesso! Domínio '{target_name}' criado na raiz do projeto.{RESET}\n")

if __name__ == "__main__":
    main()