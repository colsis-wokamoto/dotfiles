#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <service-code> [field=value ...]" >&2
  echo "Example: $0 AmazonRDS instanceType=db.t4g.micro deploymentOption=Single-AZ" >&2
  exit 1
fi

SERVICE_CODE="$1"
shift

PRICING_REGION="${PRICING_REGION:-us-east-1}"
TARGET_REGION_NAME="${TARGET_REGION_NAME:-Asia Pacific (Tokyo)}"
SKIP_LOCATION_FILTER="${SKIP_LOCATION_FILTER:-0}"

FILTERS=()
if [[ "$SKIP_LOCATION_FILTER" != "1" ]]; then
  FILTERS+=("Type=TERM_MATCH,Field=location,Value=${TARGET_REGION_NAME}")
fi

for kv in "$@"; do
  if [[ "$kv" != *=* ]]; then
    echo "Invalid filter format: $kv (expected field=value)" >&2
    exit 1
  fi
  field="${kv%%=*}"
  value="${kv#*=}"
  FILTERS+=("Type=TERM_MATCH,Field=${field},Value=${value}")
done

aws pricing get-products \
  --region "$PRICING_REGION" \
  --service-code "$SERVICE_CODE" \
  --filters "${FILTERS[@]}" \
  --max-results 100 \
| jq -r '
  .PriceList[]
  | fromjson
  | .terms.OnDemand[]?.priceDimensions[]?
  | [.unit, .pricePerUnit.USD, .description]
  | @tsv
'
