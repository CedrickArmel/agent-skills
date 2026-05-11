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

.PHONY: install update delete list

# ── Commands ──────────────────────────────────────────────────────────────────

install:
	@mkdir -p $(SKILLS_DIR)
	@for s in $(TARGETS); do \
	  echo "Installing $$s → $(SKILLS_DIR)/$$s"; \
	  $(RUN) cp -r $$s $(SKILLS_DIR)/$$s; \
	done

update:
	@mkdir -p $(SKILLS_DIR)
	@for s in $(TARGETS); do \
	  echo "Updating $$s → $(SKILLS_DIR)/$$s"; \
	  $(RUN) rsync -a --delete $$s/ $(SKILLS_DIR)/$$s/; \
	done

delete:
	@for s in $(TARGETS); do \
	  echo "Deleting $(SKILLS_DIR)/$$s"; \
	  $(RUN) rm -rf $(SKILLS_DIR)/$$s; \
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
