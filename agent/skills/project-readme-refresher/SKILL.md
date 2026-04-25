---
name: project-readme-refresher
description: Analyze a project repository and refresh or create bilingual READMEs using provided templates and evidence from code/config. By default use README.md (English) plus README_ja.md or documents/README.md (Japanese); when an existing README.md is written in Japanese, keep README.md Japanese and create/update README_en.md for English. Use for README audits, rewrite requests, or when existing README content may be copied from another project.
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

### 3) Determine README language layout
- Check whether an existing `README.md` is primarily written in Japanese.
- If `README.md` is Japanese, use this layout:
  - Japanese: `README.md`
  - English: `README_en.md`
- Otherwise, use the default layout:
  - English: `README.md`
  - Japanese: `README_ja.md` if it exists, otherwise `documents/README.md`; if neither exists, create `README_ja.md` at the repo root.

### 4) Update English README
- Use `assets/README.md` as the template for structure and tone.
- Write English content to the English README path selected in step 3.
- If the English README exists and is not copied, update it with current facts and keep accurate sections.
- If the English README is copied or missing, generate a new one from the template.
- Do not speculate. Include only facts confirmed from the repository.
- Omit sections that cannot be supported by evidence.

### 5) Update Japanese README
- Use `assets/README_ja.md` as the template.
- Write Japanese content to the Japanese README path selected in step 3.
- Keep the Japanese README aligned with the English content (same facts and structure), translated appropriately.
- If the `textlint` command is available, run `textlint {文章ファイル}` for the Japanese README and revise wording/style based on findings.
- After running `textlint`, if a rule requires bullet points to use the "dearu" style, you may ignore that specific finding when the entire document is consistently written in either "desu/masu" or "da/dearu" style.

### 6) Final checks
- Verify that paths, commands, ports, and environment variables exist in the repo.
- Keep bullet list style and headings consistent with the templates.
- Ensure English and Japanese READMEs describe the same facts.

## Assets
- `assets/README.md`: English README template (from this project)
- `assets/README_ja.md`: Japanese README template (from this project)
