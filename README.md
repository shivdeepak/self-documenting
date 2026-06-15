# Build Self-documenting projects

An [Agent Skill](https://agentskills.io/specification) that keeps a project's
docs in sync with its code. Agents update the relevant docs in the **same**
change, so documentation never drifts from reality.

Those docs then become a map: agents read them to understand the project and
make changes the intended way. And because docs are split by topic behind an
`index.md`, this skill uses **progressive disclosure** — agents read only what
they need—saving context and tokens.

## Installation

### Option 1 — skillship (recommended)

Install across Cursor, Claude Code, Claude Web, and Claude Cowork using
[skillship](https://github.com/shivdeepak/skillship):

```bash
npx skillship install shivdeepak/self-documenting -a cursor -a claude-code
```

This installs the skill, the Cursor trigger rule, and any hooks in one step.
For Cursor specifically, it copies `cursor/rules/self-documenting.mdc` to
`~/.cursor/rules/` automatically — no manual file copying required.

For Claude Web / Cowork, download the latest `self-documenting.skill` from the
[releases page](https://github.com/shivdeepak/self-documenting/releases), then
upload it via the Claude desktop app (Customize → Skills → Upload). Once
uploaded, the skill becomes available in Claude Web automatically.

### Option 2 — npx skills

Install the skill into your project using the
[skills CLI](https://skills.sh):

```bash
npx skills add shivdeepak/self-documenting
```

This copies the skill into `.agents/skills/self-documenting/` (Cursor picks it
up automatically). Re-run the command to update to the latest version.

> **Note:** `npx skills` installs the skill file only. It does not install the
> Cursor trigger rule or hooks. Use Option 1 (skillship) to get those placed
> automatically.

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

`skillship install -a cursor` places two files in `~/.cursor/`:

- `skills/self-documenting/SKILL.md` — the skill itself. Its frontmatter
  `description` tells the agent when to invoke it; the body holds the workflow,
  what to update, and the guiding principles.
- `rules/self-documenting.mdc` — a trigger rule that makes the agent invoke the
  skill after every qualifying change.

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
self-documenting/SKILL.md              — the skill (source of truth)
cursor/rules/self-documenting.mdc      — Cursor rule (auto-installed by skillship)
cursor/hooks.json                      — Cursor hooks to merge (auto-installed by skillship)
.github/workflows/validate.yml         — CI validation
.github/workflows/release.yml          — automated releases via release-please
```
