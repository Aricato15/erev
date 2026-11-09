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
- Contained environments: every project keeps its environment and dependencies inside its own folder, whatever the stack. Never install a project's dependencies globally, into the workspace root or into a sibling project. Shared download caches (uv's cache, npm's cache) are fine, because they aren't environments.
  - Python: use `uv` (`uv init`, `uv add`, `uv run`). The venv is `.venv/`, next to the project's `pyproject.toml`, and `uv sync` creates it. Pin the version with `uv python pin <version>` and commit `.python-version`. Don't use bare pip, `pip install --user`, `python -m venv` or a global python.
  - Node: use the package manager the project's lockfile shows. Default to npm. `node_modules/` sits next to the project's `package.json` (in a frontend subfolder, if that's where it is). Run tools through npm scripts or `npx`, never `npm install -g`. Commit the lockfile.
  - Other stacks: use the toolchain's project-local mode. If the toolchain only supports a global location, write that under Gotchas in the project's `CLAUDE.md`.
  - The project's `.gitignore` must cover its environment folders.
- Server ports: every server a project runs, including dev servers, must listen on a port in the range for its category:

  | Category | Port range |
  |---|---|
  | API Gateway | 20060–20099 |
  | Core APIs | 20100–20149 |
  | Business APIs | 20230–20299 |
  | AI / Agent APIs | 20300–20399 |
  | Background services | 20400–20479 |
  | Infrastructure utilities | 20500–20599 |
  | Future expansion | 20700–20799 |

  Ports outside these ranges aren't allocated (20150–20229, 20480–20499 and 20600–20699 are gaps), so don't use them. Before picking a port, check `PROJECTS.md` and the other projects so you don't reuse one. Put the chosen port in config or `.env`, not hard-coded, and record it in the project's `CLAUDE.md`.
- Run the project's tests and linters before saying work is done. Report failures as they are.
- Git: make small, focused commits and use Conventional Commits: `type(scope): description`, where the type is one of `feat`, `fix`, `refactor`, `perf`, `docs`, `style`, `test`, `build`, `ci`, `chore` or `revert`. Write the description in the imperative and lowercase, e.g. `feat(auth): add login form validation`. Never commit secrets or `.env` files.
- To commit, use `/workspace-core:commit`. It reviews the staged changes, proposes a message and asks before committing. The full convention is in `_shared/plugins/workspace-core/skills/commit/references/conventional-commits.md`.
- Shell: this is Windows. Prefer cross-platform scripts (Node/Python) or PowerShell over bash-only tooling in project scripts.
