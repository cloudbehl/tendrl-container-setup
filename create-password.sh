#!/bin/bash

ip=$(hostname -I | awk '{print $1}')

echo "$ip tendrlserver" >> /etc/hosts

sed -i.bak '/^ETCD_LISTEN_CLIENT_URLS=/s/=.*/=\"http:\/\/'"${ip}"':2379"/' /etc/etcd/etcd.conf;
sed -i.bak '/^ETCD_ADVERTISE_CLIENT_URLS=/s/=.*/=\"http:\/\/'"${ip}"':2379"/' /etc/etcd/etcd.conf;
sed -i.bak '/^etcd_connection/s/:.*/:\ '"${ip}"'/' /etc/tendrl/node-agent/node-agent.conf.yaml;
sed -i.bak '/^graphite_host/s/:.*/:\ '"${ip}"'/' /etc/tendrl/node-agent/node-agent.conf.yaml;

service etcd restart
service tendrl-node-agent restart
service tendrl-api restart

cd /usr/share/tendrl-api && RACK_ENV=production rake etcd:load_admin && "$@"

exec "$@"
