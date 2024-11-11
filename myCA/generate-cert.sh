#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Check if Easy-RSA is available
if ! command -v easyrsa &> /dev/null; then
  echo "Easy-RSA is not installed or not in your PATH."
  exit 1
fi

# Check if the correct arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <name> <iplist>"
  echo "Example: $0 server \"192.168.0.122,127.0.0.1\""
  exit 1
fi

# Retrieve input arguments
NAME="$1"
IPLIST="$2"

# Define file paths for the certificate and key
CERT_FILE="${EASYRSA_PKI}/issued/${NAME}.crt"
KEY_FILE="${EASYRSA_PKI}/private/${NAME}.key"

# Check if the certificate and key already exist
if [ -f "$CERT_FILE" ] && [ -f "$KEY_FILE" ]; then
  echo "Certificate and key for '$NAME' already exist. Skipping generation."
  exit 0
fi

# Parse the IPLIST into SAN format, adding IP: prefix to each IP address
SAN=""
for IP in $(echo "$IPLIST" | tr ',' ' '); do
  SAN+="IP:${IP},"
done
# Remove trailing comma
SAN="${SAN%,}"

# Run Easy-RSA commands to generate the certificate and key
# Initialize PKI if it does not exist
if [ ! -d "${EASYRSA_PKI}" ]; then
  echo "Initializing PKI directory..."
  easyrsa init-pki
fi

# Build the certificate with the custom SANs, suppressing prompts with --batch
echo "Building certificate for $NAME with IPs: $IPLIST"
easyrsa --batch --subject-alt-name="$SAN" build-server-full "$NAME" nopass


COMBINED_FILE="${EASYRSA_PKI}/private/${NAME}-combined.pem"
FULL_FILE="${EASYRSA_PKI}/private/${NAME}-full.pem"

cat $CERT_FILE  $KEY_FILE > $COMBINED_FILE
cat $COMBINED_FILE $EASYRSA_PKI/ca.crt > $FULL_FILE

echo "Certificate generated: $CERT_FILE"
echo "Key generated: $KEY_FILE"