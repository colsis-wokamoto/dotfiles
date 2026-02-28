# Backlog Operations Reference

## Common Retrieval Patterns

### 1) My open tasks (due date order)

- `assigneeId: [636482]`
- `statusId: [1,2,3]`
- `sort: "dueDate"`
- `order: "asc"`

### 2) Count first, then page

1. Use `backlog_count_issues` with the same filter.
2. If results are long/truncated, use `backlog_get_issues` with:
   - `count: 5` (or 10)
   - `offset: 0, 5, 10...`
3. Merge and reformat before reporting.

### 3) Untriaged only

- Use `statusId: [1]` for 未対応 only.

## Comment Flow

1. Draft comment text in Japanese.
2. Ask for confirmation.
3. Post only after explicit approval with `backlog_add_issue_comment`.

## Close Flow

1. Update target issue with `backlog_update_issue`.
2. Set `statusId: 4` (完了).
3. Optional close comment example:
   - `本件は一旦クローズします。必要時に再オープンで対応します。`
4. Refresh open-task list and report the new total.

## Output Formatting

- Preferred list fields:
  - due date (`未設定` if null)
  - issue key
  - title (`summary`)
  - status
- For user requests like `タイトルも`, always include `summary`.
