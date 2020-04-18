#!/bin/bash

nfapi_file="$OPENAIR_HOME/ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf"

function echo_error() {
    echo "Error"
    echo $1

    exit -1
}

function setup_nfapi() {
    if [ -z $PHYSICAL_INTERFACE ]; then
        echo_error "PHYSICAL_INTERFACE env var must be defined"
    fi

    if [ -z $UE_IP ]; then
        echo_error "UE_IP env var must be defined"
    fi

    if [ -z $MME_IP ]; then
        echo_error "MME_IP env var must be defined"
    fi


    sed -i "s/\(local_s_if_name[ ]*\)=.*/\1= \"$PHYSICAL_INTERFACE\";/" $nfapi_file

#    ip = $(ip addr | grep $PHYSICAL_INTERFACE -A 2 | grep inet[^6] | cut -d" " -f6 | cut -d"/" -f1)
    ip=$(ifconfig $PHYSICAL_INTERFACE | grep inet[^6] | sed 's/.*inet addr:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')
    echo "IP: $ip"

    sed -i "s/\(local_s_address[ ]*\)= .*/\1= \"$UE_IP\";/" $nfapi_file
    sed -i "s/\(remote_s_address[ ]*\)=.*/\1= \"$ip\";/" $nfapi_file

    echo "1"
    sed -i "s/CI_MME_IP_ADDR/$MME_IP/" $nfapi_file
    echo "2"

    sed -i "s/\(ENB_INTERFACE_NAME_FOR_S1_MME[ ]*\)=.*/\1= \"$PHYSICAL_INTERFACE\"/" $nfapi_file
    echo "3"
    sed -i "s/CI_ENB_IP_ADDR/$ip/" $nfapi_file
}

setup_nfapi

#echo "Initializing NAS with S1..."

#cd $OPENAIR_HOME/cmake_targets/tools && source init_nas_s1 UE

#echo "Initializing UEs ..."

cd $OPENAIR_HOME/cmake_targets && sudo -E ./lte_build_oai/build/lte-softmodem -O $nfapi_file 2>&1



