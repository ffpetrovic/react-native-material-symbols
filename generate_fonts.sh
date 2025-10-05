

#!/bin/bash
set -e
echo "🔷 Script started: $(date)"

weights=(100 200 300 400 500 600 700)
styles=(Sharp Rounded Outlined)
fills=(0 1)
opszs=(20 24 48)

# Function to process a single font variant
process_font() {
  local style=$1
  local weight=$2
  local fill=$3
  local opsz=$4

  input_file="./input/MaterialSymbols${style}[FILL,GRAD,opsz,wght].ttf"
  output_dir="/app/output/fonts"
  mkdir -p "$output_dir"
  output_file="$output_dir/MaterialSymbols-${style}-${weight}-FILL${fill}-OPSZ${opsz}.ttf"

  if [[ ! -f "$input_file" ]]; then
    echo "❌ ERROR: Input font file not found: $input_file" >&2
    return 1
  fi

  echo "Processing: $input_file wght=$weight FILL=$fill opsz=$opsz"
  if fonttools varLib.instancer "$input_file" wght=$weight FILL=$fill opsz=$opsz -o "$output_file"; then
    echo "fonttools succeeded for $output_file"
  else
    echo "❌ ERROR: fonttools failed for $input_file" >&2
    return 1
  fi
  if python3 rename_font.py "$output_file" "$output_file" "MaterialSymbols${weight}${style}Fill${fill}Opsz${opsz}"; then
    echo "rename_font.py succeeded for $output_file"
  else
    echo "❌ ERROR: rename_font.py failed for $output_file" >&2
    return 1
  fi
  echo "✅ Completed: $output_file"
}

# Export the function so it's available to subshells
export -f process_font


# Safe parallelization setup
max_jobs=8  # Adjust based on your system's capabilities
job_pids=()
job_status=()

run_job() {
  process_font "$@" &
  job_pids+=("$!")
}

for style in "${styles[@]}"; do
  for weight in "${weights[@]}"; do
    for fill in "${fills[@]}"; do
      for opsz in "${opszs[@]}"; do
        echo "🔷 Loop: style=$style weight=$weight fill=$fill opsz=$opsz"
        run_job "$style" "$weight" "$fill" "$opsz"
        # Limit number of concurrent jobs
        if (( ${#job_pids[@]} >= max_jobs )); then
          for pid in "${job_pids[@]}"; do
            wait "$pid"
            job_status+=("$?")
          done
          job_pids=()
        fi
      done
    done
  done
done

# Wait for any remaining jobs
for pid in "${job_pids[@]}"; do
  wait "$pid"
  job_status+=("$?")
done

# Report any failed jobs
fail_count=0
for status in "${job_status[@]}"; do
  if [[ "$status" != "0" ]]; then
    ((fail_count++))
  fi
done
if (( fail_count > 0 )); then
  echo "❌ $fail_count font jobs failed. See above for errors."
else
  echo "✅ All font jobs completed successfully."
fi

echo "✅ All fonts have been processed in parallel."

# Wait for any remaining background jobs
wait

# Count output files
output_dir="/app/output/fonts"
file_count=$(ls "$output_dir"/*.ttf 2>/dev/null | wc -l)
if [[ $file_count -eq 0 ]]; then
  echo "⚠️  No font files were created in $output_dir. Check for errors above."
else
  echo "✅ $file_count font files have been processed and saved in $output_dir."
fi
