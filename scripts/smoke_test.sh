#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLANE_DIR="$ROOT_DIR/plane"
COMPOSE_FILE="$PLANE_DIR/deployments/cli/community/docker-compose.yml"
ROOT_ENV="$ROOT_DIR/.env"
PROJECT_NAME="${COMPOSE_PROJECT_NAME:-art-plane-dev}"
HTTP_PORT="${PLANE_DEV_HTTP_PORT:-8080}"

if [[ -f "$ROOT_ENV" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ROOT_ENV"
  set +a
  PROJECT_NAME="${COMPOSE_PROJECT_NAME:-$PROJECT_NAME}"
  HTTP_PORT="${PLANE_DEV_HTTP_PORT:-$HTTP_PORT}"
fi

compose() {
  docker compose \
    --project-name "$PROJECT_NAME" \
    --env-file "$ROOT_ENV" \
    --file "$COMPOSE_FILE" \
    "$@"
}

wait_for() {
  local label="$1"
  local timeout_seconds="$2"
  shift 2

  local start
  start="$(date +%s)"

  until "$@"; do
    if (( $(date +%s) - start >= timeout_seconds )); then
      echo "Timed out waiting for: $label" >&2
      return 1
    fi
    sleep 5
  done
}

required_running=(
  web
  admin
  space
  api
  worker
  beat-worker
  live
  plane-db
  plane-redis
  plane-mq
  plane-minio
  proxy
)

echo "Checking docker compose services for project '$PROJECT_NAME'..."

check_required_services() {
  local service
  local running_services

  running_services="$(compose ps --services --status running | sort)"

  for service in "${required_running[@]}"; do
    grep -qx "$service" <<<"$running_services" || return 1
  done
}

wait_for "required services running" 300 check_required_services || {
  compose ps
  exit 1
}

echo "Checking worker restart counters..."
check_no_crash_loop() {
  local service
  local container_id
  local restart_count

  for service in api worker beat-worker; do
    container_id="$(compose ps -q "$service" || true)"
    [[ -n "$container_id" ]] || return 1

    restart_count="$(docker inspect -f '{{.RestartCount}}' "$container_id")"
    [[ "$restart_count" == "0" ]] || {
      echo "Service '$service' restarted $restart_count time(s)." >&2
      return 1
    }
  done
}

check_no_crash_loop || {
  compose ps
  compose logs --tail=120 api worker beat-worker
  exit 1
}

echo "Checking migrator exit status..."
check_migrator_completed() {
  local migrator_id
  local status

  migrator_id="$(compose ps -aq migrator || true)"
  [[ -n "$migrator_id" ]] || return 1

  status="$(docker inspect -f '{{.State.Status}} {{.State.ExitCode}}' "$migrator_id")"
  [[ "$status" == "exited 0" ]]
}

wait_for "migrator completed" 900 check_migrator_completed || {
  compose logs --tail=160 migrator
  exit 1
}

echo "Checking API health inside api container..."
check_api_health() {
  compose exec -T api python - <<'PY'
import json
import urllib.request
import sys

try:
    with urllib.request.urlopen("http://127.0.0.1:8000/", timeout=10) as response:
        body = response.read().decode("utf-8")
        data = json.loads(body)
        if response.status != 200 or data.get("status") != "OK":
            sys.exit(1)
except Exception:
    sys.exit(1)
PY
}

wait_for "API health" 600 check_api_health

echo "Checking web proxy on http://localhost:${HTTP_PORT}..."
wait_for "web proxy" 300 curl --fail --silent --show-error --location --max-time 20 \
  "http://localhost:${HTTP_PORT}/" >/dev/null

echo "Checking admin route on http://localhost:${HTTP_PORT}/god-mode/..."
wait_for "admin route" 300 curl --fail --silent --show-error --location --max-time 20 \
  "http://localhost:${HTTP_PORT}/god-mode/" >/dev/null

echo "Checking space route on http://localhost:${HTTP_PORT}/spaces/..."
wait_for "space route" 300 curl --fail --silent --show-error --location --max-time 20 \
  "http://localhost:${HTTP_PORT}/spaces/" >/dev/null

echo "Smoke test passed."
