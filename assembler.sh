#!/bin/bash

show_help() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  clone    Clone or update repositories"
    echo "  deploy   Deploy the projects"
    echo "  certs    Copy SSL certificates from Let's Encrypt"
    echo "  drop     Stop and remove containers, optionally delete their images"
    echo ""
    echo "Options:"
    echo "  --branch BRANCH    Specify a branch for cloning/updating (optional for clone)"
    echo "  --project PROJECT  Specify a project to clone/update or deploy (optional for clone, deploy)"
    echo "  --proxy            Use reverse proxy (optional for deploy)"
    echo "  --management       Include management tools (optional for deploy, drop)"
    echo "  --letsencrypt DOMAIN Specify the Let's Encrypt domain name (required for certs)"
    echo "  --destination DOMAIN Specify the destination domain name (required for certs)"
    echo "  --remove-images    Remove Docker images after stopping and removing containers (optional for drop)"

}

if [ -z "$1" ]; then
    show_help
    exit 1
fi

COMMAND=$1
shift

handle_error() {
    local message=$1
    echo "ERROR: $message"
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
certs)
    LETSENCRYPT_DOMAIN=""
    DESTINATION_DOMAIN=""

    while [[ "$1" =~ ^-- ]]; do
        case $1 in
        --letsencrypt)
            shift
            if [[ -z "$1" || "$1" =~ ^-- ]]; then
                handle_error "Let's Encrypt domain name is required after --letsencrypt."
            fi
            LETSENCRYPT_DOMAIN=$1
            shift
            ;;
        --destination)
            shift
            if [[ -z "$1" || "$1" =~ ^-- ]]; then
                handle_error "Destination domain name is required after --destination."
            fi
            DESTINATION_DOMAIN=$1
            shift
            ;;
        *)
            handle_error "Unknown option: $1 for certs command."
            ;;
        esac
    done

    check_for_extra_arguments "$@"

    if [ -z "$LETSENCRYPT_DOMAIN" ] || [ -z "$DESTINATION_DOMAIN" ]; then
        handle_error "Both --letsencrypt and --destination options are required for certs command."
    fi

    LETSENCRYPT_PATH="/etc/letsencrypt/live/$LETSENCRYPT_DOMAIN"
    DESTINATION_PATH="/etc/ssl/certs/$DESTINATION_DOMAIN"

    ./scripts/copy_certs.sh "$LETSENCRYPT_PATH" "$DESTINATION_PATH"
    ;;
drop)
    PROXY_FLAG=""
    MANAGEMENT_FLAG=""
    REMOVE_IMAGES_FLAG=""

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
        --remove-images)
            REMOVE_IMAGES_FLAG="--remove-images"
            shift
            ;;
        *)
            handle_error "Unknown option: $1 for drop command."
            ;;
        esac
    done

    check_for_extra_arguments "$@"

    ./scripts/drop.sh $PROXY_FLAG $MANAGEMENT_FLAG $REMOVE_IMAGES_FLAG
    ;;
*)
    handle_error "Unknown command: $COMMAND."
    ;;
esac
