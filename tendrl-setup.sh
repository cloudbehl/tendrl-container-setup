#!/bin/bash

NODES=$(awk -F "=" '/node/ {print $2}' config.ini);
CLUSTERS=$(awk -F "=" '/clusters/ {print $2}' config.ini);
COUNT=0
BRICKPATH=':/gluster/brick1 '
FORCE="force"
VOLNAME="distributed-vol"

python createyml.py

docker-compose up -d

sleep 3

TENDRLIP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tendrl_server)

for i in `docker ps | grep -v "tendrl_server" | awk 'NR>1 {print $1}'`; do
  docker exec $i /bin/sh -c "echo $TENDRLIP tendrlserver >> /etc/hosts";
done


for i in $(seq 1 $CLUSTERS); do
  echo "Creating Cluster $i"
  PROBENODE=$((((i-1) * NODES)+1))
  for j in $(seq 1 $NODES); do
    var=$((COUNT+=1))
    if [ `echo "$COUNT % $NODES" | bc` -ne 1 ]; then
      docker exec gluster$PROBENODE bash -c "gluster peer probe gluster$COUNT";
    fi
  done
done

#for i in $(seq 1 $CLUSTERS); do
#  MASTERNODE=$((((i-1) * NODES)+1))
#  COMMAND="gluster volume create $VOLNAME gluster$MASTERNODE$BRICKPATH";
#  docker exec gluster$MASTERNODE bash -c "mkdir -p /gluster/brick1";
#  for HOSTNAME in `docker exec gluster$i bash -c "gluster pool list" | awk 'NR>1 {print $2}'`; do
#    if [ $HOSTNAME != 'localhost' ]; then
#      docker exec $HOSTNAME bash -c "mkdir -p /gluster/brick1";
#      COMMAND=$COMMAND$HOSTNAME$BRICKPATH;
#    fi
#  done
#  COMMAND=$COMMAND$FORCE;
#  docker exec gluster$MASTERNODE bash -c "$COMMAND";
#  sleep 2;
#  docker exec gluster$MASTERNODE bash -c "gluster volume start $VOLNAME";
#done

docker exec tendrl_server bash -c "sleep 2 && cd /usr/share/tendrl-api && RACK_ENV=production rake etcd:load_admin"
