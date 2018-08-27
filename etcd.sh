#!/bin/bash

ip=$(hostname -I | awk '{print $1}')

sed -i.bak '/^ETCD_LISTEN_CLIENT_URLS=/s/=.*/=\"http:\/\/'"${ip}"':2379"/' /etc/etcd/etcd.conf;
sed -i.bak '/^ETCD_ADVERTISE_CLIENT_URLS=/s/=.*/=\"http:\/\/'"${ip}"':2379"/' /etc/etcd/etcd.conf;

exec "$@"
