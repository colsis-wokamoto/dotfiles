#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <service-code> <attribute-name>" >&2
  echo "Example: $0 AmazonECS usagetype" >&2
  exit 1
fi

SERVICE_CODE="$1"
ATTRIBUTE_NAME="$2"
PRICING_REGION="${PRICING_REGION:-us-east-1}"

aws pricing get-attribute-values \
  --region "$PRICING_REGION" \
  --service-code "$SERVICE_CODE" \
  --attribute-name "$ATTRIBUTE_NAME" \
  --output text
