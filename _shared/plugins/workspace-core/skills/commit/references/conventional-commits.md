# Commit message practices: Conventional Commits 1.0

Spec: https://www.conventionalcommits.org/en/v1.0.0/. Tools such as commitlint, semantic-release and changelog generators read this format.

## Format

```
<type>(<optional scope>)<optional !>: <description>

<optional body>

<optional footer(s)>
```

Example:

```
fix(auth): refresh token before it expires

Requests made in the last 30s of a token's life failed with 401
because the refresh check used `>` instead of `>=`.

Refs #142
```

## Types

| Type | Use for | Example subject |
|---|---|---|
| `feat` | A new feature or capability for the user | `feat(cart): add discount code field` |
| `fix` | A bug fix | `fix: prevent crash on empty search` |
| `refactor` | Restructuring code without changing behavior | `refactor(api): extract request retry helper` |
| `perf` | A performance improvement | `perf: memoize price table lookups` |
| `docs` | Documentation only (README, comments, docs/) | `docs: document deploy steps` |
| `style` | Formatting or whitespace, no logic change | `style: apply prettier to src/` |
| `test` | Adding or fixing tests only | `test(cart): cover zero-quantity case` |
| `build` | The build system, dependencies or packaging | `build: bump vite to 6.1` |
| `ci` | CI/CD configuration | `ci: cache npm in GitHub Actions` |
| `chore` | Maintenance and tooling that doesn't touch app source or tests | `chore: update .gitignore` |
| `revert` | Reverting an earlier commit | `revert: feat(cart): add discount code field` |

"Review", "WIP" and "misc" are **not** types. Changes that come out of a code review are `fix` or `refactor`, and the body can mention the review.

## Choosing the type

Ask these questions in order and use the first one that's true:

1. Does it undo an earlier commit? Use `revert`.
2. Does it fix wrong behavior? Use `fix`.
3. Does it add behavior a user or caller can see? Use `feat`.
4. Is it faster with the same behavior? Use `perf`.
5. Is it restructured code with the same behavior? Use `refactor`.
6. Does it touch only tests? Use `test`. Only docs? Use `docs`. Only formatting? Use `style`.
7. Does it touch only build, dependencies or packaging? Use `build`. Only CI? Use `ci`.
8. For anything else, such as config, tooling, repo setup or housekeeping, use `chore`.

If two answers are true, the commit probably holds two changes. Prefer splitting it.

## Subject line rules

- Use the imperative mood: "add", "fix", "remove", not "added" or "adds".
- Start with a lowercase letter after the colon, and don't end with a period.
- Keep the whole line to 72 characters or fewer, and aim for about 50.
- Say what the change does, not how you did it. Avoid vague subjects like `fix: bug fixes` or `chore: updates`.

## Scope

- This is optional. It's a noun in parentheses that names the area: `feat(parser):`, `fix(ui):`, `build(deps):`.
- Use the scopes the repo already uses (check `git log`). Don't invent a new scope for every commit.

## Body

- Leave a blank line after the subject, and wrap lines at about 72 characters.
- Explain **what** changed and **why**. The diff already shows how.
- Bullets are fine when a commit makes several related changes.

## Footers

- `BREAKING CHANGE: <what breaks and how to migrate>` marks a breaking change. You can also mark it with `!` in the subject, e.g. `feat(api)!: drop v1 endpoints`.
- References: `Refs #123`, `Closes #123`.
- Trailers: `Co-Authored-By: Name <email>`, `Reviewed-by: ...`.

## Good habits

- One logical change per commit, so it's easy to review and revert.
- Never commit secrets, `.env` files or build output.
- If you're unsure between `feat` and `chore` for setup work: `feat` is for something new for the user or caller, and `chore` is for setup, tooling or housekeeping.

## Alternative: Gitmoji

Some teams put an emoji in front instead of a word: `✨ add login`, `🐛 fix crash`, `♻️ refactor parser`. Use it only when the repo's history already does.
