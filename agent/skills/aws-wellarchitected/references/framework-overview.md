# AWS Well-Architected Framework Overview

## 参照先
- 定義: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/definitions.html
- アーキテクチャについて: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/on-architecture.html
- 一般的な設計原則: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/general-design-principles.html
- 運用上の優秀性: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/operational-excellence.html
- セキュリティ: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/security.html
- 信頼性: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/reliability.html
- パフォーマンス効率: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/performance-efficiency.html
- コスト最適化: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/cost-optimization.html
- 持続可能性: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/sustainability.html

## 用語定義
- コンポーネント: 要件に合わせて提供されるコード、設定、AWS リソース。
- ワークロード: ビジネス価値を実現するコンポーネント群。
- アーキテクチャ: ワークロード内でコンポーネントが連携する構造。
- マイルストーン: 設計/実装/テスト/稼働/本番などの重要変更点。

## 6本柱
- 運用上の優秀性 (Operational Excellence)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/operational-excellence.html
  - 観点: チーム運用モデル、可観測性、自動化、運用改善。
- セキュリティ (Security)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/security.html
  - 観点: IAM、保護、検知、インシデント対応。
- 信頼性 (Reliability)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/reliability.html
  - 観点: 障害耐性、復旧、変更管理、可用性。
- パフォーマンス効率 (Performance Efficiency)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/performance-efficiency.html
  - 観点: リソース選定、需要追従、測定と最適化。
- コスト最適化 (Cost Optimization)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/cost-optimization.html
  - 観点: 使用量可視化、配賦、最適な購買/供給。
- 持続可能性 (Sustainability)
  - URL: https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/framework/sustainability.html
  - 観点: 資源効率、影響測定、継続改善。

## 一般的な設計原則
- 容量ニーズを推測しない。
- 本稼働スケールでテストする。
- アーキテクチャ実験を前提に自動化する。
- アーキテクチャを進化させ続ける。
- データに基づいて意思決定する。
- ゲームデーを使って改善する。

## 運用モデル
- チーム単位の分散オーナーシップを前提にする。
- ベストプラクティス順守を仕組みで担保する。
- 自動チェック、設計レビュー、評価プロセスを組み込む。

## 優先順位付けガイド
- 影響度、発生可能性、工数（高/中/低）で評価する。
- セキュリティと運用上の優秀性は原則として後回しにしない。
- トレードオフは前提と判断根拠を明文化する。
