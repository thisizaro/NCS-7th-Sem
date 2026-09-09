#!/usr/bin/env bash
# Link this machine's Claude memory directory to the repo-tracked one.
# Run once per machine, from anywhere:   bash scripts/setup-sync.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_MEM="$REPO/.claude/memory"

# Claude Code derives its project slug from the absolute path,
# replacing every non-alphanumeric character with a hyphen.
SLUG="$(printf '%s' "$REPO" | sed 's/[^A-Za-z0-9]/-/g')"
CC_PROJ="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/$SLUG"
CC_MEM="$CC_PROJ/memory"

mkdir -p "$REPO_MEM" "$CC_PROJ"

if [ -L "$CC_MEM" ]; then
  current="$(readlink "$CC_MEM")"
  if [ "$current" = "$REPO_MEM" ]; then
    echo "already linked: $CC_MEM -> $REPO_MEM"
    exit 0
  fi
  echo "replacing stale symlink (was: $current)"
  rm "$CC_MEM"
elif [ -d "$CC_MEM" ]; then
  # Preserve anything already there before we replace the directory.
  if [ -n "$(ls -A "$CC_MEM" 2>/dev/null)" ]; then
    echo "merging existing memory files into repo..."
    cp -rn "$CC_MEM"/. "$REPO_MEM"/ 2>/dev/null || true
    backup="$CC_MEM.backup.$(date +%Y%m%d%H%M%S)"
    mv "$CC_MEM" "$backup"
    echo "previous memory backed up to: $backup"
  else
    rmdir "$CC_MEM"
  fi
fi

ln -s "$REPO_MEM" "$CC_MEM"
echo "linked: $CC_MEM -> $REPO_MEM"
echo "slug:   $SLUG"
echo
echo "Memory now lives in the repo. Commit and push to share it with your other machine."
