import os

# Cores para o terminal
GREEN = "\033[92m"
BLUE = "\033[94m"
RESET = "\033[0m"

def main():
    # Define a raiz (um nível acima da pasta do script)
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.abspath(os.path.join(script_dir, ".."))
    
    gitignore_path = os.path.join(project_root, ".gitignore")
    
    # Extensões que queremos ignorar
    ignored_extensions = [
        "*.jpg",
        "*.jpeg",
        "*.png",
        "*.pdf",
        "*.gif",  # Bônus: arquivos gif
        "*.webp"  # Bônus: arquivos webp modernos
    ]

    print(f"\n{BLUE}=== Configurador de Gitignore ==={RESET}")
    
    # Lê conteúdo existente para não duplicar
    existing_content = []
    if os.path.exists(gitignore_path):
        with open(gitignore_path, "r") as f:
            existing_content = f.read().splitlines()

    # Filtra apenas o que ainda não está lá
    to_add = [ext for ext in ignored_extensions if ext not in existing_content]

    if not to_add:
        print("✅ Todas as extensões já estão no .gitignore.")
    else:
        with open(gitignore_path, "a") as f:
            # Se o arquivo não estiver vazio e não terminar com quebra de linha, adiciona uma
            if existing_content and not existing_content[-1] == "":
                f.write("\n")
            
            f.write("# Ignorar arquivos de mídia e documentos (Auto-generated)\n")
            for ext in to_add:
                f.write(f"{ext}\n")
                print(f"{GREEN}[Adicionado]{RESET} {ext}")

    print(f"\n{GREEN}Concluído! O arquivo .gitignore na raiz foi atualizado.{RESET}\n")

if __name__ == "__main__":
    main()