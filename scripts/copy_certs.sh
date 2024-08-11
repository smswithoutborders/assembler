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
    echo "ERROR: SSL certs destination directory not found: $ssl_certs"
    exit 1
fi

if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_FILE"
    exit 1
fi

if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_KEY_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_KEY_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_KEY_FILE"
    exit 1
fi

if ! cp -fL "$letsencrypt_live/$LETSENCRYPT_CERTIFICATE_CHAIN_FILE" "$ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"; then
    echo "ERROR: Failed to copy $LETSENCRYPT_CERTIFICATE_CHAIN_FILE to $ssl_certs/$DESTINATION_CERTIFICATE_CHAIN_FILE"
    exit 1
fi

echo "All SSL certificates copied successfully."
exit 0
