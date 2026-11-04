#!/usr/bin/env bash
# Install the ai-docs skill.
#
#   scripts/install.sh --user                 # ~/.claude/skills/ai-docs (every repo on this machine)
#   scripts/install.sh --repo <path>          # <path>/.claude/skills/ai-docs (commit it; whole team gets it)
#   scripts/install.sh --repo <path> --ci     # ...and add .github/workflows/docs-check.yml
#
# Re-running updates an existing install in place.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE=""; REPO=""; CI=0

usage() { sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'; exit "${1:-0}"; }

while [ $# -gt 0 ]; do
  case "$1" in
    --user) MODE=user ;;
    --repo) MODE=repo; REPO="${2:-}"; shift ;;
    --ci)   CI=1 ;;
    -h|--help) usage 0 ;;
    *) echo "unknown option: $1" >&2; usage 1 ;;
  esac
  shift
done

[ -n "$MODE" ] || usage 1

if [ "$MODE" = user ]; then
  DEST="$HOME/.claude/skills/ai-docs"
else
  [ -n "$REPO" ] && [ -d "$REPO" ] || { echo "--repo needs an existing directory" >&2; exit 1; }
  REPO="$(cd "$REPO" && pwd)"
  DEST="$REPO/.claude/skills/ai-docs"
fi

mkdir -p "$DEST"
# Copy only what the skill needs at runtime.
for item in SKILL.md references scripts assets; do
  rm -rf "${DEST:?}/$item"
  cp -R "$SRC/$item" "$DEST/$item"
done
echo "installed ai-docs -> $DEST"

if [ "$CI" = 1 ]; then
  [ "$MODE" = repo ] || { echo "--ci only applies with --repo" >&2; exit 1; }
  mkdir -p "$REPO/.github/workflows"
  WF="$REPO/.github/workflows/docs-check.yml"
  if [ -f "$WF" ]; then
    echo "kept existing $WF (delete it first to reinstall)"
  else
    cp "$SRC/assets/ci/docs-check.yml" "$WF"
    echo "added CI guard -> $WF"
  fi
fi

cat <<'EOF'

Next: open the repo in Claude Code and ask
  "make this repo AI-ready"      (or /ai-docs init)
After code changes:
  "update the docs for this change"   (or /ai-docs update)
EOF
