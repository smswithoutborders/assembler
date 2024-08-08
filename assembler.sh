#!/bin/bash

show_help() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  clone    Clone or update repositories"
    echo "  deploy   Deploy the projects"
    echo ""
    echo "Options:"
    echo "  --branch BRANCH    Specify a branch for cloning/updating (only for clone)"
    echo "  --project PROJECT  Specify a project to clone/update or deploy (optional for both commands)"
    echo "  --proxy            Use reverse proxy (only for deploy)"
    echo "  --management       Include management tools (only for deploy)"
}

if [ -z "$1" ]; then
    show_help
    exit 1
fi

COMMAND=$1
shift

handle_error() {
    local message=$1
    echo "Error: $message"
    show_help
    exit 1
}

check_for_extra_arguments() {
    if [ $# -gt 0 ]; then
        handle_error "Unexpected arguments after command: $@"
    fi
}

case $COMMAND in
clone)
    BRANCH=""
    TARGET_REPO=""

    while [[ "$1" =~ ^-- ]]; do
        case $1 in
        --branch)
            shift
            if [[ -z "$1" || "$1" =~ ^-- ]]; then
                handle_error "Branch name is required after --branch."
            fi
            BRANCH=$1
            shift
            ;;
        --project)
            shift
            if [[ -z "$1" || "$1" =~ ^-- ]]; then
                handle_error "Project name is required after --project."
            fi
            TARGET_REPO=$1
            shift
            ;;
        *)
            handle_error "Unknown option: $1 for clone command."
            ;;
        esac
    done

    check_for_extra_arguments "$@"

    ./scripts/clone_projects.sh ${TARGET_REPO:+--project $TARGET_REPO} ${BRANCH:+--branch $BRANCH}
    ;;
deploy)
    PROXY_FLAG=""
    MANAGEMENT_FLAG=""
    TARGET_REPO=""

    while [[ "$1" =~ ^-- ]]; do
        case $1 in
        --proxy)
            PROXY_FLAG="--proxy"
            shift
            ;;
        --management)
            MANAGEMENT_FLAG="--management"
            shift
            ;;
        --project)
            shift
            if [[ -z "$1" || "$1" =~ ^-- ]]; then
                handle_error "Project name is required after --project."
            fi
            TARGET_REPO=$1
            shift
            ;;
        *)
            handle_error "Unknown option: $1 for deploy command."
            ;;
        esac
    done

    check_for_extra_arguments "$@"

    ./scripts/deploy.sh ${TARGET_REPO:+--project $TARGET_REPO} $PROXY_FLAG $MANAGEMENT_FLAG
    ;;
*)
    handle_error "Unknown command: $COMMAND."
    ;;
esac
