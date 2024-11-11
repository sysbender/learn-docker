

https://docs.splunk.com/Documentation/Splunk/9.3.1/Security/Howtoself-signcertificates


TLS certificate host name validation and mutually authenticated TLS (mTLS)

sslVerifyServerName : Common Name (CN) or Subject Alternative Name (SAN) X.509 cryptography standard certificate field that matches the host name of the instance that sent the certificate.

 "Create server certificates and sign them with the root certificate authority certificate" 
  create "wildcard" certificates
  You can also add Subject Alternative Name fields
# Create and self-sign a TLS certificate

## Create a root certificate authority certificate.


```shell

# create dir
mkdir $SPLUNK_HOME/etc/auth/mycerts

# ca key Create Root Key non password protected key 
openssl genrsa  -out myCertAuthPrivateKey.key 2048 #-aes256

# ca cert csr
openssl req -new -key myCertAuthPrivateKey.key -out myCertAuthCertificate.csr \
  -subj "/C=CA/ST=QC/L=Montreal/O=Intrado/OU=QA/CN=*.example.com" \
  -addext "subjectAltName=DNS:example.com,IP:127.0.0.1"

# sign ca cert
openssl x509 -req -in myCertAuthCertificate.csr -sha512 \
 -signkey myCertAuthPrivateKey.key -CAcreateserial  \
 -out myCertAuthCertificate.pem -days 1095


# one
openssl req -x509 -new -key myCertAuthPrivateKey.key -out myCertAuthCertificate.pem \
  -subj "/C=CA/ST=QC/L=Montreal/O=Intrado/OU=QA/CN=*.example.com" \
  -addext "subjectAltName=DNS:example.com,IP:127.0.0.1" -sha512 -days 1095

```


## Create server certificates and sign them with the root certificate authority certificate

```shell

# server key
openssl genrsa -aes256 -out myServerPrivateKey.key 2048

# csr


# cert


# 



```

##  How to prepare TLS certificates for use with the Splunk platform
 you must combine them with the private keys that you either received or generated to create the certificates into a single certificate file that the Splunk platform can use.
# combined certificates files. in privacy-enhanced mail (PEM) format.

```shell
cat server-cert.pem server-key.pem ca-cert.pem server-combine.pem
```

## Configure TLS certificates for forwarders

https://docs.splunk.com/Documentation/Splunk/9.3.1/Security/ConfigureSplunkforwardingtousesignedcertificates#Configure_TLS_certificates_for_forwarders

```shell
# -------------- for outputs.conf
# where : $SPLUNK_HOME/etc/auth/mycerts 
[tcpout:<name>]

server=hostname
clientCert=/opt/splunk/etc/auth/mycerts/myClientCertificate.pem
sslVerifyServerCert=false|true # 

# ----------------- server.conf
[sslConfig]
sslRootCAPath = <absolute path to the certificate authority certificate>


```
troubleshooting
https://docs.splunk.com/Documentation/Splunk/9.3.1/Security/Validateyourconfiguration


