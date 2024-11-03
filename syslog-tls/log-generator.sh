#!/bin/sh

# Check if environment variables are set, otherwise use defaults
SYSLOG_SERVER=${SYSLOG_SERVER:-"localhost"}
SYSLOG_PORT=${SYSLOG_PORT:-"601"}

while true; do
    logger --tcp --server "$SYSLOG_SERVER" --port "$SYSLOG_PORT" -p local1.info "Log message generated at $(date), $RANDOM"
    sleep 5
done