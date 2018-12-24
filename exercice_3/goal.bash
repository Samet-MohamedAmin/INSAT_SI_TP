#!/bin/bash

IFS=: read -a commands <<< $CMD

for cmd in "${commands[@]}"
do
    read -p ">>> press <enter> to execute (${cmd}) "
    echo -e "[$(date)] >>> $CONTAINER_NAME (${cmd}):" >> $LOG_FILE
    eval ${cmd} > >(tee -a $LOG_FILE) 2> >(tee -a $LOG_FILE >&2)
    echo | tee -a $LOG_FILE
done
