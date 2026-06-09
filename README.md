# Config Files

A portable set of terminal configuration files for Zsh, tmux, and Powerlevel10k, along with an automated install script. These configs are built around a keyboard-driven workflow using Neovim-style navigation, a lean Powerlevel10k prompt with the Tokyo Night Moon colour scheme in tmux, and quality-of-life aliases that swap standard tools for modern alternatives (`bat`, `nvim`). The setup targets both macOS (Homebrew, Apple Silicon and Intel) and Debian-based Linux, and the install script handles dependency installation, config backups, and file deployment automatically.

---

## Files

| File | Description |
|------|-------------|
| `.zshrc` | Zsh shell config — theme, aliases, PATH, Powerlevel10k init |
| `.tmux.conf` | tmux config — keybinds, popup windows, Tokyo Night theme |
| `.p10k.zsh` | Powerlevel10k prompt config (lean style, 2-line, Nerd Font) |
| `install.sh` | Automated installer for dependencies and config files |

---

## Installation

```bash
git clone <repo-url> ~/config-files
cd ~/config-files
bash install.sh
```

The script installs `zsh`, `tmux`, `fzf`, `bat`, `ripgrep`, `lazygit`, and `powerlevel10k` via `apt` (Linux) or Homebrew (macOS). Existing config files are backed up to `~/config-backup/` before being replaced.

---

## Zsh Aliases

| Alias | Command | Notes |
|-------|---------|-------|
| `ls` | `ls --color=auto` | Coloured output |
| `cat` | `bat` / `batcat` | `bat` on macOS, `batcat` on Linux |
| `v` | `nvim` | Short Neovim launcher |

---

## tmux Keybinds

The prefix key is `Ctrl+s` (replaces the default `Ctrl+b`).

### Session & Window Management

| Keybind | Action |
|---------|--------|
| `Prefix + Ctrl+n` | Create a new named session (prompts for name) |
| `Prefix + Ctrl+j` | Switch to an existing session via fzf picker |
| `Prefix + r` | Reload tmux config |

### Pane Management

| Keybind | Action |
|---------|--------|
| `Prefix + \|` | Split pane horizontally (opens in current directory) |
| `Prefix + -` | Split pane vertically (opens in current directory) |
| `Ctrl+h` | Move to pane left (vim-tmux-navigator aware) |
| `Ctrl+j` | Move to pane below (vim-tmux-navigator aware) |
| `Ctrl+k` | Move to pane above (vim-tmux-navigator aware) |
| `Ctrl+l` | Move to pane right (vim-tmux-navigator aware) |

> The `Ctrl+h/j/k/l` navigation works transparently inside Neovim splits as well, via [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator).

### Popup Windows

| Keybind | Action |
|---------|--------|
| `Prefix + Ctrl+y` | Open lazygit in a floating popup (80% × 80%) |
| `Prefix + t` | Open a floating terminal (75% × 75%) |
| `Prefix + z` | Open `~/.zshrc` in Neovim in a floating popup |

### Other

| Keybind | Action |
|---------|--------|
| `Ctrl+s Ctrl+s` | Send a literal `Ctrl+s` to the active application |
