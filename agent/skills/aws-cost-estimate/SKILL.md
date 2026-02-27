---
name: aws-cost-estimate
description: Estimate monthly AWS costs from architecture assumptions using the latest official pricing in a specific region. Use when users ask for AWS cost estimation, component-by-component monthly breakdowns, budget projections, scenario comparisons (e.g., Single-AZ vs Multi-AZ), or autoscaling cost impact.
---

# AWS Cost Estimate

## Overview
AWS 構成の月額コストを、前提条件と最新単価に基づいて再現可能な手順で試算する。
見積は必ず「前提」「単価」「計算式」「合計」「未加算項目」を分離して出力する。
金額は USD を基準に計算し、調査時点の USD/JPY レートで JPY も併記する。
単価取得は `Price List Query API` を第一優先とし、APIが利用できない場合のみ AWS公式料金ページ（ブラウザ）を使用する。

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
  1. `Price List Query API`（必須の第一選択）
  2. APIが利用できない場合のみ AWS公式料金ページ（ブラウザ）
- Price List Query API の使い方:
  - 前提:
    - IAM 権限 `pricing:DescribeServices` `pricing:GetAttributeValues` `pricing:GetProducts` を確認する。
    - エンドポイントは Pricing API 対応リージョン（例: `us-east-1`）を使用し、価格対象リージョンは属性値で絞り込む。
  - 手順:
    1. `DescribeServices` で `ServiceCode` を確認する。
    2. `GetAttributeValues` で `location` / `instanceType` / `databaseEngine` など必要属性を確認する。
    3. `GetProducts` の `TERM_MATCH` フィルタで対象SKUを取得する。
    4. `terms.OnDemand.*.priceDimensions.*.pricePerUnit.USD` から単価を抽出する。
    5. 結果が0件なら属性探索で再検索する（`usagetype` / `group` を優先）。
  - 具体コマンド例とスクリプト:
    - `references/price-list-query-api.md` を参照する。
    - `scripts/pricing-list-attributes.sh` と `scripts/pricing-list-attribute-values.sh` と `scripts/pricing-get-products.sh` を優先して使う。
  - 抽出ルール:
    - `OnDemand` を優先する。
    - 対象リージョン（例: `Asia Pacific (Tokyo)`）に一致するものだけ採用する。
    - 単位（`Hrs` `GB-Mo` `LCU-Hrs` など）を保持する。
- API利用不可時のフォールバック:
  - 失敗条件を明記する（例: IAM権限不足、API未対応項目、通信不可、属性探索後も対象SKUを一意取得できない）。
  - AWS公式料金ページをブラウザで開き、対象リージョンの単価を取得する。
  - 取得ページURLと取得日を記録する。

3. 月額計算を行う
- デフォルトは `730 時間/月` を使用する。
- 代表式:
  - Fargate: `((vCPU単価 × vCPU数) + (メモリ単価 × GB)) × タスク数 × 730`
  - ALB: `(ALB時間単価 + (LCU単価 × 平均LCU)) × 730`
  - NAT Gateway: `(時間単価 × 730) + (データ処理単価 × GB)`
  - RDS: `時間単価 × 730`
  - S3/EFS: `GB月単価 × 容量GB`
  - CloudFront転送: `転送単価 × GB`

4. USD/JPY レートを取得し JPY 換算を行う
- 取得時ルール:
  - 見積作成時点のドル円レート（`1 USD = ? JPY`）を使用する。
  - 取得日時（`YYYY-MM-DD HH:mm TZ`）を明記する。
- 換算式:
  - `JPY金額 = USD金額 × USDJPYレート`
- 表示ルール:
  - 各主要項目と合計に USD と JPY を併記する。

5. 感度分析を追加する
- AutoScalingの増分を追加する:
  - `+1タスク` あたり月額増分
  - `min` と `max` の差分上限
- 代替構成も必要に応じて算出する:
  - 例: RDS Single-AZ と Multi-AZ

6. Markdownで出力する
- 以下の順番で出力する:
  1. 試算条件
  2. 単価（ソース付き。取得方法とフォールバック理由を含む）
  3. 為替レート（USD/JPY、取得日時）
  4. 計算式と各項目の月額（USD/JPY）
  5. 合計（USD/JPY）
  6. 比較シナリオ
  7. 注意点（未加算項目）
  8. 参考URL

## Output Template
```markdown
# AWSコスト試算（<region>）

更新日: <YYYY-MM-DD>
通貨: USD / JPY

## 試算条件
- ...

## 単価
- ...（取得方法: Price List Query API / AWS公式料金ページ）
- ...（フォールバック理由: <API利用不可理由>） ※API利用時は省略可

## 為替レート
- USD/JPY: 1 USD = <rate> JPY
- 取得日時: <YYYY-MM-DD HH:mm TZ>

## 月額試算
- ...: $<usd> / 月（¥<jpy> / 月）

合計:
- **$<total_usd> / 月（¥<total_jpy> / 月）**

## シナリオ比較
- ...

## 注意点
- ...

## 参考URL
- ...
```

## Quality Gates
出力前に以下を確認する。
- 単価取得の優先順位（API優先、不可時のみブラウザ）を守ったか。
- 単価は対象リージョンに一致しているか。
- 単価の単位と計算式が整合しているか。
- 合計に含めた項目と除外項目が明確か。
- 為替レートの単位（`1 USD = ? JPY`）と取得日時を明記したか。
- JPY換算が `USD × レート` で整合しているか。
- `today` / `latest` のような相対表現は具体日付で補足したか。
- APIから取得できなかった単価は、フォールバック理由と取得元URLを明記したか。
- 参照URLがすべて公式ソースか。

## Common Omissions
次は漏れやすいため、未加算なら必ず明記する。
- CloudFront/S3 のリクエスト課金
- RDS ストレージ・I/O・バックアップ超過
- CloudWatch Logs 取り込み/保管
- インターネット・AZ間データ転送
- 税金、割引（RI/Savings Plans）
- 為替変動による見積差分（試算時点と請求時点の乖離）
