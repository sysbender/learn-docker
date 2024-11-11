


## TCP: Transport Control Protocol (TCP) network inputs
[tcp://<remote server>:<port>]  or [tcp:<port>]
* Configures the input to listen on a specific TCP network port.
* If a <remote server> makes a connection to this instance, the input uses this
  stanza to configure itself.
* If you do not specify <remote server>, this stanza matches all connections
  on the specified network port.
* Generates events with source set to "tcp:<port>", for example: tcp:514
* If you do not specify a sourcetype, the input generates events with sourcetype
  set to "tcp-raw".

  ###  Additional settings:

connection_host = [ip|dns|none]
* How the network input sets the host field for the events it generates.
* A value of "ip" sets the host to the IP address of the system sending the data.
* A value of "dns" sets the host to the reverse DNS entry for the IP address of
  the system that sends the data. For this to work correctly, set the forward
  DNS lookup to match the reverse DNS lookup in your DNS configuration.
* A value of "none" leaves the host as specified in inputs.conf, typically the
  hostname of the system running Splunk software.
* Default: dns


acceptFrom = <comma- or space-separated list>
* A list of TCP networks or addresses to accept connections from.
* Use commas or spaces to separate multiple network rules.
* The accepted formats for network and address rules are:
    1. A single IPv4 or IPv6 address (examples: "192.0.2.3", "2001:db8::2:1")
    2. A Classless Inter-Domain Routing (CIDR) block of addresses
       (examples: "192.0.2/24", "2001:DB8::/32")
    3. A DNS name. Use "*" as a wildcard.
       (examples: "myhost.example.com", "*.example.org")
    4. The wildcard "*" matches anything.
* A prefix of '!' for an entry sets a rule to deny and reject connections. The ACL
 applies rules in order, and uses the first matching rule. For example,
 the rules "!192.0.2/24, *" prevents connections from the 192.0.2/24
 network, but accepts all other connections.
* Default: * (accept from anywhere)


# SSL:

[SSL]
* Set the global specifications for receiving Secure Sockets Layer (SSL)
 communication underneath this stanza name.

serverCert = <string>
* The full path to the server certificate file.
* This file must be a Privacy-Enhanced Mail (PEM) format file.
* PEM is the most common text-based storage format for SSL certificate files.
* No default.

sslPassword = <string>
* The server certificate password, if it exists.
* Set this to a plain-text password initially.
* Upon first use, the input encrypts and rewrites the password to
  $SPLUNK_HOME/etc/system/local/inputs.conf.

password = <string>
* DEPRECATED.
* Do not use this setting. Use the 'sslPassword' setting instead.

rootCA = <string>
* DEPRECATED.
* Do not use this setting. Use 'server.conf/[sslConfig]/sslRootCAPath' instead.
* Used only if 'sslRootCAPath' is not set.
* The path must refer to a PEM format file that contains one or more root CA
  certificates that have been concatenated together.

requireClientCert = <boolean>
* Whether or not a client must present an SSL certificate to authenticate.
* A value of "true" means that clients must present a certificate to authenticate.
* Default (if using self-signed and third-party certificates): false
* Default (if using the default certificates; overrides the existing
  "false" setting): true

sslVersions = <comma-separated list>
* A list of SSL versions to support.
* The versions available are "ssl3", "tls1.0", "tls1.1", and "tls1.2"
* The special version "*" selects all supported versions. The version "tls"
  selects all versions that begin with "tls".
* To remove a version from the list, prefix it with "-".
* SSLv2 is always disabled. Specifying "-ssl2" in the version list has
  no effect.
* When configured in Federal Information Processing Standard (FIPS) mode, the
  "ssl3" version is always disabled, regardless of this configuration.
* The default can vary. See the 'sslVersions' setting in
  $SPLUNK_HOME/etc/system/default/inputs.conf for the current default.

  
sslCommonNameToCheck = <comma-separated list>
* Checks the common name of the client certificate against this list of names.
* If there is no match, assumes that the Splunk instance is not authenticated
  against this server.
* For this setting to work, you must also set 'requireClientCert' to "true".
* This setting is optional.
* Default: empty string (no common name checking)

sslAltNameToCheck = <comma-separated list>
* Checks the alternate name of the client certificate against this list of names.
* If there is no match, assumes that the Splunk instance is not authenticated
  against this server.
* For this setting to work, you must also set 'requireClientCert' to "true".
* This setting is optional.
* Default: empty string (no alternate name checking)

