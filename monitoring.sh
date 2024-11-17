#!/bin/bash

CPU_THRESHOLD=80
MEM_THRESHOLD=80

CPU_USAGE=$(top -bn1 | sed -n "3p" | awk '{print int($8)}')

# GET memory memory usage

mem_usage=$(free -g | sed -n "2p" | awk '{print $3/$2 *100.0}')

if [[ $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc) -eq 1 ]]; then
  echo "Warnging: High CPU usage! Current: $CPU_USAGE"
fi

if [[ $(echo $mem_usage > $MEM_THRESHOLD | bc) -eq 1 ]]; then
  echo "Warnging! High memory usage! Current: $mem_usage"
  
fi
