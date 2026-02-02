---
name: php-security-reviewer
description: Review PHP repositories for security risks in SQLi, XSS, CSRF, and other vulnerabilities. Use when asked to audit PHP code without modifying files and produce a bilingual (English/Japanese) findings report formatted like a git repository comment.
---

# PHP Security Reviewer

## Overview
Analyze PHP code for SQL injection, XSS, CSRF, and other common vulnerabilities. Report findings only, do not modify files. If `phpstan.neon` exists, run PHPStan and include results. Output a concise bilingual report (English then Japanese) using the provided templates.

## Workflow

### 1) Establish scope
- Confirm target directories and flows (front-end, admin, API) from the user or repo structure.
- If not specified, focus on public entry points (e.g., `www/`, `public/`, `htdocs/`).

### 2) Run PHPStan when configured
- If `phpstan.neon` exists at the repo root, run PHPStan and include results in the report.
- Prefer `./vendor/bin/phpstan analyse -c phpstan.neon` from repo root.
- If the binary is not present, try `phpstan analyse -c phpstan.neon`.
- If PHPStan cannot run, report the failure reason and skip the section details.

### 3) Scan for risk signals
Use targeted searches to find relevant patterns. Examples:
- SQLi: `mysqli_query`, `PDO->query`, `PDO->exec`, `mysql_query`, `->prepare`, string concatenation with inputs
- Input sources: `$_GET`, `$_POST`, `$_REQUEST`, `$_COOKIE`, `$_SERVER`
- Output sinks: `echo`, `print`, `printf`, `<?=`, templating outputs
- CSRF: `csrf` token generation/validation, hidden inputs, framework helpers
- Other: `move_uploaded_file`, `file_get_contents`, `readfile`, `fopen`, `curl_*`, `exec`, `system`, `shell_exec`, `header('Location:')`

### 4) Analyze each viewpoint
- **SQLi**: Verify all query executions use prepared statements or safe ORM bindings. Flag string-built SQL with user input.
- **XSS**: Verify output encoding for any user-controlled data. Identify missing `htmlspecialchars`/equivalent or trusted sanitizers.
- **CSRF**: Verify form flows include token generation and validation. Flag missing or inconsistent enforcement.
- **Other**: Report only evidence-based issues (upload handling, path traversal, command injection, SSRF, open redirect, auth/session misuse).

### 5) Produce bilingual report
- Use `assets/report-template-en.md` and `assets/report-template-ja.md`.
- Write English first, then Japanese.
- Add a "Remediation Guidance" section before "Findings" when issues exist.
- Add a "PHPStan Results" section after "Findings" when PHPStan was run.
- In Remediation Guidance, summarize each issue with severity and list locations, then provide a short, concrete fix direction or clarifying question.
- Cite files as `path:line` and include brief context in parentheses.
- If no issues found, state that clearly and still list checked paths.
- Do not propose code changes or patches.

## Assets
- `assets/report-template-en.md`: English report template
- `assets/report-template-ja.md`: Japanese report template
