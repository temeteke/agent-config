## Temporary files

Use a private OpenCode-specific directory for temporary or scratch files.

Prefer `$XDG_RUNTIME_DIR/opencode` when `XDG_RUNTIME_DIR` is set and writable.
Otherwise, use `${TMPDIR:-/tmp}/opencode-$(id -u)`.

Do not create, read, or search arbitrary files directly under `/tmp`.
Do not inspect unrelated files under `/tmp`.

Before using the temporary directory, resolve and create it:

```sh
if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -w "$XDG_RUNTIME_DIR" ]; then
    opencode_tmp="$XDG_RUNTIME_DIR/opencode"
else
    opencode_tmp="${TMPDIR:-/tmp}/opencode-$(id -u)"
fi

mkdir -p "$opencode_tmp"
chmod 700 "$opencode_tmp"
test -w "$opencode_tmp"
```

Use `$opencode_tmp` for temporary or scratch files.
