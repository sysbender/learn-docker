# Dockerfile for TLS log generator
FROM debian:bullseye

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssl \
    ca-certificates \
    gnutls-bin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the log generator script and certificates
COPY tls-log-generator.sh /usr/local/bin/tls-log-generator.sh
COPY certs /etc/syslog-ng/certs   

# Update CA certificates
RUN update-ca-certificates

# Make the script executable
RUN chmod +x /usr/local/bin/tls-log-generator.sh

# Verify gnutls-cli installation
RUN gnutls-cli --version

ENTRYPOINT ["/usr/local/bin/tls-log-generator.sh"]
