#!/usr/bin/env bash
set -euo pipefail

# ── Params override possibles via env ───────────────────────────────────────────
GIT_HOST_ALIAS="${GIT_HOST_ALIAS:-github.com-personal}"
GIT_USER="${GIT_USER:-Ulquileon}"
DOTFILES_REPO="${DOTFILES_REPO:-dotfiles}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.files}"

echo "🚀 Bootstrap: $GIT_HOST_ALIAS:$GIT_USER/$DOTFILES_REPO → $DOTFILES_DIR"

# 1) Git minimal si absent
if ! command -v git >/dev/null 2>&1; then
  echo "📦 Installation de git…"
  sudo apt update -y && sudo apt install -y git
fi

# 2) Clonage des dotfiles s'ils n'existent pas déjà
if [ ! -d "$DOTFILES_DIR/.git" ]; then
  echo "🔐 Test SSH ($GIT_HOST_ALIAS)…"
  # n'échoue pas le script si l'agent n'a pas de clé, on tente quand même
  ssh -T "git@$GIT_HOST_ALIAS" || true

  echo "📥 Clone du repo…"
  git clone "git@$GIT_HOST_ALIAS:$GIT_USER/$DOTFILES_REPO.git" "$DOTFILES_DIR"
else
  echo "✅ Repo déjà présent: $DOTFILES_DIR"
fi

# 3) Lancer l'install complète
exec bash "$DOTFILES_DIR/setup/install.sh"
