# .dotfiles

## 概要
- 個人用の設定ファイルとツール定義をまとめたリポジトリです。
- ルート直下に Zsh 設定と tmux 設定を置いています。
- Homebrew の Brewfile で tap / CLI / cask / mas / VS Code 拡張を管理しています。
- AI Agent CLI のスキル定義は `agent/skills` にあります。

## 技術スタック
- Zsh（`.zshrc`）: エイリアス、PATH/環境変数、direnv フック、zsh-autosuggestions / zsh-syntax-highlighting の読み込み（brew がある場合）。
- tmux（`.tmux.conf`）: gpakosz/.tmux ベースで `.tmux.conf.local` の上書きを前提。
- Homebrew Bundle の Brewfile 形式（tap / brew / cask / mas / vscode）。
- AI Agent CLI スキル（`agent/skills` 配下の SKILL.md）。

## 主要パス
- `.zshrc` シェル設定
- `.tmux.conf` tmux のベース設定（直接編集しない）
- `Brewfile` Homebrew のバンドル定義
- `agent/skills` Codex スキル

## Install
```
$ ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
$ ln -s $HOME/.dotfiles/.tmux.conf $HOME/.tmux.conf
$ ln -s $HOME/.dotfiles/Brewfile $HOME/Brewfile
$ ln -s $HOME/.dotfiles/agent/skills $HOME/.cursor/skills
$ ln -s $HOME/.dotfiles/agent/skills $HOME/.gemini/skills
$ ln -s $HOME/.dotfiles/agent/skills $HOME/.codex/skills
```