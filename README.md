# agent-coding-config

Personal configuration for coding agents.

This repository installs:

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

Install all supported tools:

```sh
make install
```

Install only Codex:

```sh
make install-codex
```

Install only Claude Code:

```sh
make install-claude-code
```

Uninstall all supported tools:

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

- `make install-codex`
- `make install-claude-code`
- `make install-opencode`
- `make install-cline`
- `make install-roo-code`

Each `install-*` target installs both:

1. the tool-specific global instruction file
2. every skill listed in `skill-manifest.txt` for that agent

There is intentionally no public `install-skills` target. Skills are installed together with the corresponding tool target.

## Instruction files

`make install-*` overwrites the target global instruction file.

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
- `overlays/roo-code.md`

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

Normal `make install-*` targets install skills from the sources listed in `skill-manifest.txt`.
