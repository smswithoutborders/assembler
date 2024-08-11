#!/bin/bash

if command -v docker-compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker-compose"
elif command -v docker compose >/dev/null 2>&1; then
    DOCKER_COMPOSE_CMD="docker compose"
else
    echo "Error: Docker Compose is not installed. Please install Docker Compose and try again."
    exit 1
fi

export $(grep -v '^#' ./.env.default | xargs)

if [ -f ./.env ]; then
    export $(grep -v '^#' ./.env | xargs)
fi

if [ -z "$PROJECT_NAME" ]; then
    echo "Error: PROJECT_NAME is not found in the configuration file."
    exit 1
fi

USE_PROXY=false
INCLUDE_MANAGEMENT=false
REMOVE_IMAGES=false
TARGET_REPO=""

PROJECTS_DIR="./projects"

PROJECTS_COMPOSE_FILE="./docker-compose.projects.yml"
PROXY_COMPOSE_FILE="./docker-compose.proxy.yml"
MANAGEMENT_COMPOSE_FILE="./docker-compose.management.yml"
OVERRIDE_COMPOSE_FILE="./docker-compose.override.yml"

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
    --remove-images)
        REMOVE_IMAGES=true
        shift
        ;;
    *)
        echo "Error: Unknown option: $1"
        exit 1
        ;;
    esac
done

if [ ! -f "$PROJECTS_COMPOSE_FILE" ]; then
    echo "Error: Projects compose file not found at $PROJECTS_COMPOSE_FILE."
    exit 1
fi

if [ "$USE_PROXY" = true ] && [ ! -f "$PROXY_COMPOSE_FILE" ]; then
    echo "Error: Proxy compose file not found at $PROXY_COMPOSE_FILE."
    exit 1
fi

if [ "$INCLUDE_MANAGEMENT" = true ] && [ ! -f "$MANAGEMENT_COMPOSE_FILE" ]; then
    echo "Error: Management compose file not found at $MANAGEMENT_COMPOSE_FILE."
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

REMOVE_CMD="$DOCKER_COMPOSE_CMD down"
if [ "$REMOVE_IMAGES" = true ]; then
    REMOVE_CMD="$REMOVE_CMD --rmi all"
fi

echo "Running command: $REMOVE_CMD"
if ! $REMOVE_CMD; then
    echo "Error: Docker Compose failed to remove containers and images."
    exit 1
fi

echo "Drop operation completed successfully."
exit 0
