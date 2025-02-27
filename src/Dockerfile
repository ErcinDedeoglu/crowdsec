FROM crowdsecurity/crowdsec:latest

# Set up configuration directories
RUN mkdir -p /etc/crowdsec/parsers \
    /etc/crowdsec/scenarios \
    /etc/crowdsec/postoverflows \
    /etc/crowdsec/collections \
    /var/lib/crowdsec/data

# Copy configuration from staging
RUN cp -r /staging/etc/crowdsec/* /etc/crowdsec/

# Copy our entrypoint script
COPY entrypoint.sh /

# Install parsers and collections
RUN chmod +x /entrypoint.sh && \
    cscli hub update && \
    cscli parsers install crowdsecurity/traefik-logs && \
    cscli parsers install crowdsecurity/docker-logs && \
    cscli parsers install crowdsecurity/syslog-logs && \
    cscli collections install crowdsecurity/linux

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]