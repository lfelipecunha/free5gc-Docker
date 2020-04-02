From free5gc-base

COPY free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
COPY amf.conf /free5gc/install/etc/free5gc/freeDiameter/amf.conf

COPY run.sh /usr/sbin/run.sh
RUN chmod +x /usr/sbin/run.sh
#CMD /free5gc/free5gc-amfd

ENTRYPOINT ["/usr/sbin/run.sh"]
