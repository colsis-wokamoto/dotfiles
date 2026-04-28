---
name: git-repository-guidelines
description: Create or update Git repository operation rules (branch model, PR workflow, CI/CD deploy triggers, merge authority, prohibitions). Use when asked to define or standardize Git branching strategy, release workflow, CI/CD auto-deploy rules, or PR/merge policies for a project.
---

# Git Repository Guidelines

## Overview

Provide a concise, reusable baseline for Git repository governance and deployment rules, then tailor it to the project context.

## Workflow

1. Confirm project context: hosting platform (GitHub/GitLab), environment names, and role definitions (e.g., Maintainer).
2. Load the baseline template in `references/git-repository-guidelines.md`.
3. Customize branch names, default branch, CI/CD triggers, review/merge authority, and prohibitions.
4. Output the rules in the requested format/location (markdown, rules file, or internal docs).

## Output Guidance

- Prefer clear sectioning and a branch table for quick scanning.
- Keep policy statements explicit (what is allowed vs. prohibited).
- Do not implement CI/CD configs unless explicitly requested.

## References

- `references/git-repository-guidelines.md` (baseline template)
