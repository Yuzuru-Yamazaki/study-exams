#!/usr/bin/env bash
# Regenerate the static site and deploy it to Vercel.
set -euo pipefail
cd "$(dirname "$0")"

echo "== Building site =="
node site.mjs

echo "== Deploying to Vercel (production) =="
vercel deploy ./site --prod --yes