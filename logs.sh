#!/bin/bash

sudo docker-compose exec "$1" bash -c "tail -f /free5gc/install/var/log/free5gc/free5gc.log"
