#!/bin/bash

docker-compose down

data=$(awk -F "=" '/data/ {print $2}' config.ini);

if [ $data == 'persistent' ]; then
  rm -rf /etc/gluster*
  rm -rf /var/lib/glusterd*
  rm -rf /etc/glusterfs*
  rm -rf /var/lib/etcd/*
  rm -rf /var/lib/carbon/whisper/*
  rm -rf /var/lib/grafana/grafana.db
fi

echo "Clean up done, Thanks"
