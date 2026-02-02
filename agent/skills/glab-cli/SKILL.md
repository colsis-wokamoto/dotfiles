---
name: glab-cli
description: GitLab CLI (glab) を使った操作（認証、設定、Issue/MR、CI/CD、Release、API 呼び出し）を支援するスキル。glab コマンドの使い方や、GitLab の作業をターミナルから自動化したいときに使用する。
---

# Glab CLI

## Overview

GitLab CLI（glab）で GitLab 操作を実行するための手順・コマンド選択を支援する。Issue/MR/CI/CD/Release/API を中心に、安全に作業できる最短経路を示す。

## Quick Start

1. 作業対象のリポジトリにいるか、`-R/--repo` で対象を指定する。
2. `glab auth login` で認証（または `GITLAB_TOKEN` などの環境変数を設定）。
3. タスク別のコマンドを実行する（詳細は `references/cli.md`）。

## Task Guide

### Authentication

- `glab auth login` で対話的に認証する。トークンを使う場合は `--stdin` を使う。
- トークンが必要な処理では、まず環境変数 `GITLAB_API_TOKEN` があればそれを優先して使う（なければ `GITLAB_TOKEN` を利用）。
- 最低限のトークンスコープは `api` と `write_repository`。
- 設定と認証情報は `~/.config/glab-cli/config.yml` に保存される。
- Self-Managed/Dedicated は `--hostname` 指定や `host` 設定を行う。

### Configuration

- `glab config` で設定を管理する。`host` の既定は `https://gitlab.com`。
- `BROWSER`, `EDITOR`, `GITLAB_HOST`, `GITLAB_TOKEN` などの環境変数で上書きできる。

### Issues

- 代表例: `glab issue list`, `glab issue view`, `glab issue create`。
- `-R/--repo` を使って対象リポジトリを明示できる。

### Merge Requests

- 代表例: `glab mr create`, `glab mr merge`, `glab mr note`。
- `glab mr create` は `--fill`, `--draft`, `--web`, `--related-issue` などを使い分ける。

### CI/CD

- `glab ci` はパイプラインとジョブを扱う。`pipeline`/`pipe` の別名がある。

### Releases

- `glab release create <tag>` でリリース作成/更新。
- タグが存在しない場合は既定ブランチの最新から作成される。必要なら `--ref` を使う。

### API

- `glab api <endpoint>` で REST/GraphQL API を呼び出す（`graphql` 指定で GraphQL）。
- Git リポジトリ外では `--hostname` で GitLab ホストを指定する。
- `:id`, `:group` などのプレースホルダーが自動置換される。

## References

- 詳細なコマンド一覧、環境変数、使用例は `references/cli.md` を参照する。
