# claude_projects

A workspace for agentic coding with Claude Code. Each top-level folder is one project or application. Folders that start with `_` hold the workspace's own setup.

```
CLAUDE.md            Rules for every project (Claude loads parent CLAUDE.md files automatically)
PROJECTS.md          List of projects
.claude/             Used only when Claude is started here at the root (the /new-project skill)
_shared/             Local plugin marketplace "claude-projects"
  plugins/workspace-core/   Skills, agents and hooks shared by every project
_templates/project/  Starter copied into each new project
_scripts/            Helper scripts (new-project.ps1)
<project>/           A project: its own git repo, CLAUDE.md, .claude/skills, .claude/agents
```

## What Claude loads in a project
Start `claude` inside a project folder (for example `D:\claude_projects\my-app`).

| Source | Loaded? |
|---|---|
| `D:\claude_projects\CLAUDE.md` + project `CLAUDE.md` / `CLAUDE.local.md` | Yes. They are joined, and the project's file is read last |
| Project `.claude/settings.json`, `.claude/skills`, `.claude/agents`, `.claude/rules`, `.mcp.json` | Yes |
| Root `.claude/` (settings, skills, agents) | **No.** It doesn't load inside a project, which is why shared items live in the plugin |
| `workspace-core` plugin | Yes. It is installed at user scope and also enabled in each project's settings |
| `~/.claude/` (user CLAUDE.md, settings, skills, agents) | Yes, everywhere |

## Create a project
Either:
- start `claude` in `D:\claude_projects` and run `/new-project`, or
- run `powershell -ExecutionPolicy Bypass -File _scripts\new-project.ps1 -Name my-app -Description "What it does" -Stack "Python (uv)"`

Then `cd my-app` and run `claude`.

## Add shared skills and agents
Edit `_shared/plugins/workspace-core/`:
- skill: `skills/<name>/SKILL.md`
- agent: `agents/<name>.md`
- hooks: `hooks/hooks.json` (use PowerShell or Node commands, because this is Windows)

The marketplace is a local folder, so edits load in place. Run `/reload-plugins` or restart the session to pick them up. Shared items appear namespaced, for example `/workspace-core:handoff`.

To set this up on another machine (one time):
```
claude plugin marketplace add D:/claude_projects/_shared
claude plugin install workspace-core@claude-projects --scope user
```

## Put project-specific things in the project
- `my-app/.claude/skills/<name>/SKILL.md`: project skills (deploy, seed-db, ...)
- `my-app/.claude/agents/<name>.md`: project subagents
- `my-app/.claude/rules/*.md`: rules, optionally scoped with `paths:` frontmatter
- `my-app/CLAUDE.local.md`: personal notes (gitignored)

## Git
The root is a git repo that tracks only the shared setup. Its `.gitignore` excludes every project folder. Each project has its own repo, created by `new-project.ps1`. A project must be a git repo; otherwise Claude treats the root as its repo root.
