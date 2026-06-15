---
name: self-documenting
description: Keep a project self-documenting by updating docs alongside code. Use after any change that adds, removes, or alters behavior, config, commands, APIs, or project structure.
license: MIT
metadata:
  version: "1.1.2" # x-release-please-version
---

# Self-Documenting Project

After making code changes for a request, update the project's documentation in
the **same** change so docs never drift from reality.

## Workflow

After completing the change, run this checklist:

```
- [ ] Identify which docs the change affects (see "What to update")
- [ ] If no docs exist, bootstrap them (see "Bootstrapping docs when none exist")
- [ ] If the topic isn't covered, add a focused doc for it
- [ ] Update those docs to match the new behavior
- [ ] Remove docs for anything deleted
- [ ] Update the directory's index.md if files were added/removed/renamed
- [ ] Verify examples/commands still run as written
```

## What to update

Update whichever of these the change touches:

- **README / getting-started**: setup steps, prerequisites, usage examples,
  commands.
- **Agent guides** (`AGENTS.md`, `CLAUDE.md`, `.ai/`, `.cursor/rules/`): layout,
  conventions, workflows.
- **API / interface docs**: signatures, params, return values, env vars, config
  keys.
- **Architecture notes**: new components, data flow, removed modules.
- **Inline docs**: docstrings or comments only for non-obvious intent,
  trade-offs, or constraints — never narrate what the code plainly does.

## Bootstrapping docs when none exist

If the project has no docs directory, create one (`.ai/` for agent guides, or
`docs/`
matching the project's convention) and seed it with an `index.md` (see below).
Add
the minimal doc the current change requires — do not back-fill documentation for
unrelated parts of the codebase.

## When a topic isn't covered

If the change concerns a topic no existing doc covers:

1. Create a new focused doc for that topic in the docs directory.
2. Add an entry for it in the nearest `index.md`.
3. Keep it scoped to the topic — one concern per file.

## Prefer an index over large files (progressive disclosure)

Each docs directory (e.g. `.ai/`, `docs/`) should have an `index.md` that lists
the
topics covered and the specific file describing each topic. This enables
**progressive
disclosure**: an agent reads the `index.md` first, then opens only the file(s)
it needs —
instead of reading every doc and burning context and tokens.

- When reading docs: read `index.md` first, then jump to the relevant file(s)
  only.
- When writing docs: split by topic into separate files; keep each file focused.
- After adding/removing/renaming a doc, update the directory's `index.md` to
  match.

Example `index.md`:

```markdown
# Docs index

- [Getting started](getting-started.md) — install, run locally, common commands
- [Configuration](configuration.md) — env vars, config files, defaults
- [Architecture](architecture.md) — components, data flow, key decisions
- [Testing](testing.md) — how to run and write tests
- [Deployment](deployment.md) — build, release, environments
```

## Principles

- Documentation changes ship in the same commit/PR as the code.
- Prefer updating an existing doc over creating a new file.
- Split docs by topic and link them from an `index.md`; avoid one giant file.
- If a change makes a doc obsolete, delete or correct it (and update
  `index.md`).
- Keep it concise; match the project's existing doc style.
- If no docs are affected, do nothing — don't invent documentation.
