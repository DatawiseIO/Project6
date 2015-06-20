#!/bin/bash

# Name prefix
NAME_PREFIX="zk"

# Number of instances to configure
NUM_INSTANCES=3

# dwctl binary
DWCTL=/home/dws/bin/dwctl

# Create volumes
for INSTANCE in `seq 1 ${NUM_INSTANCES}`
do
	${DWCTL} volume delete ${NAME_PREFIX}-vg${INSTANCE}
done

# Create pods
for INSTANCE in `seq 1 ${NUM_INSTANCES}`
do
	${DWCTL} pod delete ${NAME_PREFIX}-${INSTANCE}	 
done
