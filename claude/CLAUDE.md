# CLAUDE.md — エージェント運用ガイドライン

> このファイルは常時参照される。**1,500 字以内**を目安に静的ルールのみ記述する。
> 案件固有の可変情報は `memory/project_*.md` に切り出すこと。

---

## 0. 適用範囲
- 配置: `~/.claude/CLAUDE.md`（ユーザーグローバル、全プロジェクト共通）
- 対象: ホスト上で起動するすべての Claude Code セッション
- 優先順位: ユーザー直接指示 > プロジェクト直下 `CLAUDE.md` > 本ファイル > Skills / プラグイン既定値

---

## 1. ハーネスパラダイム（ツール使用ルール）
### 必ず使う
- ファイル読み: `Read` / 検索: `Grep` / 一覧: `Glob`（`cat` / `grep` / `find` を Bash で呼ばない）
- 計画管理: `TaskCreate`、長時間処理: `run_in_background`

### 使ってよい（条件付き）
- `Bash`: シェル固有処理のみ。読み取り・検索・編集には使用禁止
- `Agent`: 3 クエリ以上の調査、または独立並列タスク

### 使用禁止
- `git push --force` / `git reset --hard` / `rm -rf` をユーザー明示承認なしで実行しない
- `--no-verify` / `--no-gpg-sign` でフックを回避しない
- 以下の機密ファイル/ディレクトリの読み取り・編集・コミットを行わない
  - `.env` / `credentials*`
  - `~/.aws/*` / `~/.ssh/*`
  - `*.pem` / `*.key`

---

## 2. ツールコントラクト（Skills / Slash Commands）
### カスタム Skill を追加するとき
すべての Skill frontmatter に以下を記述:
- `description`: 起動条件を「いつ使うか／使わないか」で書く
- `inputs`: 期待する引数と型
- `outputs`: 返却物の形式
- `side_effects`: 書き込み先・外部通信の有無
- `permissions`: 必要な `allowed-tools`

### Slash Command
- `allowed-tools` を必須記載（最小権限）
- `description` 1 行で起動条件を明記

---

## 3. クエリエンジン（失敗時のループ制御）
- 同一コマンドの**連続失敗 2 回**で停止し、ユーザー報告
- 失敗時: 根本原因特定 → 別ツール/別アプローチを 1 つ試す → なお失敗ならユーザー判断を仰ぐ
- ループ抑制目的の `try/catch` で握りつぶさない（確認できた事実と未確認事項を分けて報告）

---

## 4. パーミッション設計
- `.claude/settings.json` で **Deny を先、Allow を後**に定義
- 機密パス（`**/.env*`, `**/credentials*`, `~/.aws/**`, `~/.ssh/**`, `**/*.pem`, `**/*.key`）は **Deny** に明記
- `defaultMode: acceptEdits` 前提。Edit / Write はサンドボックス内で自動承認
- 読み取り専用コマンド（`git status`, `ls`, `pwd` 等）は Allow で先回り承認
- Bash の書き込み・ネットワーク・破壊的操作、および外部サービス操作は Allow に入れず都度承認
- `git push --force` / `git reset --hard` / `rm -rf` 等の不可逆操作は Deny に明記し、回避経路（`rmdir`, `find -delete`, `gh * close/delete`, `git branch -D` 等）も塞ぐ

---

## 5. メモリ階層
実体は `~/.claude/projects/<project-slug>/memory/`（auto-memory システム、プロジェクト別）。
- **短期**: 本会話内（plan / tasks）— `memory/` には書かない
- **中期**: `memory/project_*.md` — 案件・スプリント単位の状態
- **長期**: `memory/user_*.md` / `memory/feedback_*.md` — ユーザー像・恒常的フィードバック
- **参照**: `memory/reference_*.md` — 外部システム（Linear / Slack / Grafana 等）へのポインタ
- `MEMORY.md` はインデックス専用、1 行 150 字以内（200 行超は切り詰め）
- 本ファイルには**動的情報を書かない**（日付・人名・進行中タスク等）

---

## 6. キャッシュ最適化
- 本ファイル上部ほど更新頻度が低い項目を配置
- `ScheduleWakeup` の `delaySeconds` は 270s 以下 or 1200s 以上を選ぶ（5 分前後はキャッシュミスのみ発生）

---

## 7. 検証ループ（完了条件）
タスクは以下を満たすまで「完了」と報告しない:
- [ ] 該当箇所の `lint` / `typecheck` / `test` がパス（プロジェクトの規定コマンド）
- [ ] UI 変更時はブラウザでゴールデンパス＋エッジケースを操作確認
- [ ] ログ / 出力に想定外のエラー・警告が出ていない
- [ ] 動作確認できない場合は「未検証」と明示してユーザーに判断を委ねる

> 「型チェックとテストはコードの正しさを確認するもので、機能の正しさは確認しない」

---

## 8. 開発原則
詳細は `principles/` 配下を参照: `development.md` / `error-handling.md` / `code-quality.md` / `testing.md` / `security.md` / `performance.md` / `git.md` / `dependencies.md`
