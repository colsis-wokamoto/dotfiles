# GEMINI.md — Gemini CLI エージェント運用ガイドライン

> 常時参照される静的ルールのみを記述する。案件固有の可変情報は `save_memory` ツールを使用してプロジェクトスコープで管理する。

## 0. 適用範囲
- 対象: ホスト上で起動するすべての Gemini CLI セッション
- 優先順位: ユーザー直接指示 > 本ファイル > Skills / サブエージェント規定値

## 1. ツール使用ルール
- 検索は `grep_search`、ファイル一覧は `glob` または `list_directory`、手動編集は `replace` または `write_file` を使う。
- 複雑な設計や調査が必要な場合は `enter_plan_mode` を使用して計画を策定する。
- 独立した読み取り・検索・検証は並列に実行して効率化を図る（`wait_for_previous: false`）。
- サブエージェント（`generalist`, `codebase_investigator` 等）は、大量のデータ処理や広範な調査が必要な場合に積極的に活用する。

## 2. 禁止事項
- `git push --force` / `git reset --hard` / `rm -rf` はユーザーの明示的な承認なしで実行しない。
- `--no-verify` / `--no-gpg-sign` 等でコミットフックや署名を回避しない。
- `.env` / `credentials*` / `~/.aws/**` / `~/.ssh/**` / `*.pem` / `*.key` は読み取り・編集・コミットしない。

## 3. Skills / Plugins
- Skill の `activate_skill` で提供される `<instructions>` は、そのタスクにおける専門的なガイダンスとして最優先する。
- MCP ツールや外部ツールは必要時のみ有効化し、ネットワーク・書き込み・破壊的操作は実行前に安全性を確認する。

## 4. 失敗時のループ制御
- 同一操作の連続失敗 2 回で停止し、状況を詳細に報告する。
- 失敗時は、原因特定（ログ確認等）を行い、別のアプローチを試みる。解決不能な場合は速やかにユーザーに判断を仰ぐ。
- エラーを `try/catch` 等で黙殺せず、透明性を持って報告する。

## 5. 開発プロセス
- **Research -> Strategy -> Execution** のライフサイクルを遵守する。
- **Execution** フェーズでは、各サブタスクを **Plan -> Act -> Validate** のサイクルで解決する。
- コード変更前には既存の規約（命名、フォーマット、型定義、コメント）を分析し、周囲のコードと調和させる。

## 6. メモリ階層
実体は `context.fileName` で読み込まれる Markdown ファイル群。Gemini CLI は per-type の auto-memory 構造を持たないため、**ファイル / セクション単位で用途を分離**する。
- 短期: 本会話内（plan / chat）— ファイルには書かない
- 中期: プロジェクト直下の `GEMINI.md`（または `.gemini/` 配下に分割）— 案件・スプリント単位の状態。`write_file` / `replace` で手動編集
- 長期: `~/.gemini/GEMINI.md` — ユーザー像・恒常的フィードバック。`save_memory(fact)` で `## Gemini Added Memories` に append、または手動編集
- 参照: `~/.gemini/GEMINI.md` の `## References` セクション、または `context.fileName` に追加した別ファイル — 外部システム（Linear / Slack / Grafana 等）へのポインタ
- セクションが肥大したら別ファイルに切り出して `context.fileName` に追加する
- 本ファイルには動的情報を書かない（日付・人名・進行中タスク等）

## 7. キャッシュ最適化
- 本ファイル上部ほど更新頻度が低い項目を配置（Gemini の implicit / context cache は安定なプレフィックスで再利用される）
- 待機を伴う処理は短いポーリングを繰り返すより 1 度にまとめる（context cache TTL の浪費を抑える）

## 8. 検証ループ
タスクは以下を満たすまで「完了」と報告しない:
- [ ] 該当箇所の `lint` / `typecheck` / `test` がパス（プロジェクトの規定コマンド）
- [ ] UI 変更時はブラウザでゴールデンパス＋エッジケースを操作確認
- [ ] ログ / 出力に想定外のエラー・警告が出ていない
- [ ] 動作確認できない場合は「未検証」と明示してユーザーに判断を委ねる

> 型チェックとテストはコードの正しさを確認するもので、機能の正しさは確認しない。

## 9. 開発原則
詳細は `principles/` を参照する: `development.md`, `error-handling.md`, `code-quality.md`, `testing.md`, `security.md`, `performance.md`, `git.md`, `dependencies.md`
