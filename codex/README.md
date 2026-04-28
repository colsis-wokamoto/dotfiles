# codex/

Codex CLI 用の設定サンプル。

## 構成

| パス | 役割 |
|---|---|
| `AGENTS.md` | エージェント運用ガイドライン本体（常時参照） |
| `config.sample.toml` | `~/.codex/config.toml` のサンプル |
| `principles/` | 開発原則の詳細（必要時のみ参照） |

Agent Skills はこのディレクトリではなく、リポジトリ直下の `skills/` に収容する。

## 配置例

`codex/` の内容を `~/.codex/` から参照できるように symlink する。

```bash
ln -s "$HOME/.dotfiles/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -s "$HOME/.dotfiles/codex/config.sample.toml" "$HOME/.codex/config.toml"
ln -s "$HOME/.dotfiles/codex/principles" "$HOME/.codex/principles"
```

Agent Skills を使う場合は、`skills/` を `~/.codex/skills` に symlink する。

```bash
ln -s "$HOME/.dotfiles/skills" "$HOME/.codex/skills"
```

## config.sample.toml を `~/.codex/config.toml` にマージする

Codex の設定は TOML のため、既存設定を上書きせずに必要項目だけ取り込む。
既存の `model`、`mcp_servers`、`projects`、`notify` などは個人環境依存のため、そのまま残す。

### 1. バックアップ

```bash
cp ~/.codex/config.toml ~/.codex/config.toml.bak
```

### 2. 差分確認

```bash
diff -u ~/.codex/config.toml codex/config.sample.toml
```

### 3. 取り込む項目

既存の `~/.codex/config.toml` に、必要に応じて以下を追加または更新する。

```toml
approval_policy = "untrusted"
sandbox_mode = "workspace-write"

[sandbox_workspace_write]
network_access = false

[profiles.default]
approval_policy = "untrusted"
sandbox_mode = "workspace-write"

[profiles.default.sandbox_workspace_write]
network_access = false

[profiles.full_auto]
approval_policy = "on-request"
sandbox_mode = "workspace-write"

[profiles.full_auto.sandbox_workspace_write]
network_access = true

[profiles.readonly_quiet]
approval_policy = "never"
sandbox_mode = "read-only"
```

既存に同じ table や key がある場合は、重複定義せず既存値を編集する。
`network_access = true` はネットワーク許可になるため、trusted profile や必要な project のみに限定する。

### 4. 構文確認

一時 `CODEX_HOME` にコピーして、Codex CLI が読み込めることを確認する。

```bash
mkdir -p /tmp/codex-config-check
cp ~/.codex/config.toml /tmp/codex-config-check/config.toml
CODEX_HOME=/tmp/codex-config-check codex debug models >/tmp/codex-config-check/models.json
```

エラーが出なければ TOML として読み込めている。

## config.sample.toml の位置づけ

`claude/settings.sample.json` のうち、Codex CLI の `config.toml` に対応できる項目だけを落とし込んでいる。

| Claude | Codex |
|---|---|
| `permissions.defaultMode: acceptEdits` | `sandbox_mode = "workspace-write"` |
| `permissions.allow` | `approval_policy = "untrusted"` による組み込み trusted command 扱い |
| `permissions.deny` | `config.toml` では直接表現せず、`AGENTS.md` の禁止事項として維持 |
| `sandbox.enabled` | `sandbox_mode` |
| `sandbox.allowUnsandboxedCommands: false` | `approval_policy` と sandbox の組み合わせで制御 |
| `sandbox.network.allowedDomains` | Codex はドメイン単位ではなく `network_access` の boolean |
| `sandbox.filesystem.allowRead` / `denyRead` | `workspace-write` / `read-only` の sandbox mode で制御 |

## 注意点

- `codex/` には Codex CLI の設定サンプルのみを置く
- Agent Skills は `skills/` に追加する
- 案件固有の可変情報は `AGENTS.md` ではなく、メモリやプロジェクト固有ファイルに分離する
