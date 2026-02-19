---
name: aws-wellarchitected
description: Use when designing or reviewing AWS architectures for reliability, security, performance efficiency, cost optimization, operational excellence, and sustainability based on the AWS Well-Architected Framework.
---

# AWS Well-Architected

## Overview
AWS Well-Architected Framework に基づいて、AWS ワークロードの設計・運用を評価し、改善計画を作成するためのスキルです。詳細は `references/` 配下を参照します。

## When to Use
- AWS 上の新規システム設計
- 既存ワークロードの設計レビュー
- 信頼性/セキュリティ/性能/コスト/運用/持続可能性の改善提案
- アーキテクチャのトレードオフ整理と優先順位付け

## Reference Files
- `references/framework-overview.md`: 用語、6本柱、設計原則、運用モデル、優先順位付けの基準。開始時に読む。
- `references/pillar-checklist.md`: 6本柱の詳細チェックリスト。レビュー実施時に読む。
- `references/report-template.md`: レビュー報告書テンプレート。成果物作成時に読む。
- `examples/report-sample.md`: ダミー値入りの報告書サンプル。出力形式を確認したいときに読む。

## Workflow
1. `references/framework-overview.md` を読み、ワークロード定義と評価観点を固定する。
2. `references/pillar-checklist.md` を使って 6 本柱を `Yes / No / 要確認` で評価する。
3. `No` 項目をリスク化し、影響度・工数・依存関係で優先順位付けする。
4. トレードオフを明示した改善計画を作る。
5. `references/report-template.md` で結果を報告書として出力する。

## Output Rules
- 推測ではなく、確認済みの情報に基づいて判断する。
- 推奨事項には必ず根拠（どの柱・どの原則に対応するか）を添える。
- 改善案は実装可能な粒度に分解する。
- 報告書は `references/report-template.md` の Markdown 表フォーマットを固定で使用し、列構成を変更しない。
- 未確定情報は空欄にせず `要確認` と記載する。
