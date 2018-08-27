docker-compose up -d
docker exec gluster_storage1 bash -c "gluster peer probe 10.5.0.4 && gluster peer probe 10.5.0.5"
docker exec tendrl_server bash -c "sleep 5 && cd /usr/share/tendrl-api && RACK_ENV=production rake etcd:load_admin"
