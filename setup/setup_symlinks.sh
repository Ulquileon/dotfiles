#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.files}"
backup() {
  local target="$1"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mv "$target" "${target}.bak_$(date +%Y%m%d_%H%M%S)"
    echo "💾 Backup: ${target} -> ${target}.bak_*"
  fi
}

echo "🔗 Création/refresh des symlinks"

# ZSHRC
backup "$HOME/.zshrc"
ln -sfn "$DOTFILES_DIR/zsh/zshrc" "$HOME/.zshrc"
echo "→ ~/.zshrc  -> $DOTFILES_DIR/zsh/zshrc"

# Aliases (ton choix: nom standard ~/.aliases)
backup "$HOME/.aliases"
ln -sfn "$DOTFILES_DIR/zsh/aliases" "$HOME/.aliases"
echo "→ ~/.aliases -> $DOTFILES_DIR/zsh/aliases"

# Bin (scripts perso)
backup "$HOME/bin"
ln -sfn "$DOTFILES_DIR/bin" "$HOME/bin"
echo "→ ~/bin      -> $DOTFILES_DIR/bin"

# Git config globale
backup "$HOME/.gitconfig"
ln -sfn "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"
echo "→ ~/.gitconfig -> $DOTFILES_DIR/git/gitconfig"

# Petit docteur de cohérence
echo
echo "🧪 Vérifications:"
for path in "$HOME/.zshrc" "$HOME/.aliases" "$HOME/bin" "$HOME/.gitconfig"; do
  if [ -L "$path" ]; then
    printf "✅ %s -> %s\n" "$path" "$(readlink -f "$path")"
  else
    printf "❌ %s n'est pas un lien (à vérifier)\n" "$path"
  fi
done

echo
echo "✅ Symlinks OK. Tu peux maintenant:  source ~/.zshrc"
