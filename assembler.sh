#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

SCRIPT_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "${SCRIPT_ROOT}/scripts/common.sh" || exit 1

show_help() {
    echo "Usage: assembler [command] [options]"
    echo ""
    echo "Commands:"
    echo "  clone      Clone or update repositories"
    echo "  deploy     Deploy the projects"
    echo "  certs      Copy SSL certificates from Let's Encrypt"
    echo "  drop       Stop and remove containers, optionally delete their images"
    echo "  install    Install the script and create a symbolic link in /usr/local/bin"
    echo "  uninstall  Remove the symbolic link created by install"
    echo "  update     Update assembler by checking for the latest version from Github"
    echo ""
    echo "Options:"
    echo "  --branch BRANCH       Specify a branch for cloning/updating (optional for clone)"
    echo "  --project PROJECT     Specify a project to clone/update or deploy (optional for clone, deploy, drop)"
    echo "  --no-proxy            Disable reverse proxy (optional for deploy)"
    echo "  --no-management       Disable management tools (optional for deploy, drop)"
    echo "  --letsencrypt DOMAIN  Specify the Let's Encrypt domain name (required for certs)"
    echo "  --destination DOMAIN  Specify the destination domain name (required for certs)"
    echo "  --remove-images       Remove Docker images after stopping and removing containers (optional for drop)"
}

if [ -z "$1" ]; then
    show_help
    exit 1
fi

COMMAND=$1
shift

handle_error() {
    local message=$1
    error "$message"
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

    $SCRIPT_ROOT/scripts/clone_projects.sh ${TARGET_REPO:+--project $TARGET_REPO} ${BRANCH:+--branch $BRANCH}
    ;;
deploy)
    PROXY_FLAG="--proxy"
    MANAGEMENT_FLAG="--management"
    TARGET_REPO=""

    while [[ "$1" =~ ^-- ]]; do
        case $1 in
        --no-proxy)
            PROXY_FLAG=""
            shift
            ;;
        --no-management)
            MANAGEMENT_FLAG=""
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

    $SCRIPT_ROOT/scripts/deploy.sh ${TARGET_REPO:+--project $TARGET_REPO} $PROXY_FLAG $MANAGEMENT_FLAG
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

    $SCRIPT_ROOT/scripts/copy_certs.sh "$LETSENCRYPT_PATH" "$DESTINATION_PATH"
    ;;
drop)
    PROXY_FLAG="--proxy"
    MANAGEMENT_FLAG="--management"
    REMOVE_IMAGES_FLAG=""
    TARGET_REPO=""

    while [[ "$1" =~ ^-- ]]; do
        case $1 in
        --no-proxy)
            PROXY_FLAG=""
            shift
            ;;
        --no-management)
            MANAGEMENT_FLAG=""
            shift
            ;;
        --remove-images)
            REMOVE_IMAGES_FLAG="--remove-images"
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
            handle_error "Unknown option: $1 for drop command."
            ;;
        esac
    done

    check_for_extra_arguments "$@"

    $SCRIPT_ROOT/scripts/drop.sh ${TARGET_REPO:+--project $TARGET_REPO} $PROXY_FLAG $MANAGEMENT_FLAG $REMOVE_IMAGES_FLAG
    ;;
install)
    SCRIPT_PATH="$SCRIPT_ROOT/assembler.sh"
    SYMLINK_PATH="/usr/local/bin/assembler"

    if [[ ! -f "$SCRIPT_PATH" ]]; then
        handle_error "Script not found at $SCRIPT_PATH"
    fi

    if [[ -L "$SYMLINK_PATH" ]]; then
        warn "Assembler already installed."
        sudo ln -sf "$SCRIPT_PATH" "$SYMLINK_PATH"
    else
        info "Installing assembler..."
        sudo ln -s "$SCRIPT_PATH" "$SYMLINK_PATH"
    fi

    success "Installation complete. You can now run 'assembler' from anywhere."
    ;;
uninstall)
    SYMLINK_PATH="/usr/local/bin/assembler"

    if [[ -L "$SYMLINK_PATH" ]]; then
        info "Uninstallating assembler..."
        sudo rm "$SYMLINK_PATH"
        success "Uninstallation complete. You can no longer run 'assembler' from the command line."
    else
        warn "Assembler is not installed."
    fi
    ;;
update)
    VERSION_FILE="$SCRIPT_ROOT/VERSION"
    CURRENT_VERSION=$(cat "$VERSION_FILE")

    info "Checking for updates..."
    git fetch --tags

    LATEST_VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))

    if [ -z "$LATEST_VERSION" ]; then
        error "Could not fetch the latest version from GitHub."
        exit 1
    fi

    echo "Current Version: $CURRENT_VERSION"
    echo "Latest Version: $LATEST_VERSION"

    if compare_versions "$LATEST_VERSION" "$CURRENT_VERSION"; then
        read -p "An update is available. Would you like to proceed? (y/n) " choice
        case "$choice" in
        y | Y)
            info "Updating to version $LATEST_VERSION..."
            git fetch --tags
            git checkout "$LATEST_VERSION"
            success "Update successful. You are now on version $LATEST_VERSION."
            ;;
        n | N)
            warn "Update canceled."
            ;;
        *)
            error "Invalid choice. Update canceled."
            ;;
        esac
    else
        warn "You are already on the latest version."
    fi
    ;;
*)
    handle_error "Unknown command: $COMMAND."
    ;;
esac
