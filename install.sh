#!/usr/bin/env bash
# d4rkgunn3r Zsh Installer
# Kali-focused, fast, reusable, pentester-friendly

set -e

ZSH="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup.$(date +%s)"
CONFIG_DIR="$HOME/.config/d4rkgunn3r"
FONT_DIR="$HOME/.local/share/fonts"

echo "[*] Starting d4rkgunn3r Zsh setup..."

# ---------------------------------------------------------
# 1. Nerd Font (Meslo)
# ---------------------------------------------------------
mkdir -p "$FONT_DIR"

if ! ls "$FONT_DIR"/MesloLGS* &>/dev/null; then
  echo "[*] Installing Meslo Nerd Font..."
  wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -O "$FONT_DIR/MesloLGS NF Regular.ttf"
  wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -O "$FONT_DIR/MesloLGS NF Bold.ttf"
  wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -O "$FONT_DIR/MesloLGS NF Italic.ttf"
  wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -O "$FONT_DIR/MesloLGS NF Bold Italic.ttf"
  fc-cache -fv >/dev/null
fi

# ---------------------------------------------------------
# 2. Oh My Zsh
# ---------------------------------------------------------
if [ ! -d "$ZSH" ]; then
  echo "[*] Installing Oh My Zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
fi

# ---------------------------------------------------------
# 3. Backup existing zshrc
# ---------------------------------------------------------
if [ -f "$ZSHRC" ]; then
  echo "[*] Backing up existing .zshrc -> $BACKUP"
  mv "$ZSHRC" "$BACKUP"
fi

# ---------------------------------------------------------
# 4. Plugins
# ---------------------------------------------------------
PLUGDIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins"

git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGDIR/zsh-autosuggestions" 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGDIR/zsh-syntax-highlighting" 2>/dev/null || true
git clone https://github.com/romkatv/zsh-defer "$PLUGDIR/zsh-defer" 2>/dev/null || true

# ---------------------------------------------------------
# 5. Powerlevel10k
# ---------------------------------------------------------
THEME_DIR="${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR" 2>/dev/null || true

# ---------------------------------------------------------
# 6. Glitch Preset
# ---------------------------------------------------------
mkdir -p "$CONFIG_DIR"

cat << 'EOF' > "$CONFIG_DIR/p10k-glitch.zsh"
# d4rkgunn3r – Blue / Purple Glitch Preset

typeset -g POWERLEVEL9K_BACKGROUND=234

typeset -g POWERLEVEL9K_USER_FOREGROUND=45
typeset -g POWERLEVEL9K_HOST_FOREGROUND=81
typeset -g POWERLEVEL9K_DIR_FOREGROUND=33
typeset -g POWERLEVEL9K_DIR_BACKGROUND=236

typeset -g POWERLEVEL9K_VCS_FOREGROUND=141
typeset -g POWERLEVEL9K_VCS_BACKGROUND=235
typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=214
typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=196

typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=46
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=196
typeset -g POWERLEVEL9K_STATUS_ERROR_BACKGROUND=234

typeset -g POWERLEVEL9K_TIME_FOREGROUND=135
typeset -g POWERLEVEL9K_TIME_BACKGROUND=235

# SSH danger mode
if [[ -n "$SSH_CONNECTION" || -n "$SSH_CLIENT" ]]; then
  typeset -g POWERLEVEL9K_USER_FOREGROUND=196
  typeset -g POWERLEVEL9K_HOST_FOREGROUND=196
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=203
  typeset -g POWERLEVEL9K_BACKGROUND=52
fi

# VPN (tun0) mode
if ip link show tun0 &>/dev/null; then
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=135
  typeset -g POWERLEVEL9K_VCS_FOREGROUND=135
fi

# Root warning
if [[ $EUID -eq 0 ]]; then
  typeset -g POWERLEVEL9K_USER_FOREGROUND=226
  typeset -g POWERLEVEL9K_USER_BACKGROUND=88
fi
EOF

# ---------------------------------------------------------
# 7. .zshrc
# ---------------------------------------------------------
cat << 'EOF' > "$ZSHRC"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-defer)

source $ZSH/oh-my-zsh.sh

# History
export HISTSIZE=200000
export SAVEHIST=200000
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ports='ss -tulnp'
alias ip4='ip -4 addr show'
alias ip6='ip -6 addr show'
alias update='sudo apt update && sudo apt upgrade -y'
alias venv='source venv/bin/activate'
alias cls='clear'

# Load glitch preset
[[ -f ~/.config/d4rkgunn3r/p10k-glitch.zsh ]] && \
  source ~/.config/d4rkgunn3r/p10k-glitch.zsh

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

echo "[*] Done. Restart terminal and run: p10k configure"
exec zsh -l
