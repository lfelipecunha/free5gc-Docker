FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install git wget

RUN wget https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
RUN tar -C /usr/local -zxvf go1.12.9.linux-amd64.tar.gz
RUN mkdir -p ~/go/bin
RUN mkdir -p ~/go/pkg
RUN mkdir -p ~/go/src

ENV GOPATH=/root/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin
ENV GO111MODULE=off

RUN cd ~/go/src && git clone https://bitbucket.org/free5GC/free5gc-stage-2.git free5gc
WORKDIR /root/go/src/free5gc
RUN chmod +x ./install_env.sh
RUN ./install_env.sh
RUN tar -C ~/go -zxvf free5gc_libs.tar.gz

RUN go build -o bin/amf -x src/amf/amf.go
RUN go build -o bin/ausf -x src/ausf/ausf.go
RUN go build -o bin/nssf -x src/nssf/nssf.go
RUN go build -o bin/pcf -x src/pcf/pcf.go
RUN go build -o bin/smf -x src/smf/smf.go
RUN go build -o bin/udm -x src/udm/udm.go

RUN apt-get update
RUN apt-get install gcc -y
RUN go build -o bin/nrf -x src/nrf/nrf.go
RUN go build -o bin/udr -x src/udr/udr.go

CMD bash
