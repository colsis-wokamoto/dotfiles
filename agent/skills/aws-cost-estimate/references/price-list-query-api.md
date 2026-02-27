# Price List Query API: AWS CLI コマンド例

`aws-cost-estimate` スキルで単価を取得するときの実行例。
優先順位は常に次の通り。

1. Price List Query API
2. APIが利用できない場合のみ AWS公式料金ページ（ブラウザ）

## 前提

- AWS CLI v2
- `jq`
- IAM 権限: `pricing:DescribeServices` `pricing:GetAttributeValues` `pricing:GetProducts`
- 価格APIリージョン: `us-east-1`（既定）
- 対象リージョン名: `Asia Pacific (Tokyo)`（`ap-northeast-1`）

```bash
export PRICING_REGION=us-east-1
export TARGET_REGION_NAME='Asia Pacific (Tokyo)'
```

## 1) サービスコード確認

```bash
aws pricing describe-services \
  --region "$PRICING_REGION" \
  --query 'Services[].ServiceCode' \
  --output text
```

## 2) 属性名確認（サービス別）

```bash
./scripts/pricing-list-attributes.sh AmazonRDS
./scripts/pricing-list-attributes.sh AmazonECS
./scripts/pricing-list-attributes.sh AWSELB
```

## 2.5) 0件時の属性探索（重要）

`get-products` が 0件のときは、`usagetype` と `group` を探索して再検索する。

```bash
./scripts/pricing-list-attribute-values.sh AmazonECS usagetype | rg 'Fargate|APN1'
./scripts/pricing-list-attribute-values.sh awswaf group
```

探索で見つかった値を `field=value` として `pricing-get-products.sh` に渡す。

## 3) 単価取得（On-Demand）基本形

```bash
./scripts/pricing-get-products.sh AmazonRDS instanceType=db.t4g.micro deploymentOption=Single-AZ
```

出力形式:

```text
<unit>\t<usd>\t<description>
```

## サービス別の実行例

RDS `db.t4g.micro`（Single-AZ, On-Demand）

```bash
./scripts/pricing-get-products.sh \
  AmazonRDS \
  instanceType=db.t4g.micro \
  deploymentOption=Single-AZ \
  databaseEngine=PostgreSQL
```

Fargate vCPU / Memory

```bash
./scripts/pricing-list-attribute-values.sh AmazonECS usagetype | rg 'APN1-Fargate'
SKIP_LOCATION_FILTER=1 ./scripts/pricing-get-products.sh AmazonECS 'usagetype=APN1-Fargate-vCPU-Hours:perCPU'
SKIP_LOCATION_FILTER=1 ./scripts/pricing-get-products.sh AmazonECS 'usagetype=APN1-Fargate-GB-Hours'
```

ALB 時間課金 / LCU 課金

```bash
./scripts/pricing-get-products.sh AWSELB | rg 'Application LoadBalancer-hour|Application load balancer capacity unit-hour'
```

EFS Standard ストレージ

```bash
./scripts/pricing-get-products.sh AmazonEFS storageClass=General\ Purpose
```

S3 Standard ストレージ（first 50TB tier を description で確認）

```bash
./scripts/pricing-get-products.sh AmazonS3 volumeType=Standard
```

CloudFront Data Transfer Out（日本向け tier を description で確認）

```bash
SKIP_LOCATION_FILTER=1 ./scripts/pricing-get-products.sh AmazonCloudFront fromLocation=Japan toLocation=External
```

WAF（標準 Web ACL / Rule / Request）

```bash
./scripts/pricing-list-attribute-values.sh awswaf group
./scripts/pricing-get-products.sh awswaf 'group=Web ACL'
./scripts/pricing-get-products.sh awswaf 'group=Rule'
./scripts/pricing-get-products.sh awswaf 'group=Request' | rg '0.60 per million|Price per HTTP request'
```

NAT Gateway（APIで一意取得できない場合の扱い）

```bash
./scripts/pricing-list-attribute-values.sh AmazonVPC group
# NAT関連が見つからない、またはSKU一意取得不可なら公式ページへフォールバック
```

## API利用不可時のフォールバック

以下のいずれかに該当した場合のみ、AWS公式料金ページ（ブラウザ）を使う。

- IAM権限不足
- APIで目的SKUを一意に取得できない
- ネットワーク・認証・CLI実行不可

フォールバック時は必ずレポートに記載する。

- フォールバック理由
- 取得ページURL
- 取得日
