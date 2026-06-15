#!/bin/bash
#
# install.sh — installer for the self-documenting Cursor skill.
#
# Installs the skill (SKILL.md) and the trigger rule (self-documenting.mdc).
#
# Modes:
#   - Interactive  : run from a terminal; prompts before acting.
#   - Non-interactive: run by an AI agent / CI / piped from curl; no prompts.
#
# Scope:
#   - User level (default) : ~/.cursor/
#   - Project level        : ./.cursor/  (use --project [PATH])
#
# Usage:
#   ./install.sh                     # interactive, user-level
#   ./install.sh --project           # interactive, current project
#   ./install.sh --project PATH      # interactive, given project
#   ./install.sh --yes               # force non-interactive
#   curl -fsSL <raw-url>/install.sh | bash
#
set -u

# --- repo coordinates (used when files are not present locally) -------------
REPO_RAW="https://raw.githubusercontent.com/shivdeepak/self-documenting/main"

# --- output helpers (homebrew-inspired) -------------------------------------
if [ -t 1 ]; then
  tty_blue=$'\033[34m'; tty_green=$'\033[32m'; tty_yellow=$'\033[33m'
  tty_red=$'\033[31m'; tty_bold=$'\033[1m'; tty_reset=$'\033[0m'
else
  tty_blue=""; tty_green=""; tty_yellow=""; tty_red=""; tty_bold=""; tty_reset=""
fi

ohai()  { printf "%s==>%s %s%s%s\n" "$tty_blue" "$tty_reset" "$tty_bold" "$*" "$tty_reset"; }
info()  { printf "    %s\n" "$*"; }
ok()    { printf "%s✓%s  %s\n" "$tty_green" "$tty_reset" "$*"; }
warn()  { printf "%sWarning%s: %s\n" "$tty_yellow" "$tty_reset" "$*" >&2; }
abort() { printf "%sError%s: %s\n" "$tty_red" "$tty_reset" "$*" >&2; exit 1; }

# --- defaults ---------------------------------------------------------------
SCOPE="user"
PROJECT_DIR=""
FORCE_YES=0

# Non-interactive when: not a TTY (curl|bash, agent, CI), NONINTERACTIVE set,
# CI set, or --yes passed.
if [ -t 0 ] && [ -z "${NONINTERACTIVE:-}" ] && [ -z "${CI:-}" ]; then
  INTERACTIVE=1
else
  INTERACTIVE=0
fi

# --- arg parsing ------------------------------------------------------------
while [ $# -gt 0 ]; do
  case "$1" in
    --project|-p)
      SCOPE="project"
      # optional path follows if it isn't another flag
      if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then
        PROJECT_DIR="$2"; shift
      fi
      ;;
    --yes|-y) FORCE_YES=1; INTERACTIVE=0 ;;
    --help|-h)
      cat <<EOF
Install the self-documenting Cursor skill and rule.

Usage: install.sh [options]

Options:
  -p, --project [PATH]   Install into a project's .cursor/ (default: user-level ~/.cursor/)
  -y, --yes              Run non-interactively (assume yes)
  -h, --help             Show this help

Environment:
  NONINTERACTIVE=1       Force non-interactive mode
EOF
      exit 0
      ;;
    *) abort "Unknown option: $1 (try --help)" ;;
  esac
  shift
done

[ "$FORCE_YES" -eq 1 ] && INTERACTIVE=0

# --- resolve install destination --------------------------------------------
if [ "$SCOPE" = "project" ]; then
  PROJECT_DIR="${PROJECT_DIR:-$PWD}"
  [ -d "$PROJECT_DIR" ] || abort "Project directory not found: $PROJECT_DIR"
  BASE="$PROJECT_DIR/.cursor"
  SCOPE_LABEL="project ($PROJECT_DIR)"
else
  BASE="${HOME}/.cursor"
  SCOPE_LABEL="user (${HOME}/.cursor)"
fi

SKILL_DEST="$BASE/skills/self-documenting/SKILL.md"
RULE_DEST="$BASE/rules/self-documenting.mdc"

# --- locate source files ----------------------------------------------------
# Prefer files shipped next to this script; fall back to downloading.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)"

fetch() {
  # fetch SRC_REL DEST  — copy local file if present, else download.
  local rel="$1" dest="$2" src="$SCRIPT_DIR/$1"
  mkdir -p "$(dirname "$dest")" || abort "Cannot create $(dirname "$dest")"
  if [ -f "$src" ]; then
    cp "$src" "$dest" || abort "Cannot write $dest"
  elif command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_RAW/$rel" -o "$dest" || abort "Download failed: $rel"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$dest" "$REPO_RAW/$rel" || abort "Download failed: $rel"
  else
    abort "Cannot find $rel locally and neither curl nor wget is available."
  fi
}

# --- plan & confirm ---------------------------------------------------------
ohai "Installing self-documenting skill"
info "Scope:  $SCOPE_LABEL"
info "Skill:  $SKILL_DEST"
info "Rule:   $RULE_DEST"

if [ "$INTERACTIVE" -eq 1 ]; then
  if [ -e "$SKILL_DEST" ] || [ -e "$RULE_DEST" ]; then
    warn "Existing files will be overwritten."
  fi
  printf "Proceed? [Y/n] "
  read -r reply
  case "$reply" in
    [nN]*) abort "Aborted." ;;
  esac
else
  info "Running in non-interactive mode."
fi

# --- install ----------------------------------------------------------------
fetch "self-documenting/SKILL.md" "$SKILL_DEST"
ok "Installed skill"
fetch ".cursor/rules/self-documenting.mdc" "$RULE_DEST"
ok "Installed rule"

ohai "Done"
info "Restart or reload Cursor to pick up the new skill and rule."
