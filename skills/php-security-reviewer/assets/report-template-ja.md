# PHP Security Review Report（<SCOPE_LABEL>）

## Scope and Method
- 対象: <SCOPE>
- 目的: 指定観点（SQLi/XSS/CSRF/Other）に限定して指摘を列挙
- 注記: コード変更は行っていません

## 修正ガイダンス（問題がある場合）
- **<SEVERITY>:** <ISSUE_SUMMARY>
  対象箇所:
  - <PATH:LINE>
  - <PATH:LINE>
  確認/推奨: <GUIDANCE_OR_QUESTION>

## Findings

### 1) SQL Injection（プリペアドステートメント）
- **Status**: <SUMMARY>
- **Checked query paths**:
  - <PATH:LINE>（<DETAILS>）

### 2) XSS（入力/出力ハンドリング）
- **Status**: <SUMMARY>
- **Issue**: <IF_ANY>
- **Locations**:
  - <PATH:LINE>（<DETAILS>）

### 3) CSRF（トークン検証）
- **Status**: <SUMMARY>
- **Locations**:
  - <PATH:LINE>

### 4) Other Vulnerabilities
- **Status**: <SUMMARY>
- **Issue**: <IF_ANY>
- **Locations**:
  - <PATH:LINE>（<DETAILS>）

## PHPStan 結果（phpstan.neon がある場合）
- **Status**: <RUN_STATUS>
- **Command**: <COMMAND>
- **Summary**: <SUMMARY>
- **Top issues**:
  - <ISSUE>
  - <ISSUE>
