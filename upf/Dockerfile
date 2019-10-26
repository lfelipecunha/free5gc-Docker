From free5gc-base

RUN apt -y update
RUN apt -y install git gcc cmake autoconf libtool pkg-config libmnl-dev libyaml-dev
RUN go get -u github.com/sirupsen/logrus

WORKDIR $GOPATH/src/free5gc/src/upf

RUN mkdir build; cd build; cmake ..; make -j `nproc`

CMD ./build/bin/free5gc-upfd
