---
name: new-project
description: Create a new project folder in D:\claude_projects from the workspace template (CLAUDE.md, .claude/ skills/agents/rules, docs/, its own git repo) and register it in PROJECTS.md. Use when the user wants to start, scaffold or add a new project or application.
argument-hint: "[project-name]"
---

# New project

Create a new project in this workspace.

1. **Collect the inputs.** Use `$ARGUMENTS` as the name if one was given. Ask only for what's missing:
   - **name**: kebab-case, such as `invoice-api`. It must not start with `_` or already exist in the workspace root.
   - **description**: one or two sentences about what it is and who it's for.
   - **stack**: e.g. "Python 3.12, FastAPI, uv" or "TypeScript, Next.js, npm".
2. **Scaffold it** by running this from the workspace root:
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File _scripts/new-project.ps1 -Name "<name>" -Description "<description>" -Stack "<stack>"
   ```
   If it fails, show the error and stop. Don't scaffold by hand.
3. **Tailor it to the stack.** Only do this if the user wants the toolchain set up now; ask once.
   - Initialise the toolchain inside the project, e.g. `uv init` for Python or `npm init -y` for Node.
   - Replace the `TODO` lines under **Commands** in `<name>/CLAUDE.md` with the real install, run, test and lint commands.
   - Add matching allow rules to `<name>/.claude/settings.json`, e.g. `"Bash(uv run:*)"` or `"Bash(npm run:*)"`, `"Bash(npm test:*)"`.
   - Commit in the new project: `git -C <name> add -A`, then `git -C <name> commit -m "Set up <stack> toolchain"`.
4. **Report back** with the path, what was created, and the next step: `cd <name>` then `claude`. Mention that project-specific skills go in `<name>/.claude/skills/<skill>/SKILL.md` and agents in `<name>/.claude/agents/<agent>.md`.

Leave the template, `_shared/` and other projects alone.
