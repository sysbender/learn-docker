# Use an official Alpine Linux image as a base
FROM alpine/openssl


# Set environment variables for EasyRSA installation
ENV EASYRSA_VERSION=3.2.1
ENV EASYRSA_DIR=/usr/local/easyrsa
ENV EASYRSA_PKI=/data/pki 
ENV PATH="${EASYRSA_DIR}:${PATH}"

ENV EASYRSA_REQ_COUNTRY="CA"
ENV EASYRSA_REQ_PROVINCE="QC"
ENV EASYRSA_REQ_CITY="Montreal"
ENV EASYRSA_REQ_ORG="test"
ENV EASYRSA_REQ_EMAIL="qa@example.com"
ENV EASYRSA_REQ_OU="qa"
ENV EASYRSA_REQ_CN="MyCA"


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

COPY init-ca.sh ${EASYRSA_DIR}/init-ca.sh
COPY generate-cert.sh ${EASYRSA_DIR}/generate-cert.sh
RUN chmod +x ${EASYRSA_DIR}/*.sh
# RUN /init-ca.sh && rm -rf /init-ca.sh

# RUN ./easyrsa init-pki
# RUN ./easyrsa --batch --nopass build-ca

# Expose EasyRSA commands
ENTRYPOINT ["/bin/bash", "-c", "${EASYRSA_DIR}/init-ca.sh && /bin/bash"]
