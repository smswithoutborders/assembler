#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

SCRIPT_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
PARENT_DIR=$(dirname "$SCRIPT_ROOT")
. "${SCRIPT_ROOT}/common.sh" || exit 1

if command -v docker compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    error "Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

load_env_from_file "$PARENT_DIR/.env.default"

if [ -f $PARENT_DIR/.env ]; then
    load_env_from_file "$PARENT_DIR/.env"
fi

if [ -z "$PROJECT_NAME" ]; then
    error "PROJECT_NAME is not found in the configuration file."
    exit 1
fi

USE_PROXY=false
INCLUDE_MANAGEMENT=false
TARGET_REPO=""

PROJECTS_DIR="$PARENT_DIR/projects"

PROJECTS_COMPOSE_FILE="$PARENT_DIR/docker-compose.projects.yml"
PROXY_COMPOSE_FILE="$PARENT_DIR/docker-compose.proxy.yml"
MANAGEMENT_COMPOSE_FILE="$PARENT_DIR/docker-compose.management.yml"
OVERRIDE_COMPOSE_FILE="$PARENT_DIR/docker-compose.override.yml"

while [[ "$1" =~ ^-- ]]; do
    case $1 in
    --proxy)
        USE_PROXY=true
        shift
        ;;
    --management)
        INCLUDE_MANAGEMENT=true
        shift
        ;;
    --project)
        shift
        TARGET_REPO=$1
        shift
        ;;
    *)
        error "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ ! -f "$PROJECTS_COMPOSE_FILE" ]; then
    error "Projects compose file not found at $PROJECTS_COMPOSE_FILE."
    exit 1
fi

if [ "$USE_PROXY" = true ] && [ ! -f "$PROXY_COMPOSE_FILE" ]; then
    error "Proxy compose file not found at $PROXY_COMPOSE_FILE."
    exit 1
fi

if [ "$INCLUDE_MANAGEMENT" = true ] && [ ! -f "$MANAGEMENT_COMPOSE_FILE" ]; then
    error "Management compose file not found at $MANAGEMENT_COMPOSE_FILE."
    exit 1
fi

DOCKER_COMPOSE_CMD="$DOCKER_COMPOSE_CMD -p $PROJECT_NAME -f $PROJECTS_COMPOSE_FILE"

if [ "$USE_PROXY" = true ]; then
    DOCKER_COMPOSE_CMD="$DOCKER_COMPOSE_CMD -f $PROXY_COMPOSE_FILE"
    if [ "$INCLUDE_MANAGEMENT" = true ]; then
        DOCKER_COMPOSE_CMD="$DOCKER_COMPOSE_CMD -f $MANAGEMENT_COMPOSE_FILE"
    fi
else
    if [ "$INCLUDE_MANAGEMENT" = true ]; then
        DOCKER_COMPOSE_CMD="$DOCKER_COMPOSE_CMD -f $MANAGEMENT_COMPOSE_FILE"
    fi
    DOCKER_COMPOSE_CMD="$DOCKER_COMPOSE_CMD -f $OVERRIDE_COMPOSE_FILE"
fi

target_name="${TARGET_REPO//_/-}"
DEPLOY_CMD="$DOCKER_COMPOSE_CMD up --build --force-recreate -d --quiet-pull $target_name"

project_dirs=()
for dir in "$PROJECTS_DIR"/*/; do
    repo_name=$(basename "$dir")
    project_dirs+=("$repo_name")
    export "${repo_name^^}_PATH=$dir"
done

if [ -n "$TARGET_REPO" ]; then
    info "Deploying project: $target_name"
else
    info "Deploying all projects in $PROJECTS_DIR:"
    for repo in "${project_dirs[@]}"; do
        info "- $repo"
    done
fi

info "Running command: $DEPLOY_CMD"
if ! $DEPLOY_CMD; then
    error "Docker Compose failed."
    exit 1
fi

success "Deployment completed successfully."
exit 0
