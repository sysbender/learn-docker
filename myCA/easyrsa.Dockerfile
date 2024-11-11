# Use an official Alpine Linux image as a base
FROM alpine/openssl


# Set environment variables for EasyRSA installation
ENV EASYRSA_VERSION=3.2.1
ENV EASYRSA_DIR=/usr/local/easyrsa

# Install dependencies
RUN apk update && apk add --no-cache \
    bash \
    curl \
    #openssl \
    git \
    && rm -rf /var/cache/apk/*

# Download and install EasyRSA
RUN curl -L https://github.com/OpenVPN/easy-rsa/releases/download/v${EASYRSA_VERSION}/EasyRSA-${EASYRSA_VERSION}.tgz \
    | tar xz -C /usr/local && mv /usr/local/EasyRSA-${EASYRSA_VERSION} $EASYRSA_DIR

# Set EasyRSA home
WORKDIR $EASYRSA_DIR

# Initialize the PKI directory (if needed)
RUN ./easyrsa init-pki

# Expose EasyRSA commands
ENTRYPOINT ["/bin/bash", "-c", "./easyrsa"]
