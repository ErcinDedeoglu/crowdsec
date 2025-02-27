#!/bin/bash

# Create acquis.yaml from environment variables
if [ ! -z "$CROWDSEC_SOURCES" ]; then
    echo "$CROWDSEC_SOURCES" > /etc/crowdsec/acquis.yaml
fi

# Update the CrowdSec hub index
echo "Updating CrowdSec hub index..."
cscli hub update || (echo "Hub update failed" && exit 1)

# Install and enable parsers
echo "Installing and enabling parsers..."
cscli parsers install crowdsecurity/traefik-logs && \
cscli parsers enable crowdsecurity/traefik-logs || (echo "Failed to install/enable traefik-logs parser" && exit 1)

cscli parsers install crowdsecurity/docker-logs && \
cscli parsers enable crowdsecurity/docker-logs || (echo "Failed to install/enable docker-logs parser" && exit 1)

cscli parsers install crowdsecurity/syslog-logs && \
cscli parsers enable crowdsecurity/syslog-logs || (echo "Failed to install/enable syslog-logs parser" && exit 1)

# Install collections
echo "Installing collections..."
cscli collections install crowdsecurity/linux || (echo "Failed to install linux collection" && exit 1)
cscli collections install crowdsecurity/traefik || (echo "Failed to install traefik collection" && exit 1)
cscli collections install crowdsecurity/whitelist-good-actors || (echo "Failed to install whitelist-good-actors collection" && exit 1)
cscli collections install crowdsecurity/base-http-scenarios || (echo "Failed to install base-http-scenarios collection" && exit 1)
cscli collections install crowdsecurity/http-cve || (echo "Failed to install http-cve collection" && exit 1)
cscli collections install crowdsecurity/sshd || (echo "Failed to install sshd collection" && exit 1)
cscli collections install crowdsecurity/http-dos || (echo "Failed to install http-dos collection" && exit 1)

# Execute original entrypoint
exec /docker_start.sh "$@"