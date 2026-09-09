---
name: claude-memory-syncs-via-repo
description: Claude's memory for this project lives in the repo at .claude/memory and is symlinked per machine
metadata:
  type: project
---

Aranya works on this repo from **two machines** (personal WSL box and a work PC)
and wants Claude's context to follow him.

Set up 2026-09-09: the real memory files live in the repo at `.claude/memory/`,
and `~/.claude/projects/<slug>/memory` is a **symlink** pointing at them. The
slug is the project's absolute path with every non-alphanumeric character
replaced by a hyphen (here: `-mnt-d-Sem-7-NCS-7th-Sem`), so it differs per
machine — which is exactly why `scripts/setup-sync.sh` computes it at runtime
rather than hardcoding it.

**On a new machine:** clone, then `bash scripts/setup-sync.sh`.

Session transcripts (`*.jsonl`) are deliberately **not** synced — they are large
and conflict badly when two machines are active. `.gitignore` excludes them.
Cross-machine continuity comes from `CLAUDE.md` plus these memory files.
