---
name: phpdoc-adder
description: Add PSR-5 PHPDoc blocks to PHP functions when missing. Use for PHP projects to add @param, @return, and @throws tags while preserving any existing PHPDoc blocks and skipping vendor libraries.
---

# PHPDoc Adder

## Overview
Add PSR-5 style PHPDoc blocks to all functions and methods that lack a docblock. Do not modify existing PHPDoc. Skip any files under `/vendor`.

## Workflow

### 1) Confirm PHP project and scope
- Verify the project is PHP (e.g., `composer.json`, `*.php`, `phpunit.xml`, `phpstan.neon`).
- Define scope as all PHP files excluding `/vendor`.

### 2) Locate functions missing PHPDoc
- Search for function and method declarations without a preceding `/** ... */` block.
- Include: global functions, class methods (public/protected/private), and trait methods.
- Exclude: anonymous functions/closures unless explicitly requested.

### 3) Generate PSR-5 compliant PHPDoc
- Keep existing PHPDoc blocks unchanged.
- Always include:
  - `@param` for each parameter
  - `@return` for return value
  - `@throws` when the function can raise exceptions (based on code evidence)
- Summary line: short, verb-led description (e.g., "Fetch user profile by id.").
- Types: infer from type hints, PHP 8 union types, default values, or usage. Use `mixed` only when no evidence is available.
- Nullable: use `?Type` or `Type|null` consistent with signature.
- Void: use `void` when there is no return value.

### 4) Apply edits safely
- Insert the docblock directly above the function signature.
- Preserve existing indentation and formatting.
- Do not change code behavior.

## Assets
- `assets/phpdoc-template.md`: PHPDoc template snippet
