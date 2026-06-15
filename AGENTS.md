# Repository guide for agents

This repo packages the `self-documenting` Agent Skill for distribution across
Cursor,
Claude Code, Claude Web, and Claude Cowork.

## Layout

- `self-documenting/SKILL.md` — the skill itself (source of truth).
- `cursor/rules/self-documenting.mdc` — Cursor rule; auto-installed by
  `skillship install -a cursor`.
- `cursor/hooks.json` — Cursor hook entries; merged into `~/.cursor/hooks.json`
  on install.
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
