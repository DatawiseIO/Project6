#!/bin/bash

DWCTL=/home/dws/bin/dwctl

# Cassandra prefix
NAME_PREFIX=${1:-cassandra}

# Number of instances to configure
NUM_INSTANCES=${2:-3}

# Delete volumes
for INSTANCE in `seq 1 ${NUM_INSTANCES}`
do
	${DWCTL} volume delete ${NAME_PREFIX}-vg${INSTANCE}
	${DWCTL} pod delete ${NAME_PREFIX}-${INSTANCE}
done
