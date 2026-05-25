SHELL := /usr/bin/env bash

COMPOSE_PROJECT_NAME ?= art-plane-dev
PLANE_DIR := plane
DEV_COMPOSE_FILE := $(PLANE_DIR)/deployments/cli/community/docker-compose.yml
SOURCE_COMPOSE_FILE := $(PLANE_DIR)/docker-compose.yml
COMPOSE := docker compose --project-name $(COMPOSE_PROJECT_NAME) --env-file .env --file $(DEV_COMPOSE_FILE)
SOURCE_COMPOSE := docker compose --project-name $(COMPOSE_PROJECT_NAME)-source --env-file $(PLANE_DIR)/.env --file $(SOURCE_COMPOSE_FILE)
DEV_BUILD_ENV := BUILDX_NO_DEFAULT_ATTESTATIONS=1
PNPM := corepack pnpm
TURBO := TURBO_TELEMETRY_DISABLED=1 $(PNPM) turbo run

.PHONY: dev-setup dev-up dev-down dev-reset dev-logs dev-ps plane-install check-web check-admin check-space build-web build-admin build-space dev-build-source dev-build-source-ui dev-build-source-web dev-build-source-admin dev-build-source-space smoke

dev-setup:
	bash scripts/setup_dev.sh

dev-up: dev-setup
	$(COMPOSE) up -d

dev-down:
	$(COMPOSE) down

dev-reset: dev-setup
	bash scripts/dev_reset.sh

dev-logs:
	$(COMPOSE) logs -f

dev-ps:
	$(COMPOSE) ps

plane-install:
	cd $(PLANE_DIR) && corepack enable pnpm && $(PNPM) install --frozen-lockfile

check-web:
	cd $(PLANE_DIR) && $(TURBO) check:types --filter=web

check-admin:
	cd $(PLANE_DIR) && $(TURBO) check:types --filter=admin

check-space:
	cd $(PLANE_DIR) && $(TURBO) check:types --filter=space

build-web:
	cd $(PLANE_DIR) && $(TURBO) build --filter=web

build-admin:
	cd $(PLANE_DIR) && $(TURBO) build --filter=admin

build-space:
	cd $(PLANE_DIR) && $(TURBO) build --filter=space

dev-build-source: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) up -d --build

dev-build-source-ui: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) build web admin space

dev-build-source-web: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) build web

dev-build-source-admin: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) build admin

dev-build-source-space: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) build space

smoke:
	bash scripts/smoke_test.sh
