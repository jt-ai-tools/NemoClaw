#!/bin/bash

# Find all original markdown files
files=$(./scripts/list_md_files.sh)
total_files=$(echo "$files" | wc -l)
missing_files=0

echo "Checking translation status..."
echo "Total original files: $total_files"

for file in $files; do
  ext="${file##*.}"
  base="${file%.*}"
  translated="${base}_zh_TW.${ext}"
  
  if [ ! -f "$translated" ]; then
    echo "❌ Missing translation for: $file"
    ((missing_files++))
  fi
done

if [ $missing_files -eq 0 ]; then
  echo "✅ All translations are completed!"
  exit 0
else
  echo "⚠️  There are $missing_files missing translations."
  exit 1
fi
