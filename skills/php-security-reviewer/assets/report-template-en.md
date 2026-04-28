# PHP Security Review Report (<SCOPE_LABEL>)

## Scope and Method
- Scope: <SCOPE>
- Goal: List findings only based on the requested viewpoints (SQLi/XSS/CSRF/Other)
- Note: No code changes were made

## Remediation Guidance (if findings exist)
- **<SEVERITY>:** <ISSUE_SUMMARY>
  Locations:
  - <PATH:LINE>
  - <PATH:LINE>
  Question/Recommendation: <GUIDANCE_OR_QUESTION>

## Findings

### 1) SQL Injection (Prepared Statements)
- **Status**: <SUMMARY>
- **Checked query paths**:
  - <PATH:LINE> (<DETAILS>)

### 2) XSS (Input/Output Handling)
- **Status**: <SUMMARY>
- **Issue**: <IF_ANY>
- **Locations**:
  - <PATH:LINE> (<DETAILS>)

### 3) CSRF (Token Validation)
- **Status**: <SUMMARY>
- **Locations**:
  - <PATH:LINE>

### 4) Other Vulnerabilities
- **Status**: <SUMMARY>
- **Issue**: <IF_ANY>
- **Locations**:
  - <PATH:LINE> (<DETAILS>)

## PHPStan Results (if phpstan.neon exists)
- **Status**: <RUN_STATUS>
- **Command**: <COMMAND>
- **Summary**: <SUMMARY>
- **Top issues**:
  - <ISSUE>
  - <ISSUE>
