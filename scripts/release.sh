#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

set -e

generate_changelog() {
    local bump_type=$1
    echo "Generating changelog..."
    git-changelog -B "$bump_type" -c angular --output CHANGELOG.md
}

commit_changelog() {
    echo "Committing changelog..."
    git add CHANGELOG.md
    git commit -m "chore: update changelog for version bump"
}

bump_version() {
    local bump_type=$1
    echo "Bumping $bump_type version in VERSION file..."
    bump-my-version bump "$bump_type" VERSION \
        --config-file .bumpversion.toml \
        --verbose
}

main() {
    if [[ "$1" != "patch" && "$1" != "minor" && "$1" != "major" ]]; then
        echo "Usage: ./release.sh [patch|minor|major]"
        exit 1
    fi

    local bump_type=$1

    generate_changelog "$bump_type"
    commit_changelog

    bump_version "$bump_type"

    echo "Release process completed successfully!"
    echo "Don't forget to push the changes using 'git push --tags'."
}

main "$1"
