# .dotfiles

## Overview

This repository contains personal configuration files plus operating guidelines, configuration samples, and Agent Skills for AI Agent CLIs.

- Root-level files contain Zsh, tmux, and Homebrew configuration.
- `claude/` contains Claude Code configuration samples.
- `codex/` contains Codex CLI configuration samples.
- Agent Skills live under the root-level `skills/` directory.
- Shared development principles for agents live under `principles/`.
- The MCP configuration sample lives at the root-level `mcp.sample.json`.

## Structure

| Path | Purpose |
|---|---|
| `.zshrc` | Zsh configuration |
| `.tmux.conf` | tmux configuration |
| `Brewfile` | Homebrew Bundle definition |
| `mcp.sample.json` | MCP configuration sample |
| `claude/` | Claude Code `CLAUDE.md` and `settings.sample.json` |
| `codex/` | Codex CLI `AGENTS.md` and `config.sample.toml` |
| `skills/` | Agent Skills |
| `principles/` | Shared development principles for agents |
| `README.md` | Japanese README |

## Setup Example

```bash
ln -s "$HOME/.dotfiles/.zshrc" "$HOME/.zshrc"
ln -s "$HOME/.dotfiles/.tmux.conf" "$HOME/.tmux.conf"
ln -s "$HOME/.dotfiles/Brewfile" "$HOME/Brewfile"
brew bundle --file "$HOME/.dotfiles/Brewfile"
```

### Claude Code

```bash
ln -s "$HOME/.dotfiles/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -s "$HOME/.dotfiles/claude/principles" "$HOME/.claude/principles"
ln -s "$HOME/.dotfiles/skills" "$HOME/.claude/skills"
```

See [claude/README.md](claude/README.md) for how to merge `claude/settings.sample.json`.

### Codex CLI

```bash
ln -s "$HOME/.dotfiles/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -s "$HOME/.dotfiles/codex/principles" "$HOME/.codex/principles"
ln -s "$HOME/.dotfiles/skills" "$HOME/.codex/skills"
```

See [codex/README.md](codex/README.md) for how to merge `codex/config.sample.toml`.
