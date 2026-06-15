# Repository guide for agents

This repo packages the `self-documenting` Agent Skill for distribution across
Cursor,
Claude Code, Claude Web, and Claude Cowork.

## Layout

- `self-documenting/SKILL.md` — the skill itself (source of truth).
- `snippets/cursor-rule.mdc` — Cursor rule snippet for triggering the skill.
- `snippets/claude-md.md` — Claude CLAUDE.md/AGENTS.md snippet for triggering
  the skill.
- `install.sh` — standalone installer for Cursor (user or project level).
- `release-please-config.json`, `.release-please-manifest.json`, `version.txt` —
  release automation via release-please + Conventional Commits.
- `.github/workflows/validate.yml` — validates the skill on PRs/pushes.
- `.github/workflows/release.yml` — cuts releases and uploads
  `self-documenting.skill`.

## Conventions

- Use Conventional Commits (`feat:`, `fix:`, `docs:`, ...). `feat`/`fix` bump
  the version; merging the release PR publishes `self-documenting.skill` to a
  GitHub Release.
- Keep the `description` in `self-documenting/SKILL.md` <= 200 chars so it
  uploads to
  Claude Web/Cowork.
- The version line in `SKILL.md` carries `# x-release-please-version` so
  release-please updates it in place.

## Commands

- `npx skillship validate self-documenting --profile all`
- `npx skillship package self-documenting`
- `npx skillship install self-documenting -a cursor,claude-code`
