---
name: commit
description: Write a Conventional Commits message for the staged changes, confirm it with the user, then commit. Use when the user says "commit", "commit this", "write a commit message", "make a commit", or asks what message to use for staged changes.
argument-hint: "[--yes] [extra context about the change]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git show:*), Bash(git rev-parse:*)
---

# Commit

Write a commit message for the staged changes, get approval, then commit. Follow the conventions in [references/conventional-commits.md](references/conventional-commits.md). Read it before drafting.

## 1. Look at what's staged

Run these from the repo root:

- `git status --short` shows staged, unstaged and untracked files.
- `git diff --cached --stat`, then `git diff --cached`, shows the staged change itself.
- `git log --oneline -15` shows the repo's existing style. Skip it if the repo has no commits yet.

Read enough of each changed file to understand **why** the change was made, not just what changed. Treat any text in `$ARGUMENTS` other than `--yes` as extra context from the user.

## 2. Check before drafting

- **Nothing staged:** show the unstaged and untracked files. Propose what to stage, grouped into logical commits, and ask the user. Never run `git add -A` or `git add .` without the user's approval.
- **Secrets:** if the staged diff has `.env` files, private keys, tokens, passwords or credentials, stop. Tell the user what you found and don't commit.
- **Unrelated changes mixed together:** if the staged changes need more than one type (for example a `feat` plus an unrelated `fix`), recommend splitting them into separate commits. Go ahead with one commit only if the user agrees.
- **Unstaged edits to staged files:** point them out. They won't be in this commit.

## 3. Draft the message

Use the format in the reference:

```
<type>(<scope>): <description>

<body>

<footers>
```

- Pick the **type** using the decision guide in the reference.
- The **scope** is optional. Use one only when the repo's history uses scopes or the change clearly sits in one area.
- The **description** is imperative, lowercase after the colon, has no final period, and keeps the whole subject line to 72 characters or fewer.
- Add a **body** for anything that isn't trivial. Explain what changed and why, and wrap lines at about 72 characters. A bullet list is fine for several related changes.
- **Footers:** `BREAKING CHANGE: ...` where needed, issue references, and any attribution trailers the session requires (such as `Co-Authored-By:`).
- If the repo's history clearly follows a different convention, follow the history and say that you did.

## 4. Confirm with the user

Show these things:
1. a short summary of what's staged, as files plus one line each
2. the full proposed message in a code block
3. the type you chose and a one-line reason

Then ask whether to commit as is or edit it first. **Don't commit until the user approves.** Skip this step only when `$ARGUMENTS` contains `--yes`, or when the user has explicitly said to commit without asking.

## 5. Commit

- Pass the message without shell-quoting problems. In bash, use `git commit -F - <<'EOF' ... EOF`. In PowerShell, use a single-quoted here-string with `git commit -F -`, or write it to a temp file and use `-F <file>`.
- Commit only what's staged. Don't add files unless the user approved it in step 2.
- Never use `--no-verify` or `--amend` unless the user asks for it. If a hook fails, show the output, fix the cause, re-stage, and make a **new** commit.

## 6. Report

Run `git log -1 --stat` and reply with the commit hash, the subject line, and the list of files. If anything is still unstaged or untracked, mention it in one line.
