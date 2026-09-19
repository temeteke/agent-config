# agent-config

Personal configuration for coding agents.

This repository installs:

- CLI tools for supported coding agents
- global instruction files for supported coding-agent tools
- skills listed in `skill-manifest.txt` via `npx skills`

## Files

- `instructions.md`: shared global instructions
- `overlays/`: optional tool-specific additions
- `skills/`: source directory for self-authored skills
- `skill-manifest.txt`: explicit list of skills to install

The repository root intentionally does not contain `AGENTS.md` or `CLAUDE.md`.
Those files are generated only at install destinations.

## Usage

Install all managed configuration and CLI binaries:

```sh
make install
```

Install only configuration (instructions and skills):

```sh
make install-config
```

Install only CLI binaries:

```sh
make install-bin
```

Install only Codex instructions:

```sh
make install-instructions-codex
```

Install only Claude Code instructions:

```sh
make install-instructions-claude-code
```

Uninstall all managed configuration and CLI binaries:

```sh
make uninstall
```

Update skills managed by `npx skills`:

```sh
make update-skills
```

List installed skills:

```sh
make list-skills
```

## Supported targets

- `make install-config`
- `make uninstall-config`
- `make install-bin`
- `make uninstall-bin`
- `make install-bin-codex`
- `make uninstall-bin-codex`
- `make install-bin-claude-code`
- `make uninstall-bin-claude-code`
- `make install-bin-opencode`
- `make uninstall-bin-opencode`
- `make install-instructions-codex`
- `make install-instructions-claude-code`
- `make install-instructions-opencode`
- `make install-instructions-cline`
- `make install-instructions-roo`
- `make install-skills`
- `make uninstall-skills`

Each `install-instructions-*` target installs:

1. the tool-specific global instruction file

Skills are managed separately with `make install-skills` and `make uninstall-skills`.

## CLI tools

`make install-bin` installs the CLI tool packages globally through the existing `install-bin` target. `install-bin` is kept as a compatibility target:


- `make install-bin-codex`: `@openai/codex`
- `make install-bin-claude-code`: `@anthropic-ai/claude-code`
- `make install-bin-opencode`: `opencode-ai`

Override `CODEX_PACKAGE`, `CLAUDE_CODE_PACKAGE`, or `OPENCODE_PACKAGE` to customize package names.

## Instruction files

`make install-instructions-*` overwrites the target global instruction file.

Back up any existing global instruction files before running this installer if needed.

Install destinations:

- Codex: `~/.codex/AGENTS.md`
- Claude Code: `~/.claude/CLAUDE.md`
- OpenCode: `~/.config/opencode/AGENTS.md`
- Cline: `~/Documents/Cline/Rules/00-global.md`
- Roo Code: `~/.roo/rules/00-global.md`

## Overlays

Tool-specific overlays are optional.

If a non-empty overlay file exists, it is appended to `instructions.md` when installing that tool.

Overlay file names:

- `overlays/codex.md`
- `overlays/claude-code.md`
- `overlays/opencode.md`
- `overlays/cline.md`
- `overlays/roo.md`

Empty overlay files are ignored.

## skill-manifest.txt

`skill-manifest.txt` is the complete list of skills installed by this repository.

Format:

```text
source skill-name
```

Example:

```text
vercel-labs/skills find-skills
```

Skills under `skills/` are not installed automatically. Add them to `skill-manifest.txt` explicitly.

## Local skill development

During local development, install a skill manually from the working tree:

```sh
npx skills add . --skill <skill-name> --agent claude-code --global --copy -y
```

`make install-skills` installs every skill listed in `skill-manifest.txt` for the agents in `SKILL_AGENTS`.
