#!/bin/bash

nfapi_file="$OPENAIR_HOME/ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf"

function echo_error() {
    echo "Error"
    echo $1

    exit -1
}

function setup_nfapi() {
    if [ -z $UE_INTERFACE ]; then
        echo_error "UE_INTERFACE env var must be defined"
    fi

    if [ -z $MME_INTERFACE ]; then
        echo_error "MME_INTERFACE env var must be defined"
    fi

    if [ -z $UE_IP ]; then
        echo_error "UE_IP env var must be defined"
    fi

    if [ -z $MME_IP ]; then
        echo_error "MME_IP env var must be defined"
    fi


    sed -i "s/\(local_s_if_name[ ]*\)=.*/\1= \"$UE_INTERFACE\";/" $nfapi_file

    ue_interface_ip=$(ifconfig $UE_INTERFACE | grep inet[^6] | sed 's/.*inet addr:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')
    echo "UE Interface IP: $ue_interface_ip"

    sed -i "s/\(remote_s_address[ ]*\)= .*/\1= \"$UE_IP\";/" $nfapi_file
    sed -i "s/\(local_s_address[ ]*\)=.*/\1= \"$ue_interface_ip\";/" $nfapi_file

    mme_interface_ip=$(ifconfig $MME_INTERFACE | grep inet[^6] | sed 's/.*inet addr:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')
    echo "MME Interface IP: $mme_interface_ip"

    sed -i "s/CI_MME_IP_ADDR/$MME_IP/" $nfapi_file

    sed -i "s/\(ENB_INTERFACE_NAME_FOR_S1_MME[ ]*\)=.*/\1= \"$MME_INTERFACE\"/" $nfapi_file
    sed -i "s/\(ENB_INTERFACE_NAME_FOR_S1U[ ]*\)=.*/\1= \"$MME_INTERFACE\"/" $nfapi_file
    
    sed -i "s/CI_ENB_IP_ADDR/$mme_interface_ip/" $nfapi_file
}

setup_nfapi

cd $OPENAIR_HOME/cmake_targets && sudo -E ./lte_build_oai/build/lte-softmodem -O $nfapi_file 2>&1



