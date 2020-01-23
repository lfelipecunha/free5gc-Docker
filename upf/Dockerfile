From free5gc-base

RUN apt-get install -y iptables

COPY free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
COPY setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh

COPY iptables.sh /root/iptables.sh
RUN chmod +x /root/iptables.sh

CMD /root/setup.sh; /root/iptables.sh; /free5gc/free5gc-upfd
