From free5gc-base

RUN apt-get install -y iptables

COPY free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
COPY docker-entrypoint.sh /root/docker-entrypoint.sh
RUN chmod +x /root/docker-entrypoint.sh

ENTRYPOINT [ "/root/docker-entrypoint.sh" ]
