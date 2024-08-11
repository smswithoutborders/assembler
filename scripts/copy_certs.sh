#!/bin/bash

letsencrypt_live="$1"
ssl_certs="$2"

LETSENCRYPT_CERTIFICATE_FILE="fullchain.pem"
LETSENCRYPT_CERTIFICATE_KEY_FILE="privkey.pem"
LETSENCRYPT_CERTIFICATE_CHAIN_FILE="chain.pem"

DESTINATION_CERTIFICATE_FILE="fullchain.pem"
DESTINATION_CERTIFICATE_KEY_FILE="privkey.pem"
DESTINATION_CERTIFICATE_CHAIN_FILE="chain.pem"

if [ ! -d "$letsencrypt_live" ]; then
    echo "ERROR: Let's Encrypt live directory not found: $letsencrypt_live"
    exit 1
fi

if [ ! -d "$ssl_certs" ]; then
    echo "SSL certs destination directory not found: $ssl_certs. Creating it..."
    if ! mkdir -p "$ssl_certs"; then
        echo "ERROR: Failed to create destination directory: $ssl_certs"
        exit 1
    fi
fi

echo "Setting permissions to 755 for $ssl_certs..."
if ! chmod -R 755 "$ssl_certs"; then
    echo "ERROR: Failed to set permissions for $ssl_certs"
    exit 1
fi

echo "Copying $LETSENCRYPT_CERTIFICATE_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_FILE"
    exit 1
fi

echo "Copying $LETSENCRYPT_CERTIFICATE_KEY_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_KEY_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_KEY_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"
    exit 1
fi

echo "Copying $LETSENCRYPT_CERTIFICATE_CHAIN_FILE from $letsencrypt_live to $ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE..."
if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_CHAIN_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_CHAIN_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"
    exit 1
fi

echo "All SSL certificates copied successfully."
exit 0
