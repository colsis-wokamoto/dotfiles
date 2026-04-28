# Git repository 運用ガイドライン（テンプレート）

このプロジェクトでは、品質確保とデプロイ運用の円滑化のため、以下のルールに従って Git リポジトリを運用します。
In this project, we operate the Git repository according to the following rules to ensure quality and streamline deployment operations.

## 1. ブランチ構成と役割 / Branch Structure and Roles

| Branch Name | Role | Environment | Notes |
| --- | --- | --- | --- |
| main | 本番リリース用 | Production Environment | マージ時に自動デプロイ |
| develop | 開発統合用 | Staging Environment | デフォルトブランチ。マージ時に自動デプロイ |
| feature/* | 機能開発用 | Local/Staging | develop から派生 |
| fix/* | バグ修正用 | Local/Staging | develop から派生 |

## 2. CI/CD と自動デプロイ / CI/CD and Automatic Deployment

CI/CD パイプラインは特定ブランチへの変更（Push/Merge）で起動します。
The CI/CD pipeline is triggered by changes (Push/Merge) to specific branches.

- 🚀 Deployment to Staging: develop ブランチに反映されたら自動実行
- 🚀 Deployment to Production: main ブランチに反映されたら自動実行

## 3. 開発とリリースのワークフロー / Development and Release Workflow

### Daily Development Flow（機能追加/修正）

1. ブランチ作成
   - develop を最新化してから作業ブランチ（例: feature/xxx）を作成
2. PR 作成
   - develop 向けに Pull Request を作成
3. レビューとマージ
   - 権限: Maintainer 以上がレビュー/マージを担当
   - 承認後、Maintainer が develop にマージ
   - マージ後、ステージング環境へ自動デプロイ

### Production Release Flow

1. リリース PR 作成
   - ステージング検証完了後、develop → main の PR を作成
2. レビューとマージ
   - 権限: Maintainer 以上がレビュー/マージを担当
   - マージ後、本番環境へ自動デプロイ

## 4. 禁止事項・制限（重要） / Prohibitions and Restrictions (Important)

品質維持と事故防止のため、以下を厳格に禁止します。
To prevent accidents and maintain quality, the following operations are strictly prohibited.

- 🚫 直接 Push 禁止: main / develop への直接 push を禁止
- 🚫 直接マージ禁止: ローカルで git merge による統合は禁止。必ず PR を使用
- 🚫 権限外マージ禁止: PR のマージは Maintainer 以上のみ
