# CLAUDE.md — Agent Operation Guidelines

> Describe only static rules that are always referenced. Project-specific mutable
> information must be separated into `memory/project_*.md`.

---

## 0. Scope
- Target: every Claude Code session launched on the host
- Priority: direct user instruction > project-root `CLAUDE.md` > this file > Skills / plugin defaults

---

## 1. Tool Usage Rules
### Always use
- Reading files: `Read` / Searching: `Grep` / Listing: `Glob` (do not call `cat` / `grep` / `find` via Bash)
- Plan management: `TaskCreate`; long-running processes: `run_in_background`

### May use (conditionally)
- `Bash`: shell-specific processing only. Prohibited for reading, searching, and editing
- `Agent`: investigations of 3 or more queries, or independent parallel tasks

### Prohibited
- Do not run `git push --force` / `git reset --hard` / `rm -rf` without explicit user approval
- Do not bypass hooks with `--no-verify` / `--no-gpg-sign`
- Do not read, edit, or commit `.env` / `credentials*` / `~/.aws/**` / `~/.ssh/**` / `*.pem` / `*.key`.

---

## 2. Tool Contracts (Skills / Slash Commands)
### When adding a custom Skill
Include the following in every Skill's frontmatter:
- `description`: state the trigger conditions in terms of "when to use / when not to use"
- `inputs`: expected arguments and their types
- `outputs`: format of the returned artifacts
- `side_effects`: write destinations and whether external communication occurs
- `permissions`: the required `allowed-tools`

### Slash Command
- `allowed-tools` is mandatory (least privilege)
- `description`: state the trigger condition in a single line

---

## 3. Failure Loop Control
- Stop after **2 consecutive failures** of the same command and report to the user
- On failure: identify the root cause → try one alternative tool/approach → if it still fails, defer to the user's judgment
- Do not swallow errors with `try/catch` for the purpose of loop suppression (report confirmed facts and unconfirmed items separately)

---

## 4. Permission Design
- In `.claude/settings.json`, define **Deny first, Allow after**
- Explicitly list sensitive paths (`**/.env*`, `**/credentials*`, `~/.aws/**`, `~/.ssh/**`, `**/*.pem`, `**/*.key`) under **Deny**
- Assume `defaultMode: acceptEdits`. Edit / Write are auto-approved within the sandbox
- Pre-approve read-only commands (`git status`, `ls`, `pwd`, etc.) under Allow
- Do not place Bash write/network/destructive operations or external-service operations under Allow; approve them case by case
- List irreversible operations such as `git push --force` / `git reset --hard` / `rm -rf` under Deny, and also block their bypass routes (`rmdir`, `find -delete`, `gh * close/delete`, `git branch -D`, etc.)

---

## 5. Memory Hierarchy
The actual store is `~/.claude/projects/<project-slug>/memory/` (auto-memory system, per project).
- Short-term: within this conversation (plan / tasks) — do not write to `memory/`
- Mid-term: `memory/project_*.md` — state at the project/sprint level
- Long-term: `memory/user_*.md` / `memory/feedback_*.md` — user profile and persistent feedback
- Reference: `memory/reference_*.md` — pointers to external systems (Linear / Slack / Grafana, etc.)
- `MEMORY.md` is index-only, max 150 characters per line (truncate beyond 200 lines)
- Do **not** write dynamic information in this file (dates, names, in-progress tasks, etc.)

---

## 6. Cache Optimization
- Place items with lower update frequency higher up in this file
- For `ScheduleWakeup`, choose a `delaySeconds` of 270s or less, or 1200s or more (around 5 minutes only produces cache misses)

---

## 7. Verification Loop
Do not report a task as "complete" until all of the following are satisfied:
- [ ] `lint` / `typecheck` / `test` for the relevant code passes (the project's prescribed commands)
- [ ] For UI changes, verify the golden path plus edge cases by operating them in a browser
- [ ] No unexpected errors or warnings appear in the logs / output
- [ ] If verification is not possible, explicitly state "unverified" and defer to the user's judgment

> Type checks and tests confirm the correctness of the code, not the correctness of the feature.

---

## 8. Development Principles
For details, see under `principles/`: `development.md` / `error-handling.md` / `code-quality.md` / `testing.md` / `security.md` / `performance.md` / `git.md` / `dependencies.md`

@RTK.md