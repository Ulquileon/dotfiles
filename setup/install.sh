#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.files}"

echo "🛠️  Install: base tools + Oh My Zsh + symlinks"

# 1) Paquets de base
sudo apt update -y
sudo apt install -y zsh curl git

# 2) Installer Oh My Zsh si absent (mode silencieux)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "📦 Installation de Oh My Zsh…"
  RUNZSH=no KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
fi

# 3) Plugins Zsh utiles (clonés si absents)
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
[ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] || \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
[ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] || \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# 4) Symlinks (zshrc, aliases, bin, gitconfig…)
bash "$DOTFILES_DIR/setup/setup_symlinks.sh"

# 5) Défaut: s'assurer que ~/bin est dans le PATH (utile si shell ≠ zsh la 1ère fois)
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$HOME/bin"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.profile"
fi

echo "✅ Install terminé. Ouvre un nouveau terminal, ou lance:  source ~/.zshrc"
