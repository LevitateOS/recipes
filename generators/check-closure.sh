#!/bin/bash
# check-closure.sh SDK: with the host's readelf, list every DT_NEEDED and
# program interpreter of every ELF file under SDK/lib that is not a file
# directly in SDK/lib. Runs nothing it inspects.
set -euo pipefail
lib=$1/lib
n=0; bad=0
while IFS= read -r -d '' f; do
  [ "$(head -c4 "$f" | od -An -c | tr -d ' ')" = '177ELF' ] || continue
  n=$((n+1))
  while read -r want; do
    [ -f "$lib/$want" ] || { echo "MISSING $want <- ${f#$lib/}"; bad=$((bad+1)); }
  done < <(readelf -dlW "$f" | sed -n -e 's/.*(NEEDED).*\[\(.*\)\]/\1/p' -e 's|.*Requesting program interpreter: .*/\([^/]*\)\]|\1|p')
done < <(find "$lib" -type f -print0)
echo "$n ELF files checked, $bad unresolved"
[ "$bad" -eq 0 ]
