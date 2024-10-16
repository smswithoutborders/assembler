#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

SCRIPT_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
PARENT_DIR=$(dirname "$SCRIPT_ROOT")
. "${SCRIPT_ROOT}/common.sh" || exit 1

if ! command -v git &>/dev/null; then
    error "git is not installed. Please install git and try again."
    exit 1
fi

load_env_from_file "$PARENT_DIR/.env.default"

if [ -f $PARENT_DIR/.env ]; then
    load_env_from_file "$PARENT_DIR/.env"
fi

PROJECTS_DIR="$PARENT_DIR/projects"

clone_or_update_repo() {
    local repo_name=$1
    local repo_url=$2
    local branch=$3
    local repo_dir="$PROJECTS_DIR/$repo_name"

    if [ -d "$repo_dir" ]; then
        info "Updating repository $repo_name..."
        if ! git -C "$repo_dir" pull; then
            error "Failed to update repository $repo_name."
            exit 1
        fi
        if [ -n "$branch" ]; then
            info "Checking out branch $branch in repository $repo_name..."
            if ! git -C "$repo_dir" checkout "$branch"; then
                error "Failed to checkout branch $branch in repository $repo_name."
                exit 1
            fi
            if ! git -C "$repo_dir" pull origin "$branch"; then
                error "Failed to pull branch $branch in repository $repo_name."
                exit 1
            fi
        fi
    else
        info "Cloning repository $repo_name..."
        if ! git clone "$repo_url" "$repo_dir"; then
            error "Failed to clone repository $repo_name."
            exit 1
        fi
        if [ -n "$branch" ]; then
            info "Checking out branch $branch in repository $repo_name..."
            if ! git -C "$repo_dir" checkout "$branch"; then
                error "Failed to checkout branch $branch in repository $repo_name."
                exit 1
            fi
        fi
    fi
}

mkdir -p "$PROJECTS_DIR"

BRANCH=""

while [[ "$1" =~ ^-- ]]; do
    case $1 in
    --branch)
        shift
        BRANCH=$1
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

if [ -n "$TARGET_REPO" ]; then
    found=0
    for var in $(compgen -A variable | grep '_GITHUB_URL$'); do
        repo_name=$(echo $var | sed 's/_GITHUB_URL//' | tr '[:upper:]' '[:lower:]')
        repo_url=${!var}
        if [ "$repo_name" == "$TARGET_REPO" ]; then
            clone_or_update_repo "$repo_name" "$repo_url" "$BRANCH"
            found=1
            break
        fi
    done
    if [ "$found" -eq 0 ]; then
        error "Repository $TARGET_REPO not found in the configuration file."
        exit 1
    fi
else
    for var in $(compgen -A variable | grep '_GITHUB_URL$'); do
        repo_name=$(echo $var | sed 's/_GITHUB_URL//' | tr '[:upper:]' '[:lower:]')
        repo_url=${!var}
        clone_or_update_repo "$repo_name" "$repo_url" "$BRANCH"
    done
fi

success "Cloning completed successfully."
exit 0
