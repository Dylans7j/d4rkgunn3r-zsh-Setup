#!/usr/bin/env bash
# d4rkgunn3r Zsh Installer — unified
# Supersedes install.sh (--full) and clean-install.sh (--minimal).
# Idempotent: every step checks whether its target already exists first.

set -e

MODE="full"
for arg in "$@"; do
  case "$arg" in
    --minimal) MODE="minimal" ;;
    --full)    MODE="full" ;;
    *) echo "[!] Unknown flag: $arg (use --full or --minimal)"; exit 1 ;;
  esac
done

ZSH="$HOME/.oh-my-zsh"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup.$(date +%s)"
CONFIG_DIR="$HOME/.config/d4rkgunn3r"
FONT_DIR="$HOME/.local/share/fonts"
PLUGDIR="${ZSH_CUSTOM:-$ZSH/custom}/plugins"
THEME_DIR="${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k"

echo "[*] Starting d4rkgunn3r Zsh setup (mode: $MODE)..."

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
else
  echo "[*] Nerd Font already present, skipping."
fi

# ---------------------------------------------------------
# 2. Oh My Zsh
# ---------------------------------------------------------
if [ ! -d "$ZSH" ]; then
  echo "[*] Installing Oh My Zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
else
  echo "[*] Oh My Zsh already installed, skipping."
fi

# ---------------------------------------------------------
# 3. Backup existing .zshrc
# ---------------------------------------------------------
if [ -f "$ZSHRC" ]; then
  echo "[*] Backing up existing .zshrc -> $BACKUP"
  mv "$ZSHRC" "$BACKUP"
fi

# ---------------------------------------------------------
# 4. Plugins
# ---------------------------------------------------------
echo "[*] Installing plugins..."
[ ! -d "$PLUGDIR/zsh-autosuggestions" ] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGDIR/zsh-autosuggestions"
[ ! -d "$PLUGDIR/zsh-syntax-highlighting" ] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGDIR/zsh-syntax-highlighting"
[ ! -d "$PLUGDIR/zsh-defer" ] && \
  git clone https://github.com/romkatv/zsh-defer.git "$PLUGDIR/zsh-defer"

# ---------------------------------------------------------
# 5. Powerlevel10k
# ---------------------------------------------------------
if [ ! -d "$THEME_DIR" ]; then
  echo "[*] Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
else
  echo "[*] Powerlevel10k already installed, skipping."
fi

# ---------------------------------------------------------
# 6. Glitch preset (--full only)
# ---------------------------------------------------------
if [ "$MODE" = "full" ]; then
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
fi

# ---------------------------------------------------------
# 7. .zshrc
# ---------------------------------------------------------
echo "[*] Writing new .zshrc..."

cat << EOF > "$ZSHRC"
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-defer)

source \$ZSH/oh-my-zsh.sh

# History
export HISTSIZE=200000
export SAVEHIST=200000
setopt SHARE_HISTORY EXTENDED_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_DUPS

# Colored man pages
export LESS_TERMCAP_mb=\$'\E[1;31m'
export LESS_TERMCAP_md=\$'\E[1;31m'
export LESS_TERMCAP_me=\$'\E[0m'
export LESS_TERMCAP_se=\$'\E[0m'
export LESS_TERMCAP_so=\$'\E[1;44;33m'
export LESS_TERMCAP_ue=\$'\E[0m'
export LESS_TERMCAP_us=\$'\E[1;32m'
EOF

if [ "$MODE" = "full" ]; then
  cat << 'EOF' >> "$ZSHRC"

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
EOF
fi

cat << 'EOF' >> "$ZSHRC"

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
EOF

echo "[*] Done. Restart terminal and run: p10k configure"
exec zsh -l
