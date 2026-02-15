---
name: project-readme-refresher
description: Analyze a project repository and refresh or create README.md (English) plus README_ja.md or documents/README.md (Japanese) using provided templates and evidence from code/config. Use for README audits, rewrite requests, or when existing README content may be copied from another project.
---

# Project Readme Refresher

## Overview
Analyze a repository and update or create English and Japanese READMEs based on verified project facts, not assumptions. Use the bundled templates to keep structure and tone consistent.

## Workflow

### 1) Gather project facts
- Identify the repo root (current working directory or git root).
- Inspect key config and entry files (examples: package.json, composer.json, pyproject.toml, go.mod, Gemfile, Makefile, docker-compose.yml, .env.example, CI config).
- Map the runtime, local dev commands, build/test steps, deployment flow, and key paths.
- Prefer evidence from code/config over prior documentation.

### 2) Infer project name and validate existing README
- Infer the project name from the repo root directory basename.
- Extract the README project name from the first H1 (or first non-empty line if no H1).
- Normalize both names: lowercase, remove non-alphanumeric characters.
- If the names do not match, treat the README as copied. Do not reuse any of its content for the rewrite (English or Japanese). Use only project analysis and templates.

### 3) Update English README.md
- Use `assets/README.md` as the template for structure and tone.
- If README.md exists and is not copied, update it with current facts and keep accurate sections.
- If README.md is copied or missing, generate a new one from the template.
- Do not speculate. Include only facts confirmed from the repository.
- Omit sections that cannot be supported by evidence.

### 4) Update Japanese README
- Prefer `README_ja.md` if it exists. Otherwise use `documents/README.md`.
- If neither exists, create `README_ja.md` at the repo root.
- Use `assets/README_ja.md` as the template.
- Keep the Japanese README aligned with the English content (same facts and structure), translated appropriately.
- If the `textlint` command is available, run `textlint {文章ファイル}` for the Japanese README and revise wording/style based on findings.
- After running `textlint`, if a rule requires bullet points to use the "dearu" style, you may ignore that specific finding when the entire document is consistently written in either "desu/masu" or "da/dearu" style.

### 5) Final checks
- Verify that paths, commands, ports, and environment variables exist in the repo.
- Keep bullet list style and headings consistent with the templates.
- Ensure English and Japanese READMEs describe the same facts.

## Assets
- `assets/README.md`: English README template (from this project)
- `assets/README_ja.md`: Japanese README template (from this project)
