SKILLS_DIR := $(HOME)/.claude/skills
DRY_RUN    ?= 0

# Auto-detect skills: any directory containing a SKILL.md
ALL_SKILLS := $(patsubst %/SKILL.md,%,$(wildcard */SKILL.md))

# If SKILL= is set, operate on that skill only; otherwise operate on all
TARGETS := $(if $(SKILL),$(SKILL),$(ALL_SKILLS))

ifeq ($(DRY_RUN),1)
  RUN := echo
else
  RUN :=
endif

.PHONY: install update delete list help

# ── Help ──────────────────────────────────────────────────────────────────────

help:
	@echo "Usage: make [target] [SKILL=<name>] [DRY_RUN=1]"
	@echo ""
	@echo "Targets:"
	@echo "  install   Copy skill(s) to $(SKILLS_DIR)"
	@echo "  update    Sync skill(s) in place (rsync --delete)"
	@echo "  delete    Remove skill(s) from $(SKILLS_DIR)"
	@echo "  list      Show available and installed skills"
	@echo "  help      Show this message"
	@echo ""
	@echo "Flags:"
	@echo "  SKILL=<name>   Operate on a single skill (default: all)"
	@echo "  DRY_RUN=1      Print commands without executing them"
	@echo ""
	@echo "Examples:"
	@echo "  make install"
	@echo "  make install SKILL=pr-open"
	@echo "  make update  SKILL=skill-creator DRY_RUN=1"
	@echo "  make delete  SKILL=pr-open"

# ── Commands ──────────────────────────────────────────────────────────────────

install:
	@$(RUN) mkdir -p "$(SKILLS_DIR)"
	@for s in $(TARGETS); do \
	  if [ ! -d "$$s" ]; then echo "ERROR: skill '$$s' not found in repo" >&2; exit 1; fi; \
	  if [ -d "$(SKILLS_DIR)/$$s" ]; then \
	    echo "WARNING: '$$s' already installed — run 'make update SKILL=$$s' to sync" >&2; \
	  else \
	    echo "Installing $$s → $(SKILLS_DIR)/$$s"; \
	    $(RUN) cp -r "$$s" "$(SKILLS_DIR)/$$s"; \
	  fi; \
	done

update:
	@$(RUN) mkdir -p "$(SKILLS_DIR)"
	@for s in $(TARGETS); do \
	  if [ ! -d "$$s" ]; then echo "ERROR: skill '$$s' not found in repo" >&2; exit 1; fi; \
	  echo "Updating $$s → $(SKILLS_DIR)/$$s"; \
	  $(RUN) rsync -a --delete "$$s/" "$(SKILLS_DIR)/$$s/"; \
	done

delete:
	@for s in $(TARGETS); do \
	  if [ ! -d "$(SKILLS_DIR)/$$s" ]; then \
	    echo "WARNING: '$$s' is not installed — nothing to delete" >&2; \
	  else \
	    echo "Deleting $(SKILLS_DIR)/$$s"; \
	    $(RUN) rm -rf "$(SKILLS_DIR)/$$s"; \
	  fi; \
	done

list:
	@echo "Available skills (this repo):"
	@for s in $(ALL_SKILLS); do echo "  $$s"; done
	@echo ""
	@echo "Installed skills ($(SKILLS_DIR)):"
	@for s in $(ALL_SKILLS); do \
	  if [ -d "$(SKILLS_DIR)/$$s" ]; then echo "  $$s  [installed]"; \
	  else echo "  $$s  [not installed]"; fi; \
	done
	@echo ""
	@echo "Other installed skills (not in this repo):"
	@for d in "$(SKILLS_DIR)"/*/; do \
	  s=$$(basename "$$d"); \
	  found=0; \
	  for r in $(ALL_SKILLS); do if [ "$$r" = "$$s" ]; then found=1; break; fi; done; \
	  if [ "$$found" = "0" ]; then echo "  $$s"; fi; \
	done
