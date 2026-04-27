---
name: taskchute-deduplicate
description: Detect and remove duplicate tasks across an entire day's TaskChute schedule, keeping only one instance per task name and prioritizing routine-generated tasks (rtn_) over manually created ones (task_). Use when the user wants to clean up duplicate tasks, remove redundant manual tasks that overlap with routines, or deduplicate a day's schedule.
---

# TaskChute Deduplicate

## Workflow

1. Determine the target date (default: today in YYYY-MM-DD format, inferred from the user's context or current date).
2. Load the full day schedule with `get_taskchute` for that date.
3. Group all tasks by **task name** across the **entire day** (ignore section boundaries).
4. For each group with 2+ tasks:
   - If any task ID starts with `rtn_`, keep the **first** `rtn_` found and mark the rest for deletion.
   - If no `rtn_` exists, keep the **first** task found and mark the rest for deletion.
   - Skip any task whose status is `Done` or `In Progress` (never delete active/completed tasks).
5. Present a summary to the user:
   - List each duplicate task name and how many extra copies will be removed.
   - State the total number of tasks to delete.
   - Ask for explicit confirmation before proceeding.
6. If approved, execute deletion via `batch_tasks` in chunks of 25 or fewer.
7. Re-fetch the schedule with `get_taskchute` and report how many duplicates remain (should be zero).

## Rules

- **Scope is the entire day**, not per-section. Only one task with a given name may remain on the target date.
- **Always prioritize `rtn_`**. If a duplicate group contains both `rtn_*` and `task_*` IDs, all `task_*` copies are deleted and one `rtn_*` is kept.
- **Never delete `Done` or `In Progress` tasks**, even if they are duplicates.
- **Always ask for confirmation** before deleting. Show the user the exact list of IDs and names that will be removed.
- **Chunk deletes** into batches of <= 25 tasks to avoid API errors.
- If zero duplicates are found, report that immediately and stop.

## Output Style

- Discovery: "Found N duplicate groups across the day..."
- Confirmation prompt: "I will delete M tasks. Here is the list: ... Do you want to proceed?"
- After execution: "Deleted M tasks. Verified: schedule now has zero duplicates for [date]."
