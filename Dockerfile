FROM ubuntu:18.04

RUN apt-get update
RUN apt-get -y install git golang-go ifupdown

RUN go get -u -v "github.com/gorilla/mux"
RUN go get -u -v "golang.org/x/net/http2"
RUN go get -u -v "golang.org/x/sys/unix"

RUN apt-get -y install autoconf libtool gcc pkg-config git flex bison libsctp-dev libgnutls28-dev libgcrypt-dev libssl-dev libidn11-dev libmongoc-dev libbson-dev libyaml-dev

#RUN git clone https://bitbucket.org/nctu_5g/free5gc.git
COPY free5gc /free5gc
RUN cd free5gc/support/freeDiameter && ./make_certs.sh .
RUN cd free5gc && autoreconf -iv && ./configure --prefix=`pwd`/install && make -j `nproc` && make install
