## Temporary files

Use `${TMPDIR:-/tmp/opencode}` for temporary or scratch files.

Do not create, read, or search arbitrary files directly under `/tmp`.
Do not inspect unrelated files under `/tmp`.

Before using `/tmp/opencode`, create it if needed:

```sh
mkdir -p /tmp/opencode
chmod 700 /tmp/opencode 2>/dev/null || true
```
