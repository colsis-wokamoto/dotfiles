# gemini/

Gemini CLI 用の運用ガイドラインと設定サンプル。

## 構成

| パス | 役割 |
|---|---|
| `GEMINI.md` | エージェント運用ガイドライン本体（常時参照） |
| `principles/` | 開発原則の詳細（必要時のみ参照） |
| `settings.sample.json` | `~/.gemini/settings.json` のサンプル |
| `policies/sensitive-files.sample.toml` | `~/.gemini/policies/sensitive-files.toml` のサンプル（機密ファイル / 破壊的操作の deny ルール） |

Agent Skills はこのディレクトリではなく、リポジトリ直下の `skills/` に収容する。

## 配置例

`gemini/` の内容を `~/.gemini/` から参照できるように symlink する。
`settings.json` は環境固有の項目（API キー等）を含む可能性があるため、symlink ではなく後述のマージ手順で取り込む。

```bash
ln -s "$HOME/.dotfiles/gemini/GEMINI.md"   "$HOME/.gemini/GEMINI.md"
ln -s "$HOME/.dotfiles/gemini/principles"  "$HOME/.gemini/principles"
```

policy ファイルは内容を編集する余地があるため、symlink ではなくコピーで配置する。

```bash
mkdir -p "$HOME/.gemini/policies"
cp "$HOME/.dotfiles/gemini/policies/sensitive-files.sample.toml" \
   "$HOME/.gemini/policies/sensitive-files.toml"
```

## settings.sample.json を `~/.gemini/settings.json` にマージする

`jq -s '.[0] * .[1]'` でディープマージできるが、配列は後の値で上書きされる。
`tools.allowed` / `mcp.allowed` / `context.fileName` / `advanced.excludedEnvVars` は
**union + 重複排除** したいため、以下の手順で行う。

### 1. バックアップ

```bash
cp ~/.gemini/settings.json ~/.gemini/settings.json.bak
```

### 2. マージ結果を tmp に書き出し

```bash
jq -s '
  (.[0].tools.allowed // [])             as $tools0
  | (.[1].tools.allowed // [])           as $tools1
  | (.[0].mcp.allowed // [])             as $mcp0
  | (.[1].mcp.allowed // [])             as $mcp1
  | (.[0].context.fileName // [])        as $ctx0
  | (.[1].context.fileName // [])        as $ctx1
  | (.[0].advanced.excludedEnvVars // []) as $env0
  | (.[1].advanced.excludedEnvVars // []) as $env1
  | (.[0] * .[1])
  | .tools.allowed             = ($tools0 + $tools1 | unique)
  | .mcp.allowed               = ($mcp0   + $mcp1   | unique)
  | .context.fileName          = ($ctx0   + $ctx1   | unique)
  | .advanced.excludedEnvVars  = ($env0   + $env1   | unique)
' ~/.gemini/settings.json gemini/settings.sample.json > /tmp/gemini-settings.json
```

### 3. 差分確認

```bash
diff <(jq -S . ~/.gemini/settings.json) <(jq -S . /tmp/gemini-settings.json)
```

### 4. 反映

```bash
mv /tmp/gemini-settings.json ~/.gemini/settings.json
```

## settings.sample.json の位置づけ

`claude/settings.sample.json` のうち、Gemini CLI の `settings.json` に対応できる項目を落とし込んでいる。

| Claude | Gemini |
|---|---|
| `permissions.defaultMode` | `general.defaultApprovalMode` |
| `permissions.allow` | `tools.allowed` / `mcp.allowed` |
| `permissions.deny` | `policyPaths` 経由で `policies/*.toml` に deny ルールを記述（`policies/sensitive-files.sample.toml` 参照）+ `tools.confirmationRequired` で書き込み / 実行系を承認制 + `GEMINI.md` の禁止事項で多重防御 |
| `sandbox.enabled` | `tools.sandbox` |
| `sandbox.network.allowedDomains` | Gemini CLI ではドメイン単位の制御は持たない |
| `statusLine` | Gemini CLI には対応する仕組みなし |
| `telemetry` 系 | `telemetry.enabled` / `telemetry.logPrompts` / `privacy.usageStatisticsEnabled` |

`advanced.excludedEnvVars` は、Gemini CLI に渡す環境変数からシークレット（API キー、AWS / GitHub トークン等）を除外する設定。
プロジェクト側 `.env` の意図しない流入を防ぐ目的で同梱している。

## 注意点

- `>` で `~/.gemini/settings.json` に直接リダイレクトすると **空になる**（読む前に truncate されるため）。必ず tmp 経由で `mv` する
- `*` 演算子は **右側優先** のディープマージ。`defaultApprovalMode` 等スカラー値は sample 側で上書きされる。既存値を残したい場合は `.[1] * .[0]` と順序を入れ替える
- `unique` は配列をソート＋重複排除する。順序を保ちたい場合は次のように書く

  ```jq
  ($tools0 + $tools1 | reduce .[] as $x ([]; if any(. == $x) then . else . + [$x] end))
  ```

- 案件固有の可変情報は本ファイル（`gemini/GEMINI.md`）には書かず、プロジェクト直下の `GEMINI.md`（`write_file` / `replace`）または `~/.gemini/GEMINI.md` の `## Gemini Added Memories`（`save_memory`）に分離する
