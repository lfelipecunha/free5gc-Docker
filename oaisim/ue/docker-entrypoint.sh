#!/bin/bash

nfapi_file="$OPENAIR_HOME/ci-scripts/conf_files/ue.nfapi.conf"

function echo_error() {
    echo "Error"
    echo $1

    exit -1
}

function setup_nfapi() {
    if [ -z $PHYSICAL_INTERFACE ]; then
        echo_error "PHYSICAL_INTERFACE env var must be defined"
    fi

    if [ -z $eNB_IP ]; then
        echo_error "eNB_IP env var must be defined"
    fi


    sed -i "s/\(local_n_if_name[ ]*\)=.*/\1= \"$PHYSICAL_INTERFACE\";/" $nfapi_file

#    ip = $(ip addr | grep $PHYSICAL_INTERFACE -A 2 | grep inet[^6] | cut -d" " -f6 | cut -d"/" -f1)
    ip=$(ifconfig $PHYSICAL_INTERFACE | grep inet[^6] | sed 's/.*inet addr:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')
    echo "IP: $ip"

    sed -i "s/\(remote_n_address[ ]*\)= .*/\1= \"$eNB_IP\";/" $nfapi_file
    sed -i "s/\(local_n_address[ ]*\)=.*/\1= \"$ip\";/" $nfapi_file
}

data=$(cat /etc/hosts)

data2=$(echo $data | sed "s/\(::1[ ]*\)localhost/\1/")

echo $data2 > /etc/hosts

setup_nfapi

echo "Initializing NAS with S1..."

cd $OPENAIR_HOME/cmake_targets/tools && source init_nas_s1 UE

echo "Initializing UEs ..."
#cat $nfapi_file

cd $OPENAIR_HOME/cmake_targets/lte_build_oai/build && sudo -E ./lte-uesoftmodem -O $nfapi_file --L2-emul 3 --num-ues 1 2>&1



