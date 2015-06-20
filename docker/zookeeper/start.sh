#!/bin/bash

PREFIX=${PREFIX:-zookeeper}
TICK_TIME=${TICK_TIME:-2000}
DATA_DIR=${DATA_DIR:-/data}
CLIENT_PORT=${CLIENT_PORT:-2181}
INIT_LIMIT=${INIT_LIMIT:-5}
SYNC_LIMIT=${SYNC_LIMIT:-2}
NUM_INSTANCES=${NUM_INSTANCES:-1}
MYID=${MYID:-1}

ZOOKEEPER_CONF_FILE=${ZOOKEEPER_CONF_FILE:-/opt/zookeeper/conf/zoo.cfg}

echo "tickTime=${TICK_TIME}" >> ${ZOOKEEPER_CONF_FILE}
echo "dataDir=${DATA_DIR}" >> ${ZOOKEEPER_CONF_FILE}
echo "clientPort=${CLIENT_PORT}" >> ${ZOOKEEPER_CONF_FILE}
echo "initLimit=${INIT_LIMIT}" >> ${ZOOKEEPER_CONF_FILE}
echo "syncLimit=${SYNC_LIMIT}" >> ${ZOOKEEPER_CONF_FILE}

for IDX in `seq 1 ${NUM_INSTANCES}`
do
	if [ "${IDX}" = "${MYID}" ]; then
		echo "server.${IDX}=0.0.0.0:2888:3888" >> ${ZOOKEEPER_CONF_FILE}
	else
		echo "server.${IDX}=${PREFIX}-${IDX}:2888:3888" >> ${ZOOKEEPER_CONF_FILE}
	fi
done

if [ ! -d ${DATA_DIR} ]; then
	mkdir ${DATA_DIR}
fi

echo ${MYID} > ${DATA_DIR}/myid

/opt/zookeeper/bin/zkServer.sh start-foreground
