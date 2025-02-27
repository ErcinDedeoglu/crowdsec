#!/bin/bash
# Create acquis.yaml from environment variables
if [ ! -z "$CROWDSEC_SOURCES" ]; then
    echo "$CROWDSEC_SOURCES" > /etc/crowdsec/acquis.yaml
fi
# Execute original entrypoint
exec /docker_start.sh "$@"