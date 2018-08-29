#!/bin/bash

python createyml.py

docker-compose up -d

sleep 3

tendrlip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' tendrl_server)

for i in `docker ps -a | grep -v "tendrl_server" | awk 'NR>1 {print $1}'`; do
  docker exec $i /bin/sh -c "echo $tendrlip tendrlserver >> /etc/hosts";
done


for i in `docker ps -a | grep -v "tendrl_server" | grep -v "gluster1" | awk 'NR>1 {print $1}'`; do
  docker exec gluster1 bash -c "gluster peer probe $(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $i)";
done


docker exec tendrl_server bash -c "sleep 3 && cd /usr/share/tendrl-api && RACK_ENV=production rake etcd:load_admin"
