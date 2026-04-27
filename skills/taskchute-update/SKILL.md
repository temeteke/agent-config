---
name: taskchute-update
description: Update TaskChute tasks and related records. Use when the user asks to rename, reschedule, reprioritize, complete, reopen, comment on, or batch-edit tasks, or otherwise apply direct changes to TaskChute items.
---

# TaskChute Update

## Workflow

1. Load the target task or task set first with `get_nodes`, `get_taskchute`, or `search_documents` as needed.
2. Confirm the target IDs and any ambiguous dates or times before editing.
3. Use `update_task` for one task and `batch_tasks` for multiple tasks when the same change applies.
4. Keep `timeline_date` and `scheduled_date_time` aligned whenever a dated task moves.
5. Re-check the updated item with `get_nodes` or `get_taskchute` after writing.
6. Add comments with `create_comment` only when the user asked for notes, status updates, or extra context.

## Rules

- Never edit without a stable target ID.
- Preserve fields the user did not ask to change.
- When moving a timed task across days, use a UTC `Z` timestamp for `scheduled_date_time`.
- Use `end_date_time` only when marking completion or recording the finish time.
- Batch uniform edits when several tasks need the same change.
- Ask for clarification when the target date or time cannot be inferred safely.

## Output Style

- State what will change.
- Apply the update.
- Verify the result.
