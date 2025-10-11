#!/usr/bin/env bash
set -euo pipefail

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
RESET='\033[0m'

# === Header ===
echo -e "${BLUE}🩺 Dotfiles Doctor — diagnostic de ton environnement${RESET}\n"

# === 1. Vérification des symlinks ===
echo -e "${YELLOW}🔗 Vérification des liens symboliques...${RESET}"
declare -A LINKS=(
  ["~/.zshrc"]="$HOME/.files/zsh/zshrc"
  ["~/.aliases"]="$HOME/.files/zsh/aliases"
  ["~/bin"]="$HOME/.files/bin"
  ["~/.gitconfig"]="$HOME/.files/git/gitconfig"
)

for link in "${!LINKS[@]}"; do
  expanded_link=$(eval echo "$link")
  target=${LINKS[$link]}

  if [ -L "$expanded_link" ]; then
    if [ "$(readlink -f "$expanded_link")" = "$(readlink -f "$target")" ]; then
      echo -e "✅ $link → ${GREEN}OK${RESET}"
    else
      echo -e "⚠️  $link → ${YELLOW}pointe vers une mauvaise cible${RESET}"
    fi
  elif [ -e "$expanded_link" ]; then
    echo -e "❌ $link → ${RED}existe mais n’est pas un lien symbolique${RESET}"
  else
    echo -e "❌ $link → ${RED}n’existe pas${RESET}"
  fi
done

echo ""

# === 2. Vérification du PATH ===
echo -e "${YELLOW}🛣️ Vérification du PATH...${RESET}"
if [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
  echo -e "✅ ~/bin est bien dans le PATH"
else
  echo -e "❌ ~/bin ${RED}n’est pas dans le PATH${RESET}"
fi
echo ""

# === 3. Vérification de la présence de Zsh et des plugins ===
echo -e "${YELLOW}🐚 Vérification de Zsh et des plugins...${RESET}"
if command -v zsh >/dev/null 2>&1; then
  echo -e "✅ Zsh installé"
else
  echo -e "❌ ${RED}Zsh n’est pas installé${RESET}"
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGINS=( "zsh-autosuggestions" "zsh-syntax-highlighting" )
for plugin in "${PLUGINS[@]}"; do
  if [ -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
    echo -e "✅ Plugin ${plugin}"
  else
    echo -e "❌ ${RED}Plugin manquant : ${plugin}${RESET}"
  fi
done
echo ""

# === 4. Vérification des scripts dans ~/.files/bin ===
echo -e "${YELLOW}⚙️ Vérification des scripts personnalisés...${RESET}"
for script in "$HOME/.files/bin/"*; do
  if [ -x "$script" ]; then
    echo -e "✅ $(basename "$script") exécutable"
  else
    echo -e "❌ ${RED}$(basename "$script") n’est pas exécutable${RESET}"
  fi
done
echo ""

# === 5. Vérification de Git et des configs ===
echo -e "${YELLOW}🔧 Vérification de Git...${RESET}"
if command -v git >/dev/null 2>&1; then
  echo -e "✅ Git installé : $(git --version | cut -d' ' -f3)"
  echo -e "🧩 Email global : $(git config --global user.email || echo 'Non défini')"
else
  echo -e "❌ ${RED}Git non installé${RESET}"
fi

echo -e "\n${GREEN}✅ Diagnostic terminé.${RESET}"
