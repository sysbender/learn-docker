configure ssl:

https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitornetworkports#Add_a_network_input_to_a_forwarder_and_send_the_data_to_Splunk_Cloud_Platform

[Configure an encrypted TCP network input over SSL](https://docs.splunk.com/Documentation/Splunk/9.3.1/Security/HowtoprepareyoursignedcertificatesforSplunk)


https://docs.nxlog.co/integrate/splunk.html#setup-tls

concept 
search MTLS everything you need to know

* public key - encrypt the data
* private key - decrypt the data

* one way 
    * client validate the server
    * server accept all clients
* two way


key store - contains key and certificates
trust store - ca root cert and  certificates of clients


#  server

server.conf
[sslConfig]
sslPassword = <Automatically generated>
sslRootCAPath = /opt/splunk/etc/auth/cacert.pem




[tcp-ssl://10514]
disabled = 0
sourcetype = <optional>
requireClientCert = 0


[tcp-ssl://10514]
disabled = 0
sourcetype = <optional>
requireClientCert = 0


[SSL]

serverCert = $SPLUNK_HOME/etc/auth/server.pem
sslRootCAPath = $SPLUNK_HOME/etc/auth/cacert.pem
sslPassword = < Enter the Password which is present in $Splunk_Home/etc/default/server.conf >



## https://docs.splunk.com/Documentation/Splunk/9.3.1/Security/AboutsecuringyourSplunkconfigurationwithSSL



logger -n 192.168.0.122 -P 26512 -T " test syslog over tcp 6512  at 9:06 good morning"

 netstat -an | grep :10514

 ```shell
echo "<142>$HOSTNAME Hello World, $RANDOM" | gnutls-cli 192.168.0.122 --port=6514 --x509cafile=/etc/syslog-ng/certs/server-cert.pem --x509certfile=/etc/syslog-ng/certs/client-cert.pem --x509keyfile=/etc/syslog-ng/certs/client-key.pem


echo "<142>$HOSTNAME Hello World, $RANDOM" | gnutls-cli 192.168.0.122 --port=26514 --x509cafile=/home/vagrant/certs/ca-cert.pem --x509certfile=/home/vagrant/certs/client-cert.pem --x509keyfile=/home/vagrant/certs/client-key.pem



echo "<142>$HOSTNAME Hello World, $RANDOM" | gnutls-cli 192.168.0.122 --port=26514 --x509cafile=../data/pki/ca.crt --x509certfile=../data/pki/issued/client.crt --x509keyfile=../data/pki/private/client.key
 ```
sudo cp my-ca.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
