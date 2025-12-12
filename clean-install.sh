#!/usr/bin/env bash
# D4rkGunn3r Pro Zsh Setup (no set colors)

set -e

ZSH="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup.$(date +%s)"

echo "[*] Starting D4rkGunn3r Zsh setup..."

### ---------------------------------------------------------
### 1. Install Nerd Font
### ---------------------------------------------------------
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"

if [ ! -f "$FONT_DIR/MesloLGS NF Regular.ttf" ]; then
    echo "[*] Installing Meslo Nerd Font..."
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "$FONT_DIR/MesloLGS NF Regular.ttf"
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "$FONT_DIR/MesloLGS NF Bold.ttf"
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "$FONT_DIR/MesloLGS NF Italic.ttf"
    wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "$FONT_DIR/MesloLGS NF Bold Italic.ttf"
    fc-cache -fv >/dev/null
fi

### ---------------------------------------------------------
### 2. Install Oh My Zsh
### ---------------------------------------------------------
if [ ! -d "$ZSH" ]; then
    echo "[*] Installing Oh My Zsh..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
else
    echo "[*] Oh My Zsh already installed."
fi

### ---------------------------------------------------------
### 3. Backup old zshrc
### ---------------------------------------------------------
if [ -f "$ZSHRC" ]; then
    echo "[*] Backing up existing .zshrc -> $BACKUP"
    mv "$ZSHRC" "$BACKUP"
fi

### ---------------------------------------------------------
### 4. Install Plugins
### ---------------------------------------------------------
PLUGDIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins"

echo "[*] Installing plugins..."

[ ! -d "$PLUGDIR/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGDIR/zsh-autosuggestions"

[ ! -d "$PLUGDIR/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGDIR/zsh-syntax-highlighting"

[ ! -d "$PLUGDIR/zsh-defer" ] && \
    git clone https://github.com/romkatv/zsh-defer.git "$PLUGDIR/zsh-defer"


### ---------------------------------------------------------
### 5. Install Powerlevel10k theme
### ---------------------------------------------------------
THEME_DIR="${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k"
if [ ! -d "$THEME_DIR" ]; then
    echo "[*] Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
fi


### ---------------------------------------------------------
### 6. Build new .zshrc (NO BANNER)
### ---------------------------------------------------------
echo "[*] Writing new .zshrc..."

cat << 'EOF' > "$ZSHRC"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-defer
)

source $ZSH/oh-my-zsh.sh

# ----------------------------
# History Settings
# ----------------------------
export HISTSIZE=200000
export SAVEHIST=200000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt SHARE_HISTORY

# ----------------------------
# Aliases
# ----------------------------
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ports="ss -tulnp"
alias ip4="ip -4 addr show"
alias ip6='ip -6 addr show'
alias venv="source venv/bin/activate"
alias cls="clear"
alias update="sudo apt update && sudo apt upgrade -y"

# Colored man pages
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[1;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'

# Powerlevel10k config auto-load
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

EOF

echo "[*] Done!"
echo "[*] Launching new Zsh..."
exec zsh -l
