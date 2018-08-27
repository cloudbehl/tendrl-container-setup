#!/bin/bash

docker-compose down

rm -rf /etc/gluster*
rm -rf /var/lib/glusterd*
rm -rf /etc/glusterfs*
rm -rf /var/lib/etcd/*
rm -rf /var/lib/carbon/whisper/*
rm -rf /var/lib/grafana/grafana.db

