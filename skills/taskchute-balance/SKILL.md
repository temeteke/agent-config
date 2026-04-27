---
name: taskchute-balance
description: Rebalance TaskChute tasks across sections based on estimated time, keeping sections evenly distributed and avoiding the early morning (00:00-03:00) section when possible. Use when the user wants to redistribute tasks from overfilled sections, move Uncategorized tasks, or balance the day's schedule.
---

# TaskChute Balance

## Workflow

1. Determine the target date (default: today).
2. Load the full day schedule with `get_taskchute`.
3. Calculate the total estimated duration for each section.
4. Identify sections that are overloaded (significantly more total time than others) and sections that are empty or underloaded.
5. Plan redistribution:
   - Move Uncategorized tasks to appropriate time-based sections.
   - Move tasks from overloaded sections to underloaded ones.
   - Prioritize sections based on the current time (schedule tasks in upcoming sections, not past ones).
   - Avoid assigning tasks to the early morning section (00:00-03:00) unless absolutely necessary.
   - Use task characteristics (Mode ID, task name keywords, project) to infer the best section.
6. Present a summary to the user:
   - List tasks to move and their target sections with reasons.
   - Show the before/after estimated time per section.
   - Ask for explicit confirmation before proceeding.
7. If approved, execute via `update_task` (adjust `section_id`, `timeline_date`, and `scheduled_date_time`).
8. Re-fetch the schedule with `get_taskchute` and report the new distribution.

## Rules

- **Balance by total estimated time**, not task count.
- **Avoid the early morning section** (00:00-03:00). Only use it as a last resort if other sections cannot accommodate the tasks.
- **Respect the current time**: Do not schedule tasks in sections that have already passed unless explicitly requested.
- **Never move Done or In Progress tasks** unless the user explicitly asks.
- **Keep routine tasks (`rtn_`) in their original section** if possible; move manual tasks (`task_`) first.
- **Always ask for confirmation** before moving. Show exact task names, IDs, and target sections.
- **Move tasks individually** with `update_task` to avoid version conflicts.

## Output Style

- Discovery: "Section X has Y hours, Section Z has 0 hours..."
- Proposal: "I will move [task name] to [section] at [time] because [reason]..."
- Confirmation prompt: "Approve these N moves? (yes/no)"
- After execution: "Redistributed N tasks. New section totals: ..."
