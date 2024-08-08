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
    --project)
        shift
        TARGET_REPO=$1
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

if [ -n "$TARGET_REPO" ]; then
    if [ ! -d "$PROJECTS_DIR/$TARGET_REPO" ]; then
        echo "Error: Project directory $TARGET_REPO not found in $PROJECTS_DIR."
        exit 1
    fi

    export "${TARGET_REPO^^}_PATH=$PROJECTS_DIR/$TARGET_REPO"

    echo "Deploying project: $TARGET_REPO"
    echo "Running command: $DOCKER_COMPOSE_CMD up --build -d $TARGET_REPO"
    if ! $DOCKER_COMPOSE_CMD up --build -d $TARGET_REPO; then
        echo "Error: Docker Compose failed for project $TARGET_REPO."
        exit 1
    fi
else
    echo "Deploying all projects."
    if [ -z "$(ls -A "$PROJECTS_DIR"/*/ 2>/dev/null)" ]; then
        echo "Error: No projects found in $PROJECTS_DIR. Clone projects before deploying."
        exit 1
    fi

    for dir in "$PROJECTS_DIR"/*/; do
        repo_name=$(basename "$dir")
        echo "- $repo_name"
        export "${repo_name^^}_PATH=$PROJECTS_DIR/$repo_name"
    done

    echo "Running command: $DOCKER_COMPOSE_CMD up --build -d"
    if ! $DOCKER_COMPOSE_CMD up --build -d; then
        echo "Error: Docker Compose failed."
        exit 1
    fi
fi

echo "Deployment completed successfully."
