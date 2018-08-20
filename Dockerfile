FROM centos/systemd

MAINTAINER Ankush Behl anbehl@redhat.com

ENV container docker

COPY tendrl-release-epel-7.repo  \
tendrl-dependencies-epel-7.repo \
grafana.repo \
/etc/yum.repos.d/

RUN yum --setopt=tsflags=nodocs -y install epel-release; \
yum --setopt=tsflags=nodocs -y install wget;  \
yum --setopt=tsflags=nodocs -y install etcd; \
yum --setopt=tsflags=nodocs -y install tendrl-node-agent; \
yum --setopt=tsflags=nodocs -y install tendrl-api; \
yum --setopt=tsflags=nodocs -y install tendrl-ui; \
yum --setopt=tsflags=nodocs -y install tendrl-monitoring-integration; \
yum --setopt=tsflags=nodocs -y install tendrl-notifier; \
yum clean all;


RUN sed -i.bak '/^\s\s:host/s/:\s.*/:\ tendrlserver/' /etc/tendrl/etcd.yml; \
sed -i.bak '/^CONF_DIR=/s/=.*/=\/etc\/tendrl\/monitoring-integration\/grafana\//' /etc/sysconfig/grafana-server; \
sed -i.bak '/^CONF_FILE=/s/=.*/=\/etc\/tendrl\/monitoring-integration\/grafana\/grafana.ini/' /etc/sysconfig/grafana-server; \
sed -i.bak '/^datasource_host/s/:.*/:\ tendrlserver/' /etc/tendrl/monitoring-integration/monitoring-integration.conf.yaml; \
sed -i.bak '/^etcd_connection/s/:.*/:\ tendrlserver/' /etc/tendrl/monitoring-integration/monitoring-integration.conf.yaml; \
sed -i.bak '/^etcd_connection/s/:.*/:\ tendrlserver/' /etc/tendrl/notifier/notifier.conf.yaml; 

RUN systemctl enable etcd; \
systemctl enable tendrl-node-agent; \
systemctl enable tendrl-api; \
/usr/lib/python2.7/site-packages/graphite/manage.py syncdb --noinput; \
chown apache:apache /var/lib/graphite-web/graphite.db; \
systemctl enable carbon-cache; \
systemctl enable grafana-server.service; \
systemctl enable tendrl-monitoring-integration; \
systemctl enable tendrl-notifier; \
systemctl enable httpd;

ADD create-password.sh /usr/local/bin/create-password.sh

RUN chmod +x /usr/local/bin/create-password.sh

EXPOSE 2379 2003 10080 80 3000 8789

ENTRYPOINT ["/usr/local/bin/create-password.sh"]
CMD ["/usr/sbin/init"]
