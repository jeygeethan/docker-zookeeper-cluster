#!/bin/bash

# the first argument provided is a comma-separated list of all ZooKeeper servers in the ensemble:
export ZOOKEEPER_SERVERS=$1
# the second argument provided is vat of this ZooKeeper node:
export ZOOKEEPER_ID=$2
# the third argument provided corresponding port of standard 2888:
export ZOOKEEPER2888=$3
# the third argument provided corresponding port of standard 3888:
export ZOOKEEPER3888=$4


# create data and blog directories:
mkdir -p $dataDir
mkdir -p $dataLogDir

# create myID file:
echo "$ZOOKEEPER_ID" | tee $dataDir/myid

# now build the ZooKeeper configuration file:
ZOOKEEPER_CONFIG=
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"tickTime=$tickTime"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataDir=$dataDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"dataLogDir=$dataLogDir"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"clientPort=$clientPort"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"initLimit=$initLimit"
ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"syncLimit=$syncLimit"
# Put all ZooKeeper server IPs into an array:
IFS=', ' read -r -a ZOOKEEPER_SERVERS_ARRAY <<< "$ZOOKEEPER_SERVERS"
export ZOOKEEPER_SERVERS_ARRAY=$ZOOKEEPER_SERVERS_ARRAY
# now append information on every ZooKeeper node in the ensemble to the ZooKeeper config:
for index in "${!ZOOKEEPER_SERVERS_ARRAY[@]}"
do
    ZK2888="$ZOOKEEPER2888"
	ZK3888="$ZOOKEEPER3888"
	ZKID=$(($index+1))
    ZKIP=${ZOOKEEPER_SERVERS_ARRAY[index]}
    if [ $ZKID == $ZOOKEEPER_ID ]
    then
        # if IP's are used instead of hostnames, every ZooKeeper host has to specify itself as follows
        ZKIP=0.0.0.0
		ZK2888="2888"
		ZK3888="3888"
    fi
	ZOOKEEPER_CONFIG="$ZOOKEEPER_CONFIG"$'\n'"server.$ZKID=$ZKIP:$ZK2888:$ZK3888"
done
# Finally, write config file:
echo "$ZOOKEEPER_CONFIG" | tee conf/zoo.cfg

# start the server:
/bin/bash bin/zkServer.sh start-foreground
