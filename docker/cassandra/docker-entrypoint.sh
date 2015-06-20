#!/bin/bash
set -e

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- cassandra -f "$@"
fi

if [ "$1" = 'cassandra' ]; then
	CASSANDRA_LISTEN_ADDRESS=`/sbin/ip -o -f inet addr show $CASSANDRA_LISTEN_INTERFACE | cut -d" " -f7 | cut -d"/" -f 1`

	if [ "$CASSANDRA_SEEDS" = "" ]; then
	    CASSANDRA_SEEDS="$CASSANDRA_LISTEN_ADDRESS"
	fi

	sed -ri 's/(- seeds:) "127.0.0.1"/\1 '$CASSANDRA_SEEDS'/' "$CASSANDRA_CONFIG/cassandra.yaml"

	CASSANDRA_RPC_ADDRESS="$CASSANDRA_LISTEN_ADDRESS"

	for yaml in \
		listen_address \
		rpc_address \
	; do
		var="CASSANDRA_${yaml^^}"
		val="${!var}"
		if [ "$val" ]; then
			sed -ri 's/^(# )?('"$yaml"':).*/\2 '"$val"'/' "$CASSANDRA_CONFIG/cassandra.yaml"
		fi
	done
fi

exec "$@"
