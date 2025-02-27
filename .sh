repomix --no-file-summary --no-security-check \
  --include "src/**,docker-compose.yml" \
  --output "repopack.yml"


docker build -t dublok/crowdsec:latest -f src/Dockerfile src
