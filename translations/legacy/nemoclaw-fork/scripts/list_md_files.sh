#!/bin/bash

# Find all .md or .mdx files, excluding PROGRESS.md and files already translated (*_zh_TW.md/mdx)
# And only list files that DO NOT have a _zh_TW counterpart
find . -type f \( -name "*.md" -o -name "*.mdx" \) \
  -not -path "*/node_modules/*" \
  -not -path "*/dist/*" \
  -not -name "PROGRESS.md" \
  -not -name "*_zh_TW.md" \
  -not -name "*_zh_TW.mdx" \
  | sed 's|^\./||' | while read -r file; do
    ext="${file##*.}"
    base="${file%.*}"
    translated="${base}_zh_TW.${ext}"
    if [ ! -f "$translated" ]; then
        echo "$file"
    fi
done
