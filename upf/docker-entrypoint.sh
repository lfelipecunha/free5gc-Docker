#!/bin/bash

function echo_error() {
    echo "Error"
    echo $1

    exit -1
}

if [ -z $DN_INTERFACE ]; then
    echo_error "DN_INTERFACE env var must be defined"
fi

if ! grep "uptun" /proc/net/dev > /dev/null; then
    ip tuntap add name uptun mode tun
fi
ip addr del 45.45.0.1/16 dev uptun 2> /dev/null
ip addr add 45.45.0.1/16 dev uptun
ip addr del cafe::1/64 dev uptun 2> /dev/null
ip addr add cafe::1/64 dev uptun
ip link set uptun up

iptables -C FORWARD -i uptun -o $DN_INTERFACE -j ACCEPT
output=$?
if [ $output -eq 1 ]; then
    echo "Masquerade..."
    iptables -t nat -A POSTROUTING -o $DN_INTERFACE -j MASQUERADE
    echo "Conntrack..."
    iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    echo "Uptun..."
    iptables -A FORWARD -i uptun -o $DN_INTERFACE -j ACCEPT
fi

touch /free5gc/install/var/log/free5gc/free5gc.log
tail -f /free5gc/install/var/log/free5gc/free5gc.log &

/free5gc/free5gc-upfd
