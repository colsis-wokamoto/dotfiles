# AGENTS.md — Codex エージェント運用ガイドライン

> 常時参照される静的ルールのみを記述する。案件固有の可変情報は `memory/project_*.md` に分離する。

## 0. 適用範囲
- 対象: ホスト上で起動するすべての Codex セッション
- 優先順位: ユーザー直接指示 > 本ファイル > Skills / プラグイン既定値

## 1. ツール使用ルール
- 検索は `rg`、一覧は `rg --files`、手動編集は `apply_patch`、計画管理は `update_plan` を使う。
- 独立した読み取り・検索・検証は `multi_tool_use.parallel` で並列化してよい。
- サブエージェントは、ユーザーが明示的に委任・並列作業を求めた場合のみ使う。

## 2. 禁止事項
- `git push --force` / `git reset --hard` / `rm -rf` はユーザー明示承認なしで実行しない。
- `--no-verify` / `--no-gpg-sign` でフックを回避しない。
- `.env` / `credentials*` / `~/.aws/**` / `~/.ssh/**` / `*.pem` / `*.key` は読み取り・編集・コミットしない。

## 3. Skills / Plugins
- Skill frontmatter には `description` / `inputs` / `outputs` / `side_effects` / `permissions` を書く。
- `permissions` は必要な Codex ツール、MCP、外部コマンドを最小権限で明記する。
- MCP や外部ツールは必要時のみ有効化し、ネットワーク・書き込み・破壊的操作は実行前に承認要否を確認する。

## 4. 失敗時のループ制御
- 同一コマンドの連続失敗 2 回で停止し、状況を報告する。
- 失敗時は、原因特定 → 別ツール / 別アプローチを 1 つ試す → なお失敗ならユーザーに判断を仰ぐ。
- ループ抑制を理由に `try/catch` で握りつぶさない。

## 5. パーミッション設計
- `~/.codex/config.toml` では `approval_policy` と `sandbox_mode` を明示する。
- 既定は `workspace-write` + 承認制、信頼済みプロジェクトだけ緩和する。
- 機密パス禁止は config だけに依存せず、本ファイルの禁止事項として維持する。

## 6. メモリ階層
- 短期: 本会話内（plan / tasks）。`memory/` には書かない。
- 中期: `memory/project_*.md`。案件・スプリント単位。
- 長期: `memory/user_*.md` / `memory/feedback_*.md`。恒常的なユーザー像やフィードバック。
- `MEMORY.md` はインデックス専用、1 行 150 字以内。本ファイルに動的情報を書かない。

## 7. キャッシュ最適化
- 本ファイル上部ほど更新頻度が低い項目を配置（OpenAI のプロンプトキャッシュは安定なプレフィックスでヒット率が上がる）
- 待機を伴う処理は短いポーリングを繰り返すより 1 度にまとめる（プロンプトキャッシュ TTL の浪費を抑える）

## 8. 検証ループ
タスクは以下を満たすまで「完了」と報告しない:
- [ ] 該当箇所の `lint` / `typecheck` / `test` がパス（プロジェクトの規定コマンド）
- [ ] UI 変更時はブラウザでゴールデンパス＋エッジケースを操作確認
- [ ] ログ / 出力に想定外のエラー・警告が出ていない
- [ ] 動作確認できない場合は「未検証」と明示してユーザーに判断を委ねる

> 型チェックとテストはコードの正しさを確認するもので、機能の正しさは確認しない。

## 9. 開発原則
詳細は `principles/` を参照する: `development.md`, `error-handling.md`, `code-quality.md`, `testing.md`, `security.md`, `performance.md`, `git.md`, `dependencies.md`
