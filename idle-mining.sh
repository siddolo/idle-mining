#!/bin/bash
LIMIT=60
NICE=19

function run() {
   pidof minerd > /dev/null || nice -n $NICE ./minerd -c config.json -B
}

function stop() {
   pidof minerd && killall minerd
}

while true; do
   idle=$(mpstat 1 2 | grep Average | awk '{print $12}')
   echo "idle is $idle"
   if [[ $idle > $LIMIT ]]; then
      echo "idle above $LIMIT%"
      run
   else
      echo "idle below $LIMIT%"
      stop
   fi
      sleep 1
done
