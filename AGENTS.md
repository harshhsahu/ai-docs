# Agent Guide — ai-docs (this repo)

This repo *is* the ai-docs skill. The `AGENTS.md` that gets installed into other repos is
`assets/templates/AGENTS.md` — don't confuse the two.

## Layout

- `SKILL.md` — the skill entry point. Keep it navigable; push detail into `references/`.
- `references/` — doc catalog, analysis playbook, authoring rules.
- `scripts/` — Python 3.8+, **standard library only** (they must run anywhere with no install).
- `assets/templates/` — the house doc templates. Copied verbatim by `scaffold_docs.py`.
- `assets/ci/` — CI workflow installed by `scripts/install.sh --ci`.

## Rules

1. One copy of everything. Don't add files at the repo root that duplicate `references/`,
   `scripts/` or `assets/templates/`.
2. Template changes go in `assets/templates/` only; if you add or rename a numbered guide,
   update `scripts/scaffold_docs.py`, `references/doc-catalog.md` and the README table.
3. After editing a script, run it against a real repo:
   `python3 scripts/survey_project.py <repo> --out /tmp/s`, then `scaffold_docs.py --dry-run`
   and `verify_docs.py`.
4. Keep templates product-neutral — no company or product names.
