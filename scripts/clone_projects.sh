#!/bin/bash

if ! command -v git &>/dev/null; then
    echo "Error: git is not installed. Please install git and try again."
    exit 1
fi

source ./.env.default

if [ -f ./.env ]; then
    source ./.env
fi

PROJECTS_DIR="./projects"

clone_or_update_repo() {
    local repo_name=$1
    local repo_url=$2
    local branch=$3
    local repo_dir="$PROJECTS_DIR/$repo_name"

    if [ -d "$repo_dir" ]; then
        echo "Updating repository $repo_name..."
        if ! git -C "$repo_dir" pull; then
            echo "Error: Failed to update repository $repo_name."
            exit 1
        fi
        if [ -n "$branch" ]; then
            echo "Checking out branch $branch in repository $repo_name..."
            if ! git -C "$repo_dir" checkout "$branch"; then
                echo "Error: Failed to checkout branch $branch in repository $repo_name."
                exit 1
            fi
            if ! git -C "$repo_dir" pull origin "$branch"; then
                echo "Error: Failed to pull branch $branch in repository $repo_name."
                exit 1
            fi
        fi
    else
        echo "Cloning repository $repo_name..."
        if ! git clone "$repo_url" "$repo_dir"; then
            echo "Error: Failed to clone repository $repo_name."
            exit 1
        fi
        if [ -n "$branch" ]; then
            echo "Checking out branch $branch in repository $repo_name..."
            if ! git -C "$repo_dir" checkout "$branch"; then
                echo "Error: Failed to checkout branch $branch in repository $repo_name."
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
        echo "Error: Unknown option: $1"
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
        echo "Error: Repository $TARGET_REPO not found in the configuration file."
        exit 1
    fi
else
    for var in $(compgen -A variable | grep '_GITHUB_URL$'); do
        repo_name=$(echo $var | sed 's/_GITHUB_URL//' | tr '[:upper:]' '[:lower:]')
        repo_url=${!var}
        clone_or_update_repo "$repo_name" "$repo_url" "$BRANCH"
    done
fi
