## Language

Respond in Japanese unless explicitly instructed otherwise.

## Git

Git write actions require explicit user approval each time; approvals are single-use and expire immediately after the approved action completes.

## GitLab

When the user provides a GitLab Issue URL (`/-/issues/<iid>`), parse it and fetch details with:
  `glab issue view <iid> --comments -R <org>/<project>`

When the user provides a GitLab Work Item URL (`/-/work_items/<iid>`), parse it and fetch details with:
  `glab api "projects/<org>%2F<project>/issues/<iid>"`

Work items share the same IID space as issues; the `/work_items/` REST endpoint does not exist — use the issues API instead.
