---
name: aws-cost-estimate
description: Estimate monthly AWS costs from architecture assumptions using the latest official pricing in a specific region. Use when users ask for AWS cost estimation, component-by-component monthly breakdowns, budget projections, scenario comparisons (e.g., Single-AZ vs Multi-AZ), or autoscaling cost impact.
---

# AWS Cost Estimate

## Overview
AWS 構成の月額コストを、前提条件と最新単価に基づいて再現可能な手順で試算する。
見積は必ず「前提」「単価」「計算式」「合計」「未加算項目」を分離して出力する。

## Required Inputs
以下を先に確定する。
- 対象リージョン（例: `ap-northeast-1`）
- リソース構成（例: Fargate/ALB/RDS/S3/EFS/CloudFront/NAT）
- 稼働条件（常時台数、vCPU/メモリ、転送量、保存容量、LCU想定）
- 比較シナリオの有無（Single-AZ vs Multi-AZ、AutoScaling上下限など）

未確定値は推定せず、`要確認` として明記する。

## Workflow
1. Scopeを固定する
- 何を「合計」に含めるかを最初に定義する。
- 例: hosting全体に含める項目、含めない項目（リクエスト課金、I/O課金、税金など）。

2. 単価を公式ソースから取得する
- 優先順位:
  1. AWS公式の料金ページ（対象リージョンを明示）
  2. AWSの料金JSON/API（Price List API、meteredUnitMaps など）
  3. 公式ドキュメント内の料金例（不足時のみ）
- 取得時ルール:
  - リージョン名を必ず明示する（例: `Asia Pacific (Tokyo)`）。
  - 単位を必ず保持する（`/時`、`/GB-月`、`/LCU-時` など）。
  - 取得日を記録する。

3. 月額計算を行う
- デフォルトは `730 時間/月` を使用する。
- 代表式:
  - Fargate: `((vCPU単価 × vCPU数) + (メモリ単価 × GB)) × タスク数 × 730`
  - ALB: `(ALB時間単価 + (LCU単価 × 平均LCU)) × 730`
  - NAT Gateway: `(時間単価 × 730) + (データ処理単価 × GB)`
  - RDS: `時間単価 × 730`
  - S3/EFS: `GB月単価 × 容量GB`
  - CloudFront転送: `転送単価 × GB`

4. 感度分析を追加する
- AutoScalingの増分を追加する:
  - `+1タスク` あたり月額増分
  - `min` と `max` の差分上限
- 代替構成も必要に応じて算出する:
  - 例: RDS Single-AZ と Multi-AZ

5. Markdownで出力する
- 以下の順番で出力する:
  1. 試算条件
  2. 単価（ソース付き）
  3. 計算式と各項目の月額
  4. 合計
  5. 比較シナリオ
  6. 注意点（未加算項目）
  7. 参考URL

## Output Template
```markdown
# AWSコスト試算（<region>）

更新日: <YYYY-MM-DD>
通貨: USD

## 試算条件
- ...

## 単価
- ...

## 月額試算
- ...

合計:
- **$<total> / 月**

## シナリオ比較
- ...

## 注意点
- ...

## 参考URL
- ...
```

## Quality Gates
出力前に以下を確認する。
- 単価は対象リージョンに一致しているか。
- 単価の単位と計算式が整合しているか。
- 合計に含めた項目と除外項目が明確か。
- `today` / `latest` のような相対表現は具体日付で補足したか。
- 参照URLがすべて公式ソースか。

## Common Omissions
次は漏れやすいため、未加算なら必ず明記する。
- CloudFront/S3 のリクエスト課金
- RDS ストレージ・I/O・バックアップ超過
- CloudWatch Logs 取り込み/保管
- インターネット・AZ間データ転送
- 税金、割引（RI/Savings Plans）
