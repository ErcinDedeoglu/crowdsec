FROM crowdsecurity/crowdsec:latest

# Set up configuration directories
RUN mkdir -p /etc/crowdsec/parsers \
    /etc/crowdsec/scenarios \
    /etc/crowdsec/postoverflows \
    /etc/crowdsec/collections \
    /var/lib/crowdsec/data

# Copy our entrypoint script
COPY entrypoint.sh /

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]