#!/bin/bash

certificate_path='/free5gc/install/etc/free5gc/freeDiameter'
amf_name=$AMF_NAME
ip=$(ip addr show eth0 | grep 'inet' | sed 's/[ ]\+inet \([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')

# enb route
ip route add 192.188.3.0/24 via 192.188.2.2

# hss route
#ip route add 192.188.2.3 via 192.188.2.2


sed -i "s/{IP_ADDR}/$ip/g" /free5gc/install/etc/free5gc/free5gc.conf
sed -i "s/{IP_ADDR}/$ip/g" /free5gc/install/etc/free5gc/freeDiameter/amf.conf

sed -i "s/{AMF_NAME}/$amf_name/g" /free5gc/install/etc/free5gc/freeDiameter/amf.conf


#certificate
rm -rf demoCA
mkdir demoCA
echo 01 > demoCA/serial
touch demoCA/index.txt
# CA self certificate
openssl req  -new -batch -x509 -days 3650 -nodes -newkey rsa:1024 -out $certificate_path/cacert.pem -keyout cakey.pem -subj /CN=ca.localdomain/C=TW/ST=Taiwan/L=HsinChu/O=free5GC/OU=Tests

#amf certificate
openssl genrsa -out $certificate_path/amf.key.pem 1024
openssl req -new -batch -out amf.csr.pem -key $certificate_path/amf.key.pem -subj /CN=$amf_name.localdomain/C=TW/ST=Taiwan/L=HsinChu/O=free5GC/OU=Tests
openssl ca -cert $certificate_path/cacert.pem -keyfile cakey.pem -in amf.csr.pem -out $certificate_path/amf.cert.pem -outdir . -batch

rm -f amf.csr.pem
rm -f cakey.pem
rm -rf demoCA

# start loging
touch /free5gc/install/var/log/free5gc/free5gc.log
tail -f /free5gc/install/var/log/free5gc/free5gc.log &

/free5gc/free5gc-amfd
