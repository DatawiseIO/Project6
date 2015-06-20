#!/bin/bash

# Default 512MB memory
MEM=512M

# 1 CPU Core/1000 CPU milli cores
CPU=1000

# Volume size
VOLSIZE=1G

# Cassandra prefix
NAME_PREFIX=${1:-cassandra}

# Number of instances to configure
NUM_INSTANCES=${2:-3}

# dwctl binary
DWCTL=/home/dws/bin/dwctl

# Create volumes
for INSTANCE in `seq 1 ${NUM_INSTANCES}`
do
	${DWCTL} volume create ${NAME_PREFIX}-vg${INSTANCE} -v vol,${VOLSIZE},ext4 -l ${NAME_PREFIX} -x ${NAME_PREFIX}
	if [ $? -ne 0 ]; then
		echo "Failed to create volume: ${NAME_PREFIX}-vg${INSTANCE}"
		exit 1
	else
		echo "Successfully created volume: ${NAME_PREFIX}-vg${INSTANCE}"
	fi
done

# Create pods
for INSTANCE in `seq 1 ${NUM_INSTANCES}`
do
	# Env vars
	ENV_ARGS="-e CASSANDRA_LISTEN_INTERFACE=macvlan0"
	if [ $INSTANCE -ne 1 ]; then
		# Configure first instance as seed
		ENV_ARGS="${ENV_ARGS},CASSANDRA_SEEDS=${NAME_PREFIX}-1"
	fi
	# Other args
	ARGS="-v ${NAME_PREFIX}-vg${INSTANCE}/vol:/data,rw -c ${CPU} -m ${MEM}"

	# Create Pod
	${DWCTL} pod create ${NAME_PREFIX}-${INSTANCE} ${ENV_ARGS} ${ARGS} -i datawiseio/cassandra
	if [ $? -ne 0 ]; then
		echo "Failed to create pod: ${NAME_PREFIX}-${INSTANCE}"
		exit 1
	else
		echo "Successfully created pod: ${NAME_PREFIX}-${INSTANCE}"
	fi
done
