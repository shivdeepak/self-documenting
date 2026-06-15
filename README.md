# Build Self-documenting projects

An [Agent Skill](https://agentskills.io/specification) that keeps a project's docs 
in sync with its code. Agents update the relevant docs in the **same** change, so
documentation never drifts from reality.

Those docs then become a map: agents read them to understand the project and
make changes
the intended way. And because docs are split by topic behind an `index.md`, this
skill uses
**progressive disclosure** — agents read only what they need—saving context and
tokens.

## Installation

### Via skillship (all surfaces)

Install across Cursor, Claude Code, Claude Web, and Claude Cowork using
[skillship](https://github.com/shivdeepak/skillship):

```bash
npx skillship install self-documenting -a cursor,claude-code
```

For Claude Web / Cowork, package and upload manually:

```bash
npx skillship package self-documenting
# Then upload dist/self-documenting.skill in the Claude interface
```

### Via install.sh (Cursor only)

Install the skill and trigger rule at the **user level** (`~/.cursor/`) with a
single command:

```bash
curl -fsSL https://raw.githubusercontent.com/shivdeepak/self-documenting/main/install.sh | bash
```

To install into a specific project's `.cursor/` instead of the user level,
append `--project`:

```bash
curl -fsSL https://raw.githubusercontent.com/shivdeepak/self-documenting/main/install.sh | bash -s -- --project
```

## What it does

The skill activates after an agent fulfills any request that adds, removes, or
alters behavior, config, commands, APIs, or project structure. It guides the
agent to:

- Identify which docs the change affects, and update them to match the new
  behavior.
- Bootstrap a docs directory (`.ai/` or `docs/`) with an `index.md` when none
  exists.
- Add a focused doc when a change concerns an uncovered topic.
- Remove docs for anything deleted, and keep each directory's `index.md`
  current.
- Prefer an `index.md` over large files so agents read only what they need
  (context efficiency).

## How it works

The installer places two files in your `.cursor/`:

- [`self-documenting/SKILL.md`](self-documenting/SKILL.md) — the skill itself.
  Its frontmatter `description` tells the agent when to invoke it; the body
  holds the workflow, what to update, and the guiding principles.
- [`.cursor/rules/self-documenting.mdc`](.cursor/rules/self-documenting.mdc) — a
  trigger rule with `alwaysApply: true` that makes the agent invoke the skill
  after every qualifying change.

With both in place, the agent updates docs automatically after qualifying
changes—no manual invocation required. Restart or reload Cursor after installing
to pick them up.

## Development

```bash
npx skillship validate self-documenting --profile all   # validate skill
npx skillship package self-documenting                  # build .skill archive
```

## Layout

```
self-documenting/SKILL.md        — the skill (source of truth)
snippets/cursor-rule.mdc         — Cursor rule snippet
snippets/claude-md.md            — Claude AGENTS.md/CLAUDE.md snippet
install.sh                       — standalone Cursor installer
.github/workflows/validate.yml   — CI validation
.github/workflows/release.yml    — automated releases via release-please
```
