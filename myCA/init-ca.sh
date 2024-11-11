#!/bin/bash

# Define the path to the PKI folder and the CA certificate
#PKI_DIR="${EASYRSA_DIR}/pki"
CA_CERT="$EASYRSA_PKI/ca.crt"

# Check if the PKI directory exists; if not, initialize it
if [ ! -d "$EASYRSA_PKI" ]; then
  echo "PKI directory not found. Initializing PKI..."
  ./easyrsa init-pki
else
  echo "PKI directory already exists."
fi

# Check if the CA certificate exists; if not, create it
if [ ! -f "$CA_CERT" ]; then
  echo "CA certificate not found. Building CA..."
  ./easyrsa --batch --nopass build-ca
else
  echo "CA certificate already exists."
fi