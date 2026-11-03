---
name: handoff
description: Write a session handoff note to the current project's docs/notes/ so the next session (or another agent) can pick up where this one left off. Use when the user says "handoff", "wrap up", "save progress", or before ending a long task.
---

# Handoff

Write a short handoff note for the current project.

1. Work out the project root: the nearest folder above the working directory that has a `CLAUDE.md` and a `.git`.
2. Collect the facts:
   - `git status --short` and `git log --oneline -10`
   - what this session did, from the conversation
   - anything left unfinished, broken or undecided
3. Write `docs/notes/YYYY-MM-DD-<short-topic>.md` (create `docs/notes/` if it's missing) with these sections:
   - **Goal**: what we were trying to do
   - **Done**: what changed, with file paths
   - **State**: test and build status, written exactly as it is (say "not run" if it wasn't run)
   - **Next**: concrete next steps, most important first
   - **Open questions**: decisions waiting on the user
4. If the session turned up durable project knowledge (a command, a gotcha, a convention), propose adding it to the project's `CLAUDE.md`. Show the diff and don't write it until the user says so.
5. Reply with the note's path and a three-line summary.

Keep the note under about 60 lines. Use facts, not narrative.
