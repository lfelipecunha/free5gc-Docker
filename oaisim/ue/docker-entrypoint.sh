#!/bin/bash

nfapi_file="$OPENAIR_HOME/ci-scripts/conf_files/ue.nfapi.conf"
chips_file="$OPENAIR_HOME/openair3/NAS/TOOLS/ue_eurecom_test_sfr.conf"

function echo_error() {
    echo "Error"
    echo $1

    exit -1
}

function verify_env_vars() {
    if [ -z $PHYSICAL_INTERFACE ]; then
        echo_error "PHYSICAL_INTERFACE env var must be defined"
    fi

    if [ -z $eNB_IP ]; then
        echo_error "eNB_IP env var must be defined"
    fi

    if [ -z $FREE5G_WEB_URL ]; then
        echo_error "FREE5G_WEB_URL env var must be defined"
    fi

    if [ -z $NUM_UES ]; then
        NUM_UES=1
    fi

}

function setup_nfapi() {
    sed -i "s/\(local_n_if_name[ ]*\)=.*/\1= \"$PHYSICAL_INTERFACE\";/" $nfapi_file

    ip=$(ifconfig "$PHYSICAL_INTERFACE" | grep inet[^6] | sed 's/.*inet addr:\([0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\).*/\1/')
    echo "IP: $ip"

    sed -i "s/\(remote_n_address[ ]*\)= .*/\1= \"$eNB_IP\";/" $nfapi_file
    sed -i "s/\(local_n_address[ ]*\)=.*/\1= \"$ip\";/" $nfapi_file

}

function setup_chips() {
    register_ues $chips_file
    if [ $? -ne 0 ]; then
        exit 1
    fi

    cd $OPENAIR_HOME/targets/bin && ./conf2uedata -c $chips_file -o $OPENAIR_HOME/cmake_targets/ran_build/build/
    cp $OPENAIR_HOME/cmake_targets/ran_build/build/.uisim.nvram0 $OPENAIR_HOME/targets/bin/
}

function changing_hosts_file() {
    data=$(cat /etc/hosts)
    #remove duplicated entry of localhost, because bind function generate an error to bind socket on localhost
    data2=$(echo $data | sed "s/\(::1[ ]*\)localhost/\1/")
    echo $data2 > /etc/hosts
}

function init() {
    echo "Verifiyng environments vars..."
    verify_env_vars

    echo "Changing host file..."
    changing_hosts_file

    echo "Setup nfapi file..."
    setup_nfapi

    echo "Generating UE data..."
    setup_chips

    echo "Initializing UEs ..."
#    cd $OPENAIR_HOME/cmake_targets/lte_build_oai/build && sudo -E ./lte-uesoftmodem -O $nfapi_file --L2-emul 3 --num-ues $NUM_UES 2>&1
    cd $OPENAIR_HOME/cmake_targets/ran_build/build && sudo -E ./lte-uesoftmodem -O $nfapi_file --L2-emul 3 --num-ues $NUM_UES --nums_ue_thread 1 --nokrnmod 1 2>&1
}

init
