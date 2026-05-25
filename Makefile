SHELL := /usr/bin/env bash

COMPOSE_PROJECT_NAME ?= art-plane-dev
PLANE_DIR := plane
DEV_COMPOSE_FILE := $(PLANE_DIR)/deployments/cli/community/docker-compose.yml
SOURCE_COMPOSE_FILE := $(PLANE_DIR)/docker-compose.yml
COMPOSE := docker compose --project-name $(COMPOSE_PROJECT_NAME) --env-file .env --file $(DEV_COMPOSE_FILE)
SOURCE_COMPOSE := docker compose --project-name $(COMPOSE_PROJECT_NAME)-source --env-file $(PLANE_DIR)/.env --file $(SOURCE_COMPOSE_FILE)
DEV_BUILD_ENV := BUILDX_NO_DEFAULT_ATTESTATIONS=1

.PHONY: dev-setup dev-up dev-down dev-logs dev-ps dev-build-source smoke

dev-setup:
	bash scripts/setup_dev.sh

dev-up: dev-setup
	$(COMPOSE) up -d

dev-down:
	$(COMPOSE) down

dev-logs:
	$(COMPOSE) logs -f

dev-ps:
	$(COMPOSE) ps

dev-build-source: dev-setup
	$(DEV_BUILD_ENV) $(SOURCE_COMPOSE) --project-directory $(PLANE_DIR) up -d --build

smoke:
	bash scripts/smoke_test.sh
