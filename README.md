<div align="center">

# `D4RKGUNN3R // ZSH`

![Shell](https://img.shields.io/badge/Shell-Zsh-89E051?style=flat-square&logo=gnubash&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-Kali%20%7C%20Linux-557C94?style=flat-square&logo=linux&logoColor=white)
![Theme](https://img.shields.io/badge/Theme-Powerlevel10k-blueviolet?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)

A fast, clean, pentester-focused Zsh environment for Kali Linux — context-aware, one-command install, no bloat.

</div>

---

## // WHAT THIS IS

A reproducible Zsh setup built for offensive security work. Three install paths, same foundation:

- **Oh My Zsh** — plugin/theme framework
- **Powerlevel10k** — fast, heavily customizable prompt
- **Meslo Nerd Font** — required for P10k's icons/glyphs to render correctly
- **zsh-autosuggestions** + **zsh-syntax-highlighting** — inline command suggestions and live syntax coloring
- **zsh-defer** — lazy-loads plugins so shell startup stays fast even with several installed

## // THREE INSTALLERS

| | `d4rk.sh` (recommended) | `install.sh` | `clean-install.sh` |
|---|:---:|:---:|:---:|
| **Use case** | Unified — pick your mode with a flag | Full pentester loadout | Minimal, vanilla base |
| Oh My Zsh + Powerlevel10k + plugins | ✅ | ✅ | ✅ |
| Nerd Font install | ✅ | ✅ | ✅ |
| History tuning | ✅ | ✅ | ✅ |
| Colored man pages | ✅ (both modes) | ❌ | ✅ |
| Context-aware prompt colors (glitch preset) | ✅ `--full` only | ✅ | ❌ |
| Pentesting aliases (`ports`, `ip4`, `ip6`, etc.) | ✅ `--full` only | ✅ | ❌ |
| Idempotent (safe to re-run) | ✅ | ✅ | ✅ |
| Backs up existing `.zshrc` | ✅ | ✅ | ✅ |

**`d4rk.sh` is the current, maintained installer** — it merges everything from `install.sh` and `clean-install.sh` into one script with a `--full`/`--minimal` flag, so there's one script to maintain instead of two diverging ones. `install.sh` and `clean-install.sh` are kept for reference but `d4rk.sh` is what to run going forward.

---

## // THE GLITCH PRESET (`--full` mode)

The signature feature of the full setup: the prompt's color scheme changes based on *what kind of session you're actually in*, so a glance at the terminal tells you something about your context before you read a single line.

| Condition | Behavior |
|---|---|
| Normal session | Blue/purple default scheme |
| `$SSH_CONNECTION` or `$SSH_CLIENT` set | Prompt shifts to **red** — you're on a remote box, act accordingly |
| `tun0` interface present (VPN/HTB active) | Directory + VCS segments shift to **purple** |
| Running as `root` (`EUID == 0`) | User segment flips to **yellow-on-red** — hard to miss |

The intent: never lose track of whether you're local, tunneled into a VPN, SSH'd into a target, or running as root — without needing to check `whoami` or `ip a` every time.

---

## // INSTALLATION

```bash
git clone https://github.com/Dylans7j/d4rkgunn3r-zsh-Setup.git
cd d4rkgunn3r-zsh-Setup
chmod +x d4rk.sh

# Full setup (default) — aliases + context-aware theme:
./d4rk.sh

# Minimal setup — plugins + prompt + colored man pages, no extras:
./d4rk.sh --minimal
```

`d4rk.sh` will:
1. Install the Meslo Nerd Font (skipped if already present)
2. Install Oh My Zsh (skipped if already present)
3. Back up any existing `.zshrc` to `~/.zshrc.backup.<timestamp>`
4. Clone the plugin set + Powerlevel10k theme
5. Write the glitch preset (`--full` mode only)
6. Write a fresh `.zshrc`
7. Drop you straight into the new shell

**After first run**, configure the P10k prompt interactively:

```bash
p10k configure
```

Re-running `d4rk.sh` at any time is safe — every step checks whether its target already exists before doing anything.

---

## // ALIASES (`--full` mode)

| Alias | Command |
|---|---|
| `ll` | `ls -alF` |
| `la` | `ls -A` |
| `l` | `ls -CF` |
| `ports` | `ss -tulnp` |
| `ip4` | `ip -4 addr show` |
| `ip6` | `ip -6 addr show` |
| `update` | `sudo apt update && sudo apt upgrade -y` |
| `venv` | `source venv/bin/activate` |
| `cls` | `clear` |

---

## // UNINSTALL / REVERT

```bash
# Restore your previous config
mv ~/.zshrc.backup.<timestamp> ~/.zshrc

# Remove Oh My Zsh entirely (also removes plugins/themes installed under it)
uninstall_oh_my_zsh
```

Your original `.zshrc` is never overwritten in place — every install run backs up whatever was there first.

---

## // LEGACY SCRIPTS

`install.sh` and `clean-install.sh` are the original two scripts this project started with — `d4rk.sh` supersedes both and is functionally a superset of them (`--full` ≈ `install.sh`, `--minimal` ≈ `clean-install.sh` + colored man pages). They're kept in the repo for reference but aren't actively maintained going forward.

---

## // WHY THIS EXISTS

Rebuilding the same shell setup by hand after every fresh Kali VM, snapshot revert, or HTB reset gets old fast. This turns that into one command — and the context-aware prompt means less time typing `whoami` / `ip a` to re-orient after a shell reset, tunnel drop, or privilege change mid-engagement.

<div align="center">

`BUILD // ATTACK // DETECT // DOCUMENT`

</div>
