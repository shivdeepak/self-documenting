# self-documenting

A Cursor [Agent Skill](https://docs.cursor.com/) that keeps a project's documentation in sync with its code. When an AI agent makes a change, this skill prompts it to update the relevant docs in the **same** change so documentation never drifts from reality.

## Installation

Run [`install.sh`](install.sh) to install the skill and trigger rule. It installs at the **user level** (`~/.cursor/`) by default:

```bash
./install.sh
```

Or install directly from the repo:

```bash
curl -fsSL https://raw.githubusercontent.com/shivdeepak/self-documenting/main/install.sh | bash
```

The installer auto-detects its mode: it runs **interactively** (prompts for confirmation) in a terminal, and **non-interactively** when run by an AI agent, in CI, or piped from `curl`. Force non-interactive mode with `--yes` or `NONINTERACTIVE=1`.

To install into a specific project's `.cursor/` instead of the user level, use `--project`:

```bash
./install.sh --project            # current directory
./install.sh --project path/to/repo
```

Run `./install.sh --help` for all options.

## What it does

The skill activates after an agent fulfills any request that adds, removes, or alters behavior, config, commands, APIs, or project structure. It guides the agent to:

- Identify which docs the change affects, and update them to match the new behavior.
- Bootstrap a docs directory (`.ai/` or `docs/`) with an `index.md` when none exists.
- Add a focused doc when a change concerns an uncovered topic.
- Remove docs for anything deleted, and keep each directory's `index.md` current.
- Prefer an `index.md` over large files so agents read only what they need (context efficiency).

## How it works

The skill is defined in [`SKILL.md`](SKILL.md). Its frontmatter `description` tells the agent when to invoke it; the body provides the workflow, the list of what to update, and the guiding principles.

## Usage

Place this skill where your agent discovers skills (e.g. `~/.cursor/skills/` or a project's `.cursor/skills/`). The agent reads `SKILL.md` and follows it automatically after qualifying changes—no manual invocation required.

To make the workflow trigger automatically in another project, copy [`.cursor/rules/self-documenting.mdc`](.cursor/rules/self-documenting.mdc) into that project's `.cursor/rules/`. The rule is `alwaysApply: true`, so the agent invokes the skill after every qualifying change request.
