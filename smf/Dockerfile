From free5gc-base

COPY free5gc.conf /free5gc/install/etc/free5gc/free5gc.conf
COPY smf.conf /free5gc/install/etc/free5gc/freeDiameter/smf.conf

RUN touch /free5gc/install/var/log/free5gc/free5gc.log

#CMD tail -f /free5gc/install/var/log/free5gc/free5gc.log
CMD /free5gc/free5gc-smfd
