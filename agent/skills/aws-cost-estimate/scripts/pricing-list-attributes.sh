#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <service-code>" >&2
  echo "Example: $0 AmazonRDS" >&2
  exit 1
fi

SERVICE_CODE="$1"
PRICING_REGION="${PRICING_REGION:-us-east-1}"

aws pricing describe-services \
  --region "$PRICING_REGION" \
  --service-code "$SERVICE_CODE" \
  --query 'Services[0].AttributeNames' \
  --output table
