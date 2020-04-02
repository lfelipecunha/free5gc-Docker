FROM alpine:edge
#RUN apt-get update && apt-get install -y ipvsadm

RUN apk add libnl3 musl popt ipvsadm keepalived

COPY keepalived.conf /etc/keepalived/keepalived.conf

COPY run.sh /usr/sbin/run.sh
RUN chmod +x /usr/sbin/run.sh

CMD sh "/usr/sbin/run.sh"
