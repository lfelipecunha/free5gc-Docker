#!/bin/bash


#Check if outbound interface was specified
#if [ ! $# -eq 2 ]
#  then
#    echo "Usage :'sudo ./iptables <LandoNet Interface> <Ethernet Interface>' "
#    exit
#fi

#echo "Masquerading Interface "$2

#echo 1 | tee /proc/sys/net/ipv4/ip_forward 1>/dev/null
iptables -t nat -A POSTROUTING -o enp3s0 -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i uptun -o enp3s0 -j ACCEPT
