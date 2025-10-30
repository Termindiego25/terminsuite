# ==========================================
# TerminSuite — Keycloak Custom Build
# ==========================================
# This image extends the official Keycloak container to include
# additional SCIM outbound provider support.
# ==========================================

FROM quay.io/keycloak/keycloak:latest

LABEL org.opencontainers.image.title="iam"

# Use PostgreSQL as the default Keycloak database
ENV KC_DB=postgres

# Copy SCIM outbound provider JARs into the Keycloak providers directory
COPY providers/ /opt/keycloak/providers/

# Build the final Keycloak distribution with all modules
RUN /opt/keycloak/bin/kc.sh build