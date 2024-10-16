#!/bin/bash
# This program is free software: you can redistribute it under the terms
# of the GNU General Public License, v. 3.0. If a copy of the GNU General
# Public License was not distributed with this file, see <https://www.gnu.org/licenses/>.

SCRIPT_ROOT=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
. "${SCRIPT_ROOT}/common.sh" || exit 1

letsencrypt_live="$1"
ssl_certs="$2"

LETSENCRYPT_CERTIFICATE_FILE="fullchain.pem"
LETSENCRYPT_CERTIFICATE_KEY_FILE="privkey.pem"
LETSENCRYPT_CERTIFICATE_CHAIN_FILE="chain.pem"

DESTINATION_CERTIFICATE_FILE="fullchain.pem"
DESTINATION_CERTIFICATE_KEY_FILE="privkey.pem"
DESTINATION_CERTIFICATE_CHAIN_FILE="chain.pem"

if [ ! -d "$letsencrypt_live" ]; then
    error "Let's Encrypt live directory not found: $letsencrypt_live"
    exit 1
fi

if [ ! -d "$ssl_certs" ]; then
    info "SSL certs destination directory not found: $ssl_certs. Creating it..."
    if ! mkdir -p "$ssl_certs"; then
        error "Failed to create destination directory: $ssl_certs"
        exit 1
    fi
fi

info "Setting permissions to 755 for all files and directories in $ssl_certs..."
if ! chmod -R 755 "$ssl_certs"/*; then
    error "Failed to set permissions for $ssl_certs"
    exit 1
fi

info "Copying $LETSENCRYPT_CERTIFICATE_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_FILE"; then
    error "Failed to copy $LETSENCRYPT_CERTIFICATE_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_FILE"
    exit 1
fi

info "Copying $LETSENCRYPT_CERTIFICATE_KEY_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_KEY_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"; then
    error "Failed to copy $LETSENCRYPT_CERTIFICATE_KEY_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"
    exit 1
fi

info "Copying $LETSENCRYPT_CERTIFICATE_CHAIN_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_CHAIN_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"; then
    error "Failed to copy $LETSENCRYPT_CERTIFICATE_CHAIN_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"
    exit 1
fi

success "All SSL certificates copied successfully."
exit 0
