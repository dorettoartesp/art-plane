#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_ENV="$ROOT_DIR/.env"
ROOT_ENV_EXAMPLE="$ROOT_DIR/.env.example"
PLANE_DIR="$ROOT_DIR/plane"
PLANE_ENV="$PLANE_DIR/.env"
PLANE_API_ENV="$PLANE_DIR/apps/api/.env"

set_env() {
  local file="$1"
  local key="$2"
  local value="$3"

  if grep -qE "^${key}=" "$file"; then
    sed -i -E "s#^${key}=.*#${key}=${value}#" "$file"
  else
    printf "%s=%s\n" "$key" "$value" >>"$file"
  fi
}

if [[ ! -f "$ROOT_ENV" ]]; then
  cp "$ROOT_ENV_EXAMPLE" "$ROOT_ENV"
  echo "Created .env"
fi

set -a
# shellcheck disable=SC1090
source "$ROOT_ENV"
set +a

COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-art-plane-dev}"
PLANE_DEV_HTTP_PORT="${PLANE_DEV_HTTP_PORT:-8080}"
PLANE_DEV_HTTPS_PORT="${PLANE_DEV_HTTPS_PORT:-8443}"
PLANE_DEV_BASE_URL="${PLANE_DEV_BASE_URL:-http://localhost:${PLANE_DEV_HTTP_PORT}}"

set_env "$ROOT_ENV" "COMPOSE_PROJECT_NAME" "$COMPOSE_PROJECT_NAME"
set_env "$ROOT_ENV" "PLANE_DEV_HTTP_PORT" "$PLANE_DEV_HTTP_PORT"
set_env "$ROOT_ENV" "PLANE_DEV_HTTPS_PORT" "$PLANE_DEV_HTTPS_PORT"
set_env "$ROOT_ENV" "PLANE_DEV_BASE_URL" "$PLANE_DEV_BASE_URL"
set_env "$ROOT_ENV" "APP_DOMAIN" "localhost"
set_env "$ROOT_ENV" "APP_RELEASE" "${APP_RELEASE:-stable}"
set_env "$ROOT_ENV" "LISTEN_HTTP_PORT" "$PLANE_DEV_HTTP_PORT"
set_env "$ROOT_ENV" "LISTEN_HTTPS_PORT" "$PLANE_DEV_HTTPS_PORT"
set_env "$ROOT_ENV" "WEB_URL" "$PLANE_DEV_BASE_URL"
set_env "$ROOT_ENV" "CORS_ALLOWED_ORIGINS" "$PLANE_DEV_BASE_URL"
set_env "$ROOT_ENV" "DEBUG" "0"
set_env "$ROOT_ENV" "CERT_ACME_CA" "https://acme-v02.api.letsencrypt.org/directory"
set_env "$ROOT_ENV" "CERT_ACME_DNS" ""
set_env "$ROOT_ENV" "CERT_EMAIL" ""
set_env "$ROOT_ENV" "POSTGRES_USER" "plane"
set_env "$ROOT_ENV" "POSTGRES_PASSWORD" "plane"
set_env "$ROOT_ENV" "POSTGRES_DB" "plane"
set_env "$ROOT_ENV" "DATABASE_URL" "postgresql://plane:plane@plane-db/plane"
set_env "$ROOT_ENV" "RABBITMQ_USER" "plane"
set_env "$ROOT_ENV" "RABBITMQ_PASSWORD" "plane"
set_env "$ROOT_ENV" "RABBITMQ_VHOST" "plane"
set_env "$ROOT_ENV" "AMQP_URL" "amqp://plane:plane@plane-mq:5672/plane"
set_env "$ROOT_ENV" "USE_MINIO" "1"
set_env "$ROOT_ENV" "AWS_ACCESS_KEY_ID" "access-key"
set_env "$ROOT_ENV" "AWS_SECRET_ACCESS_KEY" "secret-key"
set_env "$ROOT_ENV" "AWS_S3_ENDPOINT_URL" "http://plane-minio:9000"
set_env "$ROOT_ENV" "AWS_S3_BUCKET_NAME" "uploads"
set_env "$ROOT_ENV" "SECRET_KEY" "${SECRET_KEY:-dev-only-change-before-stg-prd}"
set_env "$ROOT_ENV" "LIVE_SERVER_SECRET_KEY" "${LIVE_SERVER_SECRET_KEY:-dev-only-change-before-stg-prd}"

if [[ ! -f "$PLANE_ENV" ]]; then
  cp "$PLANE_DIR/.env.example" "$PLANE_ENV"
  echo "Created plane/.env"
fi

set_env "$PLANE_ENV" "LISTEN_HTTP_PORT" "$PLANE_DEV_HTTP_PORT"
set_env "$PLANE_ENV" "LISTEN_HTTPS_PORT" "$PLANE_DEV_HTTPS_PORT"
set_env "$PLANE_ENV" "SITE_ADDRESS" ":80"
set_env "$PLANE_ENV" "USE_MINIO" "1"
set_env "$PLANE_ENV" "AWS_S3_ENDPOINT_URL" "\"http://plane-minio:9000\""
set_env "$PLANE_ENV" "TRUSTED_PROXIES" "0.0.0.0/0"

if [[ ! -f "$PLANE_API_ENV" ]]; then
  cp "$PLANE_DIR/apps/api/.env.example" "$PLANE_API_ENV"
  echo "Created plane/apps/api/.env"
fi

set_env "$PLANE_API_ENV" "DEBUG" "1"
set_env "$PLANE_API_ENV" "CORS_ALLOWED_ORIGINS" "\"${PLANE_DEV_BASE_URL},http://localhost:${PLANE_DEV_HTTP_PORT}\""
set_env "$PLANE_API_ENV" "POSTGRES_HOST" "\"plane-db\""
set_env "$PLANE_API_ENV" "DATABASE_URL" "postgresql://\${POSTGRES_USER}:\${POSTGRES_PASSWORD}@\${POSTGRES_HOST}:\${POSTGRES_PORT}/\${POSTGRES_DB}"
set_env "$PLANE_API_ENV" "REDIS_HOST" "\"plane-redis\""
set_env "$PLANE_API_ENV" "REDIS_URL" "\"redis://\${REDIS_HOST}:6379/\""
set_env "$PLANE_API_ENV" "RABBITMQ_HOST" "\"plane-mq\""
set_env "$PLANE_API_ENV" "AWS_S3_ENDPOINT_URL" "\"http://plane-minio:9000\""
set_env "$PLANE_API_ENV" "USE_MINIO" "1"
set_env "$PLANE_API_ENV" "WEB_URL" "\"${PLANE_DEV_BASE_URL}\""
set_env "$PLANE_API_ENV" "ADMIN_BASE_URL" "\"${PLANE_DEV_BASE_URL}\""
set_env "$PLANE_API_ENV" "SPACE_BASE_URL" "\"${PLANE_DEV_BASE_URL}\""
set_env "$PLANE_API_ENV" "APP_BASE_URL" "\"${PLANE_DEV_BASE_URL}\""
set_env "$PLANE_API_ENV" "LIVE_BASE_URL" "\"${PLANE_DEV_BASE_URL}\""

cat <<EOF
Local dev environment prepared.

Project: $COMPOSE_PROJECT_NAME
URL:     $PLANE_DEV_BASE_URL

Next commands:
  make dev-up
  make smoke
EOF
