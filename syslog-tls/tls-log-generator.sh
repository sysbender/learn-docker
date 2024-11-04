#!/bin/sh

SYSLOG_SERVER=${SYSLOG_SERVER:-"localhost"}
SYSLOG_PORT=${SYSLOG_PORT:-"6514"}
CA_CERT="/etc/syslog-ng/certs/ca-cert.pem"
CLIENT_CERT="/etc/syslog-ng/certs/client-cert.pem"
CLIENT_KEY="/etc/syslog-ng/certs/client-key.pem"

while true; do
    LOG_MESSAGE="Log message generated at $(date) - With TLS"
    
    # Send log using openssl and netcat
    echo "<13>$(date +'%b %d %H:%M:%S') $(hostname) myapp: $LOG_MESSAGE" | \
    openssl s_client -connect "$SYSLOG_SERVER:$SYSLOG_PORT" \
    -CAfile "$CA_CERT" \
    -cert "$CLIENT_CERT" \
    -key "$CLIENT_KEY" \
    -quiet \
    2>/dev/null | grep -q 'Verify return code: 0' \
    || echo "Failed to send log message over TLS. Verify return code: $?"

    sleep 5
done
