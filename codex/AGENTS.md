# AGENTS.md — Codex Agent Operating Guidelines

> This file should contain only static rules that are always applicable. Project-specific and changeable information must be stored separately in `memory/project_*.md`.

## 0. Scope
- Applies to: All Codex sessions running on the host.
- Priority order: Direct user instructions > This file > Skill / plugin defaults.

## 1. Tool Usage Rules
- Use `rg` for searching, `rg --files` for file listing, `apply_patch` for manual edits, and `update_plan` for task planning and progress management.
- Independent reading, searching, and verification tasks may be parallelized using `multi_tool_use.parallel`.
- Use sub-agents only when the user explicitly requests delegation or parallel execution.

## 2. Prohibited Actions
- Do not execute `git push --force`, `git reset --hard`, or `rm -rf` without explicit user approval.
- Do not bypass hooks using `--no-verify` or `--no-gpg-sign`.
- Do not read, edit, or commit `.env`, `credentials*`, `~/.aws/**`, `~/.ssh/**`, `*.pem`, or `*.key`.

## 3. Skills / Plugins
- Skill frontmatter must include: `description`, `inputs`, `outputs`, `side_effects`, and `permissions`.
- `permissions` must explicitly specify the required Codex tools, MCPs, and external commands, following the principle of least privilege.
- Enable MCPs and external tools only when necessary. Before performing network access, write operations, or destructive actions, confirm whether user approval is required.

## 4. Failure Loop Control
- Stop after two consecutive failures of the same command and report the situation.
- When a failure occurs:
  1. Identify the cause.
  2. Try one alternative tool or approach.
  3. If it still fails, ask the user how to proceed.
- Do not suppress errors with `try/catch` merely to avoid loop detection.

## 5. Permission Design
- Explicitly define `approval_policy` and `sandbox_mode` in `~/.codex/config.toml`.
- The default configuration should be `workspace-write` with approval required. Relax restrictions only for trusted projects.
- Do not rely solely on configuration files to protect sensitive paths; maintain the restrictions listed in this document as well.

## 6. Memory Hierarchy
- Short-term: Within the current conversation (plans/tasks). Do not write to `memory/`.
- Mid-term: `memory/project_*.md` for project- or sprint-level information.
- Long-term: `memory/user_*.md` and `memory/feedback_*.md` for persistent user preferences and feedback.
- `MEMORY.md` is for indexing only. Keep each line under 150 characters. Do not store dynamic information in this file.

## 7. Cache Optimization
- Place less frequently updated content near the top of this file (OpenAI prompt caching achieves better hit rates with stable prefixes).
- For operations involving waiting periods, batch work whenever possible instead of repeatedly polling at short intervals (to avoid wasting prompt-cache TTL).

## 8. Verification Loop
Do not report a task as complete until all of the following conditions are satisfied:

- [ ] `lint`, `typecheck`, and `test` pass for the relevant code (using project-defined commands).
- [ ] For UI changes, verify both the golden path and relevant edge cases in a browser.
- [ ] Logs and output contain no unexpected errors or warnings.
- [ ] If verification cannot be performed, explicitly state that the result is "unverified" and ask the user to make the final judgment.

> Type checking and tests verify code correctness, but they do not guarantee functional correctness.

## 9. Development Principles
For details, refer to the documents in `principles/`:
`development.md`, `error-handling.md`, `code-quality.md`, `testing.md`, `security.md`, `performance.md`, `git.md`, and `dependencies.md`.

<!-- headroom:rtk-instructions -->
# RTK (Rust Token Killer) - Token-Optimized Commands

When running shell commands, **always prefix with `rtk`**. This reduces context
usage by 60-90% with zero behavior change. If rtk has no filter for a command,
it passes through unchanged — so it is always safe to use.

## Key Commands
```bash
# Git (59-80% savings)
rtk git status          rtk git diff            rtk git log

# Files & Search (60-75% savings)
rtk ls <path>           rtk read <file>         rtk grep <pattern>
rtk find <pattern>      rtk diff <file>

# Test (90-99% savings) — shows failures only
rtk pytest tests/       rtk cargo test          rtk test <cmd>

# Build & Lint (80-90% savings) — shows errors only
rtk tsc                 rtk lint                rtk cargo build
rtk prettier --check    rtk mypy                rtk ruff check

# Analysis (70-90% savings)
rtk err <cmd>           rtk log <file>          rtk json <file>
rtk summary <cmd>       rtk deps                rtk env

# GitHub (26-87% savings)
rtk gh pr view <n>      rtk gh run list         rtk gh issue list

# Infrastructure (85% savings)
rtk docker ps           rtk kubectl get         rtk docker logs <c>

# Package managers (70-90% savings)
rtk pip list            rtk pnpm install        rtk npm run <script>
```

## Rules
- In command chains, prefix each segment: `rtk git add . && rtk git commit -m "msg"`
- For debugging, use raw command without rtk prefix
- `rtk proxy <cmd>` runs command without filtering but tracks usage
<!-- /headroom:rtk-instructions -->
