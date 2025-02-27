FROM crowdsecurity/crowdsec:latest
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh && \
    cscli hub update && \
    cscli parsers install crowdsecurity/traefik-logs && \
    cscli parsers install crowdsecurity/docker-logs && \
    cscli parsers install crowdsecurity/syslog-logs && \
    cscli collections install crowdsecurity/linux
ENTRYPOINT ["/entrypoint.sh"]