# .dotfiles

## Overview
- Personal configuration files and tooling definitions.
- Zsh shell configuration and tmux configuration live at the repo root.
- Homebrew Brewfile tracks taps, CLI tools, casks, mas apps, and VS Code extensions.
- AI Agent CLI skill definitions are stored under `agent/skills`.

## Tech Stack
- Zsh (`.zshrc`) with aliases, PATH/env setup, direnv hook, and optional zsh-autosuggestions / zsh-syntax-highlighting.
- tmux (`.tmux.conf`) based on gpakosz/.tmux.
- Homebrew Bundle Brewfile format (taps, brews, casks, mas, vscode).
- AI Agent CLI skills (SKILL.md definitions under `agent/skills`).

## Key Paths
- `.zshrc` shell configuration
- `.tmux.conf` tmux base configuration (do not edit directly)
- `Brewfile` Homebrew bundle definition
- `agent/skills` AI Agent skills

## Install
```
$ ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
$ ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
$ ln -s $HOME/.dotfiles/Brewfile $HOME/Brewfile
$ brew bundle
$ ln -s $HOME/dotfiles/agent/skills $HOME/.cursor/skills
$ ln -s $HOME/dotfiles/agent/skills $HOME/.gemini/skills
$ ln -s $HOME/dotfiles/agent/skills $HOME/.codex/skills
$ ln -s $HOME/dotfiles/agent/skills $HOME/.claude/skills
```