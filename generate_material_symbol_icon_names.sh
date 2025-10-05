#!/bin/bash
set -e

echo "[DEBUG] Starting icon names generation script..."
input_file=$(find input -maxdepth 1 -type f -name "*.codepoints" | head -n 1)
echo "[DEBUG] Input file: $input_file"
if [[ -z "$input_file" ]]; then
  echo "❌ No .codepoints file found in input/ directory." >&2
  exit 1
fi
ts_file="/app/output/material-symbols-icon-name.ts"
echo "[DEBUG] Output file: $ts_file"
type_name="MaterialSymbolsIconName"

# Extract first word from each line, sort and deduplicate
echo "[DEBUG] Extracting icon names..."
words=$(awk '{print $1}' "$input_file" | sort | uniq)

# Build TypeScript union type
echo "[DEBUG] Writing TypeScript file..."
{
  echo "// Auto-generated from $input_file"
  echo "export type $type_name ="
  for word in $words; do
    echo "  | '$word'"
  done
  echo ";"
} > "$ts_file"

echo "✅ TypeScript union type generated at $ts_file"
