SHELL := /usr/bin/env bash

PREFIX ?= $(HOME)
XDG_CONFIG_HOME ?= $(PREFIX)/.config

INSTRUCTIONS ?= instructions.md
OVERLAYS ?= overlays
SKILL_MANIFEST ?= skill-manifest.txt

SKILL_SCOPE ?= --global
SKILL_INSTALL_FLAGS ?= --copy -y
SKILL_REMOVE_FLAGS ?= -y

.PHONY: install uninstall
.PHONY: install-codex uninstall-codex
.PHONY: install-claude-code uninstall-claude-code
.PHONY: install-opencode uninstall-opencode
.PHONY: install-cline uninstall-cline
.PHONY: install-roo uninstall-roo
.PHONY: update-skills list-skills

install: install-codex install-claude-code install-opencode install-cline install-roo

uninstall: uninstall-codex uninstall-claude-code uninstall-opencode uninstall-cline uninstall-roo

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

define install_skills_for_agent
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
		skill="$$2"; \
		command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }; \
			echo "install skill: $$source / $$skill -> $(1)"; \
		npx skills add "$$source" \
			--skill "$$skill" \
			--agent "$(1)" \
			$(SKILL_SCOPE) \
			$(SKILL_INSTALL_FLAGS) < /dev/null; \
	done < "$(SKILL_MANIFEST)"
endef

define uninstall_skills_for_agent
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
		skill="$$2"; \
		command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }; \
		echo "remove skill: $$skill -> $(1)"; \
		npx skills remove "$$skill" \
			--agent "$(1)" \
			$(SKILL_SCOPE) \
			$(SKILL_REMOVE_FLAGS) || true; \
	done < "$(SKILL_MANIFEST)"
endef

install-codex:
	$(call install_instructions,codex,$(PREFIX)/.codex/AGENTS.md)
	$(call install_skills_for_agent,codex)

uninstall-codex:
	$(call uninstall_instructions,$(PREFIX)/.codex/AGENTS.md)
	$(call uninstall_skills_for_agent,codex)

install-claude-code:
	$(call install_instructions,claude-code,$(PREFIX)/.claude/CLAUDE.md)
	$(call install_skills_for_agent,claude-code)

uninstall-claude-code:
	$(call uninstall_instructions,$(PREFIX)/.claude/CLAUDE.md)
	$(call uninstall_skills_for_agent,claude-code)

install-opencode:
	$(call install_instructions,opencode,$(XDG_CONFIG_HOME)/opencode/AGENTS.md)
	$(call install_skills_for_agent,opencode)

uninstall-opencode:
	$(call uninstall_instructions,$(XDG_CONFIG_HOME)/opencode/AGENTS.md)
	$(call uninstall_skills_for_agent,opencode)

install-cline:
	$(call install_instructions,cline,$(PREFIX)/Documents/Cline/Rules/00-global.md)
	$(call install_skills_for_agent,cline)

uninstall-cline:
	$(call uninstall_instructions,$(PREFIX)/Documents/Cline/Rules/00-global.md)
	$(call uninstall_skills_for_agent,cline)

install-roo:
	$(call install_instructions,roo,$(PREFIX)/.roo/rules/00-global.md)
	$(call install_skills_for_agent,roo)

uninstall-roo:
	$(call uninstall_instructions,$(PREFIX)/.roo/rules/00-global.md)
	$(call uninstall_skills_for_agent,roo)

update-skills:
	@command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }
	npx skills update -y

list-skills:
	@command -v npx >/dev/null 2>&1 || { echo "error: npx not found" >&2; exit 1; }
	npx skills list $(SKILL_SCOPE)
