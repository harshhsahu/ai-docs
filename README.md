# ai-docs — make every repo AI-ready

A skill for AI coding agents (Claude Code, and anything that reads `AGENTS.md`) that turns a
codebase into one that agents can work in reliably:

- **`init`** — reads the code and writes an evidence-based doc set: a root `AGENTS.md` +
  `CLAUDE.md`, `docs/AGENTS.md` with the repo's hard rules, numbered guides `00–24`, and
  per-domain docs for APIs, database, modules, UI and infrastructure. Every sentence traces
  to a real file. Nothing is invented; unknowns are marked as TODOs for a human.
- **`update`** — after any code change, updates only the docs that change touched, in the
  same commit.
- **`check`** — runs a verifier that catches unmarked placeholders, broken links and cited
  paths that don't exist (the "invention detector"). Can run in CI on every PR.

Why: agents write better code when the repo tells them how it's built, where things go and
which rules not to break. Docs that drift from the code do the opposite, so this skill
treats keeping them in sync as part of every change.

## Install

```bash
git clone https://github.com/harshhsahu/ai-docs.git
cd ai-docs

# every repo on your machine (Claude Code personal skill)
bash scripts/install.sh --user

# or inside one repo, so the whole team gets it — then commit .claude/skills/
bash scripts/install.sh --repo ../my-product

# ...plus a GitHub Actions check that fails PRs with broken docs
bash scripts/install.sh --repo ../my-product --ci
```

Re-run the same command to update an install. Requires Python 3.8+ (standard library only).

## Use

In Claude Code, inside the target repo:

| Say | What happens |
|---|---|
| "Make this repo AI-ready" / `/ai-docs init` | Surveys the code, shows you the planned doc list, writes the docs, verifies them, hands you a TODO list |
| "Update the docs for this change" / `/ai-docs update` | Maps the diff to the docs it affects and edits only those |
| "Check the docs" / `/ai-docs check` | Runs the verifier and reports what's broken |

Cursor, Codex, Copilot, Gemini CLI and Windsurf read the generated root `AGENTS.md`
directly, so the docs help them even without the skill installed.

## What it generates

```
AGENTS.md                 # short, imperative rules every agent reads first
CLAUDE.md                 # @AGENTS.md
docs/
├── AGENTS.md             # the repo's hard rules (boundaries, ID mapping, approved libs)
├── ARCHITECTURE.md
├── 00–24-*.md            # one concern per file, only the ones the code gives evidence for
├── api/<domain>.md
├── database/*.md
├── modules/NN-<name>.md
├── ui/<component>.md
├── current-infrastructure/<system>.md
├── plans/  brainstorms/  # dated working docs
```

| Range | Concern |
|---|---|
| 00–05 | Product: overview, vision, goals, personas, journeys, navigation |
| 06–08 | Shape: tech stack, system architecture, folder structure |
| 09–14 | Engineering: coding, design system, state, API, security, performance |
| 15–20 | Operate: environment, analytics, notifications, error handling, testing, deployment |
| 21–24 | Govern: roadmap, definition of done, git workflow, feature flags |

Docs for concerns the code doesn't have (no analytics SDK → no `16-analytics.md`) are
skipped on purpose, and product docs that code can't answer (vision, personas, roadmap)
are left for a human.

## Repo layout

```
SKILL.md                  # the skill: modes, phases, rules
references/               # doc catalog, per-language analysis playbook, authoring rules
scripts/
├── survey_project.py     # deterministic inventory: stack, deps, routes, models, env vars
├── scaffold_docs.py      # copies the right templates into the target repo
├── verify_docs.py        # placeholder / link / invented-path checks
└── install.sh
assets/
├── templates/            # the doc templates, verbatim (AGENTS.md + docs/)
└── ci/docs-check.yml     # GitHub Actions guard
```

Prefer the manual route? Copy `assets/templates/docs` to your repo's `docs/`, copy
`assets/templates/AGENTS.md` to the root, add `CLAUDE.md` containing `@AGENTS.md`, and
resolve every `{{TOKEN}}`.

## Golden rule

**The docs are the source of truth.** When code and docs disagree, that's a bug in one of
them. Every contract change ships with its doc change in the same commit.
