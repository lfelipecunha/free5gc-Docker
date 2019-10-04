From free5gc-base

COPY free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
COPY setup.sh /root/setup.sh
RUN chmod +x /root/setup.sh

CMD /root/setup.sh; /free5gc/free5gc-upfd
