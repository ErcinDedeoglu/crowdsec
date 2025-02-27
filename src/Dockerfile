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
    # Install parsers
    cscli parsers install crowdsecurity/traefik-logs && \
    cscli parsers install crowdsecurity/docker-logs && \
    cscli parsers install crowdsecurity/syslog-logs && \
    # Install base collections
    cscli collections install crowdsecurity/linux && \
    cscli collections install crowdsecurity/traefik && \
    cscli collections install crowdsecurity/whitelist-good-actors && \
    # Install security collections
    cscli collections install crowdsecurity/base-http-scenarios && \
    cscli collections install crowdsecurity/http-cve && \
    # Install brute force protection
    cscli collections install crowdsecurity/sshd && \
    # Install additional HTTP security
    cscli collections install crowdsecurity/http-dos

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]