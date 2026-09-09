# NCS-7th-Sem

Study material for **Network and Cyber Security (CS40017)**, 7th semester, KIIT.

## Setup on a new machine

```bash
git clone git@github.com:thisizaro/NCS-7th-Sem.git
cd NCS-7th-Sem
bash scripts/setup-sync.sh
```

That links Claude Code's memory directory for this project to `.claude/memory/`
in the repo, so notes and context follow you between machines. Commit and push
to share; pull to receive.

## What's here

| Path | Contents |
|---|---|
| `study/` | **Start here.** Exam notes, practice Q&A, comparison tables, flashcards |
| `slides/` | The lecture decks as searchable Markdown, including speaker notes |
| `decks/` | Original `.ppt` files |
| `syllabus/` | Official syllabus and lesson plan |
| `scripts/` | Slide extraction and machine-setup tooling |

See [CLAUDE.md](CLAUDE.md) for the syllabus breakdown and an important note on
how the decks map (and don't map) onto the exam units.

## Regenerating slide Markdown

Requires Microsoft PowerPoint on a Windows host (works from WSL):

```bash
powershell.exe -NoProfile -ExecutionPolicy Bypass -File 'scripts\extract-slides.ps1'
```
