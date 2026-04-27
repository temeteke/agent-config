---
name: taskchute-rollover
description: Inspect, rank, confirm, and move TaskChute tasks to another day. Use when the user asks to review today's schedule, find rollover candidates, balance sections, remove overload, or shift tasks to a later date.
---

# Taskchute Rollover

## Workflow

Use this skill in three passes:

1. Use this skill for rollover analysis; use `taskchute-update` for non-rollover edits.
2. Extract the current day with `get_taskchute`.
3. Identify rollover candidates using the user's stated goal, such as:
   - long focus-mode tasks
   - tasks that overload the day or a section
   - duplicates
   - low-priority or easily delayed work
   - tasks the user explicitly marks for moving
4. Present a short candidate list with reasons and wait for confirmation when the intent is not already clear.
5. After approval, move tasks with `update_task` or `batch_tasks`.
6. Re-check the schedule and verify that the target day now contains the moved items.

## Rules

- Keep tasks the user explicitly asked to retain.
- Do not move `Done` or `In Progress` items unless the user asks.
- Prefer moving focus-mode tasks that are long, optional, or create schedule overflow.
- When a task has both `timeline_date` and `scheduled_date_time`, keep them aligned.
- Use UTC `Z` timestamps when setting `scheduled_date_time`.
- For date moves, update both `timeline_date` and `scheduled_date_time` in the same call when the task already has a time.
- If a move does not appear in the schedule, re-check the task node and retry with the original time converted to UTC `Z`.
- After a batch move, verify both the source day and target day so no task is left behind.
- If the target day is not explicit, infer the next Saturday only when the user asks for "next Saturday" or similar.
- If multiple tasks share the same name, treat them as separate items and move only the requested IDs.

## Output Style

Keep responses compact:

- list the candidates
- state why they should roll over
- list the target day
- then execute only after approval
