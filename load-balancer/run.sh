#!/bin/bash
# This runs INSIDE the docker container.


# Make sure we react to these signals by running stop() when we see them - for clean shutdown
# And then exiting
trap "stop; exit 0;" SIGTERM SIGINT

stop()
{
  # We're here because we've seen SIGTERM, likely via a Docker stop command or similar
  # Let's shutdown cleanly
  echo "SIGTERM caught, terminating keepalived process..."
  # Record PIDs
  #pid=$$
  pid=$(pidof keepalived)
  # Kill them
  kill -TERM $pid > /dev/null 2>&1
  # Wait till they have been killed
  wait $pid
  echo "Terminated."
  exit 0
}

# register self as a Round Robin load balancer
#ipvsadm -A --sctp-service 192.188.3.1:36412 -s rr

# add aditional hots
#ipvsadm -a --sctp-service 192.188.3.1:36412 -r 192.188.2.21:36412 -m

keepalived -D -l -n
pid=$(pidof keepalived)
wait $pid

# Exit with an error
exit 1


