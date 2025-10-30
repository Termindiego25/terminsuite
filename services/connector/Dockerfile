# Dockerfile
# TerminSuite Connector — lightweight SSH tunnel container

FROM alpine:latest

# Install required tools: OpenSSH client, AutoSSH for persistent tunnels, and Bash
RUN apk add --no-cache autossh openssh bash

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Default command
CMD ["/entrypoint.sh"]