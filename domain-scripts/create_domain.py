import os
import sys
import argparse

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
    parser = argparse.ArgumentParser(description="Maestro: Gerador de Domínios")
    parser.add_argument("domain", nargs="?", help="Nome do domínio a criar ou estruturar")
    parser.add_argument("--existing", action="store_true", help="Estruturar dentro de domínio existente")
    args = parser.parse_args()

    non_interactive = args.domain is not None

    # Define a RAIZ como sendo um nível acima de onde o script está (.maestro-scripts/..)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, ".."))

    os.chdir(project_root) # Garante que estamos operando na raiz

    print(f"\n{BLUE}=== Maestro: Gerador de Domínios ==={RESET}")
    print(f"Raiz detectada: {YELLOW}{project_root}{RESET}\n")

    existing_dirs = [d for d in os.listdir('.') if os.path.isdir(d) and not d.startswith('.')]

    if non_interactive:
        if args.existing:
            if args.domain not in existing_dirs:
                print(f"Erro: domínio '{args.domain}' não encontrado. Existentes: {existing_dirs}")
                sys.exit(1)
        target_name = args.domain
    else:
        print("[1] Criar novo domínio do zero")
        if existing_dirs:
            print("[2] Estruturar dentro de domínio existente")

        choice = input("\nEscolha: ").strip()

        if choice == "2" and existing_dirs:
            for i, d in enumerate(existing_dirs): print(f"({i+1}) {d}")
            idx = int(input("Número: ")) - 1
            target_name = existing_dirs[idx]
        else:
            target_name = input("Nome do novo domínio: ").strip()

    target_path = os.path.join(project_root, target_name)

    if not os.path.exists(target_path):
        os.makedirs(target_path)

    generate_structure(target_path, project_root)
    print(f"\n{GREEN}✅ Estrutura pronta em: {target_name}{RESET}\n")

if __name__ == "__main__":
    main()