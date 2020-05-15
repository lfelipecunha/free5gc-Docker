#!/bin/bash

sudo docker build -t free5gc-base . >/dev/null &
free5gc_pid=$!
sudo docker build -t oai-base oaisim > /dev/null &
oai_pid=$!

echo $free5gc_pid $oai_pid

wait $free5gc_pid
wait $oai_pid
