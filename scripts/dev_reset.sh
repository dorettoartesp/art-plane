#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLANE_DIR="$ROOT_DIR/plane"
COMPOSE_FILE="$PLANE_DIR/deployments/cli/community/docker-compose.yml"
ROOT_ENV="$ROOT_DIR/.env"
PROJECT_NAME="${COMPOSE_PROJECT_NAME:-art-plane-dev}"

if [[ -f "$ROOT_ENV" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ROOT_ENV"
  set +a
  PROJECT_NAME="${COMPOSE_PROJECT_NAME:-$PROJECT_NAME}"
fi

confirm_reset() {
  local expected="delete-dev-data"

  cat >&2 <<EOF
WARNING: this will stop the local Plane dev environment and delete Docker volumes
for project '$PROJECT_NAME'.

This removes the local dev database, uploaded files, queue data, cache data, and
the first setup/admin user. It must never be used against stg or prd.
EOF

  if [[ "${ART_PLANE_RESET_CONFIRM:-}" == "$expected" ]]; then
    return 0
  fi

  if [[ ! -t 0 ]]; then
    echo "Refusing to reset without confirmation." >&2
    echo "Run with: ART_PLANE_RESET_CONFIRM=$expected make dev-reset" >&2
    return 1
  fi

  local answer
  read -r -p "Type '$expected' to continue: " answer
  [[ "$answer" == "$expected" ]]
}

confirm_reset

docker compose \
  --project-name "$PROJECT_NAME" \
  --env-file "$ROOT_ENV" \
  --file "$COMPOSE_FILE" \
  down --volumes --remove-orphans

echo "Local Plane dev data reset for project '$PROJECT_NAME'."
