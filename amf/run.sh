#!/bin/bash

ip route add 192.188.3.0/24 via 192.188.2.2

ip=$(ip addr show eth0 | grep 'inet' | sed 's/[ ]\+inet \([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')

sed -i "s/{IP_ADDR}/$ip/g" /free5gc/install/etc/free5gc/free5gc.conf
sed -i "s/{IP_ADDR}/$ip/g" /free5gc/install/etc/free5gc/freeDiameter/amf.conf

/free5gc/free5gc-amfd
