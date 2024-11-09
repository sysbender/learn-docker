#!/bin/bash

# Ensure proper ownership for Splunk directories
echo "Setting ownership of /opt/splunkforwarder to splunk:splunk..."
chown -R splunk:splunk /opt/splunkforwarder

# Now, start Splunk
echo "Starting Splunk Universal Forwarder..."
exec /opt/splunkforwarder/bin/splunk start --nodaemon --accept-license "$@"
