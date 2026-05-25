#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLANE_DIR="${1:-$ROOT_DIR/plane}"

cd "$PLANE_DIR"

printf "Plane directory: %s\n" "$(pwd)"
printf "Git commit: %s\n" "$(git -C "$ROOT_DIR" rev-parse HEAD 2>/dev/null || true)"

printf "\nTop-level files and directories:\n"
find . -maxdepth 2 -type f \
  \( -name "Dockerfile" \
  -o -name "docker-compose*.yml" \
  -o -name "package.json" \
  -o -name "pnpm-lock.yaml" \
  -o -name "yarn.lock" \
  -o -name "requirements*.txt" \
  -o -name "pyproject.toml" \
  -o -name "manage.py" \) \
  | sort

printf "\nPython/Django hints:\n"
find . -maxdepth 4 -type f \( -name "manage.py" -o -name "settings.py" \) | sort || true

printf "\nFrontend hints:\n"
find . -maxdepth 4 -type f \( -name "vite.config.*" -o -name "next.config.*" \) | sort || true

printf "\nCompose files:\n"
find . -maxdepth 4 -type f \( -name "docker-compose*.yml" -o -name "compose*.yml" \) | sort || true
