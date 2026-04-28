---
name: conventional-commit-message
description: Generate git commit messages that follow the Conventional Commits specification. Use when asked to draft, fix, or standardize commit messages, choose an appropriate type/scope/breaking marker, or summarize staged or working-tree changes into a Conventional Commit message.
---

# Conventional Commit Message

## Overview

Generate clear, standardized git commit messages using the Conventional Commits format based on a summary of changes or repository diffs. Follow the specification at https://www.conventionalcommits.org/ja/v1.0.0/ and keep output concise and actionable.

## Workflow

1. Gather change context.
   - Prefer a user-provided summary of changes and intent.
   - If a repo is available, inspect diffs to avoid missing details:
     - `git status -sb`
     - `git diff --stat`
     - `git diff` or `git diff --cached` for staged changes
   - Ask for missing details: scope, breaking changes, and any issue/ticket references.

2. Choose type and scope.
   - Select the most accurate Conventional Commit type (see cheat sheet).
   - Use a short scope in parentheses if it meaningfully narrows the change (module, package, layer, or feature area).

3. Determine breaking changes.
   - If the change is incompatible, add `!` after type/scope and include a `BREAKING CHANGE:` footer describing the impact.

4. Write the commit message.
   - Format: `type(scope)!: subject`
   - Subject: imperative mood, concise, no trailing period.
   - Body: optional; use to explain "why" or key behavior changes.
   - Footers: optional; use `BREAKING CHANGE:` and any user-specified references.

## Type Selection Cheat Sheet

Use these defaults unless the user specifies otherwise:

- `feat`: new functionality
- `fix`: bug fix
- `docs`: documentation only
- `style`: formatting (no behavior change)
- `refactor`: code restructuring without behavior change
- `perf`: performance improvement
- `test`: tests only
- `build`: build system or dependencies
- `ci`: CI configuration or scripts
- `chore`: routine maintenance tasks
- `revert`: reverts a previous commit

## Output Rules

1. Default to a single best commit message.
2. If multiple types/scopes are plausible, return 2-3 options and ask the user to choose.
3. If essential context is missing (breaking change, scope, or intent), ask targeted questions before finalizing.
4. Output should be the commit message only (no extra commentary) unless the user explicitly requests rationale.
