# .dotfiles

## 概要

個人用の設定ファイルと、AI Agent CLI 向けの運用ガイドライン・設定サンプル・Agent Skills をまとめたリポジトリです。

- ルート直下に Zsh、tmux、Homebrew の基本設定を置いています。
- `claude/` に Claude Code 用の設定サンプルを置いています。
- `codex/` に Codex CLI 用の設定サンプルを置いています。
- Agent Skills はリポジトリ直下の `skills/` に収容しています。
- 複数のエージェントで共有する開発原則は `principles/` に分離しています。
- MCP 設定サンプルはルート直下の `mcp.sample.json` に置いています。

## 構成

| パス | 役割 |
|---|---|
| `.zshrc` | Zsh 設定 |
| `.tmux.conf` | tmux 設定 |
| `Brewfile` | Homebrew Bundle 定義 |
| `mcp.sample.json` | MCP 設定サンプル |
| `claude/` | Claude Code 用の `CLAUDE.md` と `settings.sample.json` |
| `codex/` | Codex CLI 用の `AGENTS.md` と `config.sample.toml` |
| `skills/` | Agent Skills |
| `principles/` | エージェント共通の開発原則 |
| `README_en.md` | 英語版 README |

## セットアップ例

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

`claude/settings.sample.json` の取り込み手順は [claude/README.md](claude/README.md) を参照してください。

### Codex CLI

```bash
ln -s "$HOME/.dotfiles/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -s "$HOME/.dotfiles/codex/principles" "$HOME/.codex/principles"
ln -s "$HOME/.dotfiles/skills" "$HOME/.codex/skills"
```

`codex/config.sample.toml` の取り込み手順は [codex/README.md](codex/README.md) を参照してください。
