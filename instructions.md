## Language

Respond in Japanese unless explicitly instructed otherwise.

## Git

Never commit, push, or create PRs unless the user explicitly says "commit" or "push" in the *current* message. Past approvals do not carry over — each Git write action requires fresh, explicit permission in the same turn.

## GitLab

When the user provides a GitLab Issue URL (`/-/issues/<iid>`), parse it and fetch details with:
  `glab issue view <iid> --comments -R <org>/<project>`

When the user provides a GitLab Work Item URL (`/-/work_items/<iid>`), parse it and fetch details with:
  `glab api "projects/<org>%2F<project>/issues/<iid>"`

Work items share the same IID space as issues; the `/work_items/` REST endpoint does not exist — use the issues API instead.
