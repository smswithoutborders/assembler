#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

# ANSI color codes
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_RED='\033[1;31m'
BOLD_CYAN='\033[1;36m'
RESET='\033[0m'

CHECK_MARK="\xE2\x9C\x94"
CROSS_MARK="\xE2\x9D\x8C"

SCRIPT_NAME="$(basename "$0")"
CROS_LOG_PREFIX="${SCRIPT_NAME}"

_message() {
    local prefix="$1${CROS_LOG_PREFIX}"
    local symbol="$2"
    shift 2
    if [[ $# -eq 0 ]]; then
        echo -e "${prefix}: ${symbol}${RESET}" >&2
        return
    fi
    (
        IFS=$'\n'
        set +f
        set -- $*
        IFS=' '
        if [[ $# -eq 0 ]]; then
            set -- ''
        fi
        for line in "$@"; do
            echo -e "${prefix}: ${symbol} ${line}${RESET}" >&2
        done
    )
}

info() {
    _message "${BOLD_CYAN}INFO    | " " " "$*"
}

warn() {
    _message "${BOLD_YELLOW}WARNING | " " " "$*"
}

error() {
    _message "${BOLD_RED}ERROR   | " "$CROSS_MARK" "$*"
}

success() {
    _message "${BOLD_GREEN}SUCCESS | " "$CHECK_MARK" "$*"
}

load_env_from_file() {
    local env_file="$1"

    info "Exporting environment variables from '${env_file}'..."
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ ! -z "$line" && "$line" != \#* ]]; then
            key=$(echo "$line" | cut -d '=' -f 1)
            value=$(echo "$line" | cut -d '=' -f 2-)

            if [[ -n "${!key}" && "${!key}" == "$value" ]]; then
                warn "Skipping ${key}: already set with the same value."
            else
                export "$line"
            fi
        fi
    done <"$env_file"
    success "Environment variables have been exported from '${env_file}'."
}

compare_versions() {
    local latest_version=$1
    local current_version=$2

    if [ "$(printf '%s\n' "$current_version" "$latest_version" | sort -V | head -n1)" = "$current_version" ] && [ "$current_version" != "$latest_version" ]; then
        return 0
    else
        return 1
    fi
}
