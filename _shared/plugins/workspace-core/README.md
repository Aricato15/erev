# workspace-core

Skills and agents shared by every project in this workspace. The plugin is installed at user scope from the local `claude-projects` marketplace (`_shared/` at the workspace root), and each project's `.claude/settings.json` also enables it.

- `skills/handoff`: `/workspace-core:handoff` writes a session handoff note to the project's `docs/notes/`.
- `skills/commit`: `/workspace-core:commit` reviews the staged changes, proposes a Conventional Commits message, confirms it with you, then commits. The convention is in `skills/commit/references/conventional-commits.md`.
- `agents/reviewer.md`: a read-only reviewer that checks the current diff for bugs, missing tests and convention breaches.

To add a shared skill, create `skills/<name>/SKILL.md`. To add an agent, create `agents/<name>.md`. Hooks go in `hooks/hooks.json`; use PowerShell or Node commands, because this is Windows. Edits load in place: run `/reload-plugins` or start a new session. Bump `version` in `.claude-plugin/plugin.json` when you make significant changes.
