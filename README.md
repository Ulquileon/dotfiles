# 🧩 Ulquileon’s Dotfiles

Mon environnement de travail complet sous **WSL 2 / Ubuntu 24.04**.  
Ce dépôt contient toute la configuration nécessaire pour reconstruire mon setup personnel :

- 🐚 Shell : **Zsh + Oh My Zsh**
- ⚙️ Config : alias, prompt, Git multi-profils
- 🧰 Scripts : utilitaires custom (`jdev`, `gclone`, etc.)
- 🚀 Installation : entièrement automatisée via 3 scripts (`bootstrap.sh`, `install.sh`, `setup_symlinks.sh`)

---

## 📦 Structure du dépôt

```bash
.files/
├── bin/                     # Scripts exécutables (dans le PATH)
│   ├── jdev
│   ├── gclone
│   └── dotfiles-doctor
│
├── git/                     # Config Git multi-comptes
│   ├── gitconfig
│   ├── gitconfig-personal
│   ├── gitconfig-school
│   └── gitignore_global
│
├── zsh/                     # Config du shell
│   ├── zshrc
│   └── aliases
│
├── setup/                   # Scripts d’installation / restauration
│   ├── bootstrap.sh         # Installe Git + clone les dotfiles + lance install.sh
│   ├── install.sh           # Installe Zsh + Oh My Zsh + dépendances
│   └── setup_symlinks.sh    # Crée tous les liens symboliques (zshrc, aliases, bin, etc.)
│
└── README.md
```

## ⚙️ Installation rapide (nouvelle machine)

### 🧩 1. Cloner le dépôt

⚠️ Nécessite une clé SSH configurée et ton alias `github.com-personal` dans `~/.ssh/config`.

```bash
git clone git@github.com-personal:Ulquileon/dotfiles.git ~/.files
```

---

### ⚙️ 2. Lancer l’installation

```bash
bash ~/.files/setup/install.sh
```

Le script :
- installe **Zsh**, **Git**, **Oh My Zsh**
- crée tous les **liens symboliques**
- ajoute les **plugins Zsh** nécessaires
- active ton **environnement complet**

---

### 🚀 3. Redémarre ton shell

```bash
exec zsh
```

---

## 🛠️ Réinstallation complète (mode “machine vierge”)

> Sur un Ubuntu/WSL tout neuf (sans même Git) :

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ulquileon/dotfiles/main/setup/bootstrap.sh)"
```

Ce script :
- installe **Git** si absent
- clone ton dépôt `.files`
- lance automatiquement `install.sh`
- configure tout ton environnement
