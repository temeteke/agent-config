SHELL := /usr/bin/env bash

PREFIX ?= $(HOME)
XDG_CONFIG_HOME ?= $(PREFIX)/.config

INSTRUCTIONS ?= instructions.md
OVERLAYS ?= overlays
SKILL_MANIFEST ?= skill-manifest.txt

SKILL_SCOPE ?= --global
SKILL_INSTALL_FLAGS ?= --copy -y
SKILL_REMOVE_FLAGS ?= -y
# Disable npx skills telemetry
export DISABLE_TELEMETRY := 1

SKILL_AGENTS ?= codex claude-code opencode cline roo
SKILL_AGENT_ARGS := $(foreach agent,$(SKILL_AGENTS),--agent "$(agent)")
CODEX_PACKAGE ?= @openai/codex
CLAUDE_CODE_PACKAGE ?= @anthropic-ai/claude-code
OPENCODE_PACKAGE ?= opencode-ai

.PHONY: install uninstall
.PHONY: install-config uninstall-config
.PHONY: install-bin uninstall-bin
.PHONY: install-tools uninstall-tools
.PHONY: install-tools-codex uninstall-tools-codex
.PHONY: install-tools-claude-code uninstall-tools-claude-code
.PHONY: install-tools-opencode uninstall-tools-opencode
.PHONY: install-instructions uninstall-instructions
.PHONY: install-skills uninstall-skills
.PHONY: install-instructions-codex uninstall-instructions-codex
.PHONY: install-instructions-claude-code uninstall-instructions-claude-code
.PHONY: install-instructions-opencode uninstall-instructions-opencode
.PHONY: install-instructions-cline uninstall-instructions-cline
.PHONY: install-instructions-roo uninstall-instructions-roo
.PHONY: update-skills list-skills

install: install-bin install-config

uninstall: uninstall-config uninstall-bin

install-config: install-instructions install-skills

uninstall-config: uninstall-instructions uninstall-skills

install-bin: install-tools

uninstall-bin: uninstall-tools

install-tools: install-tools-codex install-tools-claude-code install-tools-opencode

uninstall-tools: uninstall-tools-codex uninstall-tools-claude-code uninstall-tools-opencode

install-tools-codex:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm install -g $(CODEX_PACKAGE)

uninstall-tools-codex:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm uninstall -g $(CODEX_PACKAGE)

install-tools-claude-code:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm install -g $(CLAUDE_CODE_PACKAGE)

uninstall-tools-claude-code:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm uninstall -g $(CLAUDE_CODE_PACKAGE)

install-tools-opencode:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm install -g $(OPENCODE_PACKAGE)

uninstall-tools-opencode:
	@command -v npm >/dev/null 2>&1 || { echo "error: npm not found" >&2; exit 1; }
	npm uninstall -g $(OPENCODE_PACKAGE)

install-instructions: install-instructions-codex install-instructions-claude-code install-instructions-opencode install-instructions-cline install-instructions-roo

uninstall-instructions: uninstall-instructions-codex uninstall-instructions-claude-code uninstall-instructions-opencode uninstall-instructions-cline uninstall-instructions-roo

install-skills:
	@if [ ! -f "$(SKILL_MANIFEST)" ]; then \
		echo "skip: $(SKILL_MANIFEST) not found"; \
		exit 0; \
	fi
	@while IFS= read -r line || [ -n "$$line" ]; do \
		line="$${line%%#*}"; \
		set -- $$line; \
		[ "$$#" -eq 0 ] && continue; \
		if [ "$$#" -lt 2 ]; then \
			echo "error: invalid line in $(SKILL_MANIFEST): $$line" >&2; \
			exit 1; \
		fi; \
		source="$$1"; \
		shift; \
		skill_args=""; \
		for s in "$$@"; do \
			skill_args="$$skill_args --skill $$s"; \
		done; \
		command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }; \
		echo "install skill: $$source ($$*) -> $(SKILL_AGENTS)"; \
		eval npx skills add \"$$source\" \
			$$skill_args \
			$(SKILL_AGENT_ARGS) \
			$(SKILL_SCOPE) \
			$(SKILL_INSTALL_FLAGS) < /dev/null; \
	done < "$(SKILL_MANIFEST)"

uninstall-skills:
	@if [ ! -f "$(SKILL_MANIFEST)" ]; then \
		echo "skip: $(SKILL_MANIFEST) not found"; \
		exit 0; \
	fi
	@while IFS= read -r line || [ -n "$$line" ]; do \
		line="$${line%%#*}"; \
		set -- $$line; \
		[ "$$#" -eq 0 ] && continue; \
		if [ "$$#" -lt 2 ]; then \
			echo "error: invalid line in $(SKILL_MANIFEST): $$line" >&2; \
			exit 1; \
		fi; \
		shift; \
		command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }; \
		echo "remove skill: $$*"; \
		npx skills remove "$$@" \
			$(SKILL_SCOPE) \
			$(SKILL_REMOVE_FLAGS) < /dev/null || true; \
	done < "$(SKILL_MANIFEST)"

define install_instructions
	@mkdir -p "$(dir $(2))"
	@test -f "$(INSTRUCTIONS)" || { echo "error: $(INSTRUCTIONS) not found" >&2; exit 1; }
	@{ \
		cat "$(INSTRUCTIONS)"; \
		if [ -s "$(OVERLAYS)/$(1).md" ]; then \
			echo ""; \
			echo "---"; \
			echo ""; \
			cat "$(OVERLAYS)/$(1).md"; \
		fi; \
	} > "$(2)"
	@echo "installed instructions: $(2)"
endef

define uninstall_instructions
	@rm -f "$(1)"
	@echo "removed instructions: $(1)"
endef

install-instructions-codex:
	$(call install_instructions,codex,$(PREFIX)/.codex/AGENTS.md)

uninstall-instructions-codex:
	$(call uninstall_instructions,$(PREFIX)/.codex/AGENTS.md)

install-instructions-claude-code:
	$(call install_instructions,claude-code,$(PREFIX)/.claude/CLAUDE.md)

uninstall-instructions-claude-code:
	$(call uninstall_instructions,$(PREFIX)/.claude/CLAUDE.md)

install-instructions-opencode:
	$(call install_instructions,opencode,$(XDG_CONFIG_HOME)/opencode/AGENTS.md)

uninstall-instructions-opencode:
	$(call uninstall_instructions,$(XDG_CONFIG_HOME)/opencode/AGENTS.md)

install-instructions-cline:
	$(call install_instructions,cline,$(PREFIX)/Documents/Cline/Rules/00-global.md)

uninstall-instructions-cline:
	$(call uninstall_instructions,$(PREFIX)/Documents/Cline/Rules/00-global.md)

install-instructions-roo:
	$(call install_instructions,roo,$(PREFIX)/.roo/rules/00-global.md)

uninstall-instructions-roo:
	$(call uninstall_instructions,$(PREFIX)/.roo/rules/00-global.md)

update-skills:
	@command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }
	npx skills update -y

list-skills:
	@command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }
	npx skills list $(SKILL_SCOPE)
