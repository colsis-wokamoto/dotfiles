# claude/

Claude Code 用の運用ガイドラインと設定サンプル。

## 構成

| パス | 役割 |
|---|---|
| `CLAUDE.md` | エージェント運用ガイドライン本体（常時参照） |
| `principles/` | 開発原則の詳細（必要時のみ参照） |
| `settings.sample.json` | `~/.claude/settings.json` のサンプル |

## settings.sample.json を `~/.claude/settings.json` にマージする

`jq -s '.[0] * .[1]'` でディープマージできるが、配列は後の値で上書きされる。
`permissions.deny` 等は **union + 重複排除** したいため、以下の手順で行う。

### 1. バックアップ

```bash
cp ~/.claude/settings.json ~/.claude/settings.json.bak
```

### 2. マージ結果を tmp に書き出し

```bash
jq -s '
  (.[0].permissions.deny // [])                 as $deny0
  | (.[1].permissions.deny // [])               as $deny1
  | (.[0].permissions.allow // [])              as $allow0
  | (.[1].permissions.allow // [])              as $allow1
  | (.[0].sandbox.network.allowedDomains // []) as $dom0
  | (.[1].sandbox.network.allowedDomains // []) as $dom1
  | (.[0] * .[1])
  | .permissions.deny               = ($deny0 + $deny1 | unique)
  | .permissions.allow              = ($allow0 + $allow1 | unique)
  | .sandbox.network.allowedDomains = ($dom0 + $dom1 | unique)
' ~/.claude/settings.json claude/settings.sample.json > /tmp/claude-settings.json
```

### 3. 差分確認

```bash
diff <(jq -S . ~/.claude/settings.json) <(jq -S . /tmp/claude-settings.json)
```

### 4. 反映

```bash
mv /tmp/claude-settings.json ~/.claude/settings.json
```

## 注意点

- `>` で `~/.claude/settings.json` に直接リダイレクトすると **空になる**（読む前に truncate されるため）。必ず tmp 経由で `mv` する
- `*` 演算子は**右側優先**のディープマージ。`defaultMode` 等スカラー値は sample 側で上書きされる。既存値を残したい場合は `.[1] * .[0]` と順序を入れ替える
- `unique` は配列をソート＋重複排除する。順序を保ちたい場合は次のように書く

  ```jq
  ($deny0 + $deny1 | reduce .[] as $x ([]; if any(. == $x) then . else . + [$x] end))
  ```
