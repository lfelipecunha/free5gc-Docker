#!/bin/bash


case $1 in
    'amf' | 'amf2' | 'smf' | 'pcrf' | 'hss' | 'upf')
        sudo docker-compose exec "$1" bash -c "tail -f /free5gc/install/var/log/free5gc/free5gc.log"
        ;;
    *) sudo docker-compose logs -f $1
esac
