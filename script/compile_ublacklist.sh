#!/bin/bash

if ! which jq >/dev/null; then
  echo "jq is required" >&2
  exit 1
fi

if ! which git >/dev/null; then
  echo "git is required" >&2
  exit 1
fi

dist="$(dirname "$0")/../ublacklist.txt"
if [ -f "$dist" ]; then
  rm "$dist"
fi

output() {
  echo "$1" >> "$dist"
}

output "# This blacklist is powered by https://github.com/KisaragiEffective/no_knightmare"
output "# Generated-Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
output "# Git-Commit: $(git rev-parse HEAD)"
output "# SPDX-License-Identifier: CC0-1.0"

data="$(dirname "$0")/../data.json"
jq -r '.[] | select(.type == "domain") | .domain | ("*://" + . + "/*")' < "$data" >> "$dist"
jq -r '.[] | select(.type == "path") | .path | ("*://" + .)' < "$data" >> "$dist"
