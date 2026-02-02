---
name: jsdoc-adder
description: Add ESLint-recommended JSDoc blocks to JavaScript functions when missing. Use for JS projects to add @param, @returns, and @throws tags while preserving any existing JSDoc blocks and skipping node_modules.
---

# JSDoc Adder

## Overview
Add ESLint-style JSDoc blocks to all JavaScript functions and methods that lack a docblock. Do not modify existing JSDoc. Skip any files under `/node_modules`.

## Workflow

### 1) Confirm JavaScript project and scope
- Verify the project is JavaScript (e.g., `package.json`, `*.js`, `*.mjs`, `*.cjs`).
- Define scope as all JS files excluding `/node_modules`.

### 2) Locate functions missing JSDoc
- Search for function and method declarations without a preceding `/** ... */` block.
- Include: function declarations, function expressions assigned to const/let, class methods, object methods, and exported functions.
- Exclude: anonymous callbacks unless explicitly requested.

### 3) Generate ESLint-style JSDoc
- Keep existing JSDoc blocks unchanged.
- Always include:
  - `@param` for each parameter
  - `@returns` for return value
  - `@throws` when the function can throw (based on code evidence)
- Summary line: short, verb-led description (e.g., "Fetch user profile by id.").
- Types: infer from TypeScript annotations (if any), JSDoc hints, default values, or usage. Use `*` only when no evidence is available.
- Optional params: use `name?` or `name=` per existing style; keep consistent within a file.
- Void: use `void` when there is no return value.

### 4) Apply edits safely
- Insert the docblock directly above the function signature.
- Preserve existing indentation and formatting.
- Do not change code behavior.

## Assets
- `assets/jsdoc-template.md`: JSDoc template snippet
