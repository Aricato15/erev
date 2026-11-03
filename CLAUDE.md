# Workspace: claude_projects (this folder is the workspace root)

Each top-level folder that doesn't start with `_` is a separate project and its own git repo. This file is loaded in every project's sessions, so it holds only rules that apply everywhere. Rules for a single project go in that project's own `CLAUDE.md`.

## Layout
- `_shared/` is a local plugin marketplace. The `workspace-core` plugin holds the skills and agents shared across projects.
- `_templates/project/` is the starter that new projects are copied from.
- `_scripts/new-project.ps1` creates a project. When Claude is started at the root, use `/new-project` instead.
- `PROJECTS.md` lists every project. It is private and gitignored, so never commit it or un-ignore it. Its format is in `_templates/PROJECTS.md`, and `new-project.ps1` creates it from that template when it's missing.

## Working in a project
- Before making changes, read the project's `CLAUDE.md` and anything relevant in its `docs/`.
- Stay inside the current project folder. Don't edit sibling projects or `_shared/`/`_templates/` unless asked.
- If you learn something durable about a project (a build command, a gotcha, a convention), add it to that project's `CLAUDE.md`.
- Put specs and plans in `docs/`, and architecture decisions in `docs/decisions/NNNN-title.md`.

## Conventions
- Python: use `uv` (`uv init`, `uv add`, `uv run`). Don't use bare pip or a global python.
- Node: use the package manager the project's lockfile shows. Default to npm.
- Run the project's tests and linters before saying work is done. Report failures as they are.
- Git: make small, focused commits and use Conventional Commits: `type(scope): description`, where the type is one of `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `build`, `ci`, `chore` or `revert`. Write the description in the imperative and lowercase, e.g. `feat(auth): add login form validation`. Never commit secrets or `.env` files.
- To commit, use `/workspace-core:commit`. It reviews the staged changes, proposes a message and asks before committing. The full convention is in `_shared/plugins/workspace-core/skills/commit/references/conventional-commits.md`.
- Shell: this is Windows. Prefer cross-platform scripts (Node/Python) or PowerShell over bash-only tooling in project scripts.
