#!/bin/bash

disk=$(df -h | sed -n '2p' | awk '{print int($5)}')

if [[ $disk -ge 80 ]]; then
  echo "Warning, disk space is to02 low $disk"
else
    echo "All good $disk"
  
fi
