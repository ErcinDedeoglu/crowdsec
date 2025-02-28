#!/bin/bash

# Define the bouncer token file path in the volume
BOUNCER_TOKEN_FILE="/etc/crowdsec/bouncer_token.txt"

# Create acquis.yaml from environment variables
if [ ! -z "$CROWDSEC_SOURCES" ]; then
    echo "$CROWDSEC_SOURCES" > /etc/crowdsec/acquis.yaml
fi

# Update the CrowdSec hub index
echo "Updating CrowdSec hub index..."
cscli hub update

# Install and enable parsers
echo "Installing and enabling parsers..."
PARSERS=(
    "crowdsecurity/traefik-logs"
    "crowdsecurity/docker-logs"
    "crowdsecurity/syslog-logs"
)

for parser in "${PARSERS[@]}"; do
    echo "Installing and enabling parser: $parser"
    cscli parsers install "$parser" && \
    cscli parsers enable "$parser" || \
    (echo "Failed to install/enable parser: $parser" && exit 1)
done

# Install collections
echo "Installing collections..."
COLLECTIONS=(
    "crowdsecurity/linux"
    "crowdsecurity/traefik"
    "crowdsecurity/whitelist-good-actors"
    "crowdsecurity/base-http-scenarios"
    "crowdsecurity/http-cve"
    "crowdsecurity/sshd"
    "crowdsecurity/http-dos"
)

for collection in "${COLLECTIONS[@]}"; do
    echo "Installing collection: $collection"
    cscli collections install "$collection" || \
    (echo "Failed to install collection: $collection" && exit 1)
done

# Check if bouncer token already exists
if [ ! -f "$BOUNCER_TOKEN_FILE" ]; then
    echo "Generating new bouncer token..."
    # Create bouncer and save token
    cscli bouncers add bouncer-traefik -o raw > "$BOUNCER_TOKEN_FILE"
    if [ $? -eq 0 ]; then
        echo "Bouncer token generated and saved to $BOUNCER_TOKEN_FILE"
        # Set proper permissions
        chmod 600 "$BOUNCER_TOKEN_FILE"
    else
        echo "Failed to generate bouncer token"
        exit 1
    fi
else
    echo "Bouncer token already exists at $BOUNCER_TOKEN_FILE"
fi

# Execute original entrypoint
exec /docker_start.sh "$@"