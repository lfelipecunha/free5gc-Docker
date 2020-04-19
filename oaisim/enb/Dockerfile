FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git vim net-tools cmake g++ \
    libxslt-dev libssl-dev libconfig-dev \
    software-properties-common \
    libtasn1-6-dev libgnutls-dev libatlas-dev iproute libconfig8-dev \
    autoconf automake bison build-essential cmake \
    cmake-curses-gui doxygen doxygen-gui texlive-latex-base \
    ethtool flex gdb graphviz gtkwave guile-2.0-dev iperf \
    iptables iptables-dev libatlas-base-dev libblas-dev \
    liblapack-dev liblapacke-dev libffi-dev libforms-bin \
    libforms-dev libgcrypt11-dev libgmp-dev libgtk-3-dev \
    libidn2-0-dev  libidn11-dev libmysqlclient-dev  liboctave-dev \
    libpgm-dev libpython2.7-dev libsctp1  libsctp-dev \
    libtool libusb-1.0-0-dev libxml2 libxml2-dev libxslt1-dev \
    mscgen octave octave-signal openssh-client openssh-server \
    openssl python subversion xmlstarlet python-pip pydb libyaml-dev \
    wget libxpm-dev nettle-dev nettle-bin sudo \
    cron dbus distro-info-data iso-codes libapparmor1 libapt-inst2.0 libdbus-1-3 \
    lsb-release powermgmt-base python-apt-common python3-apt python3-dbus \
    python3-gi python3-software-properties software-properties-common ucf \
    unattended-upgrades protobuf-compiler libprotobuf-dev protobuf-c-compiler \
    kmod linux-image-lowlatency linux-headers-lowlatency


RUN git clone --branch v1.0.0 https://gitlab.eurecom.fr/oai/openairinterface5g.git

ENV OPENAIR_HOME=/openairinterface5g
ENV OPENAIR_DIR=/openairinterface5g
ENV OPENAIR1_DIR=/openairinterface5g/openair1
ENV OPENAIR2_DIR=/openairinterface5g/openair2
ENV OPENAIR3_DIR=/openairinterface5g/openair3
ENV OPENAIR_TARGETS=/openairinterface5g/targets

RUN alias  oai='cd $OPENAIR_HOME' && \
    alias oai0='cd $OPENAIR0_DIR' && \
    alias oai1='cd $OPENAIR1_DIR' && \
    alias oai2='cd $OPENAIR2_DIR' && \
    alias oai3='cd $OPENAIR3_DIR' && \
    alias oait='cd $OPENAIR_TARGETS' && \
    alias oailte='cd $OPENAIR_TARGETS/RT/USER' && \
    alias oais='cd $OPENAIR_TARGETS/SIMU/USER' && \
    alias oaiex='cd $OPENAIR_TARGETS/SIMU/EXAMPLES'


RUN git clone https://gitlab.eurecom.fr/oai/asn1c.git /tmp/asn1c
RUN cd /tmp/asn1c && git checkout 0a7524184f16e7093990a31d8d4db487a16e5782

RUN cd /tmp/asn1c &&  autoreconf -iv && ./configure &&  make -j`nproc`&& make install
RUN ldconfig

RUN cd /tmp/ && wget https://github.com/google/protobuf/releases/download/v3.3.0/protobuf-cpp-3.3.0.tar.gz
RUN cd /tmp && tar -xzvf protobuf-cpp-3.3.0.tar.gz
RUn cd /tmp/protobuf-3.3.0/ && ./configure && make -j`nproc` && make install && ldconfig

RUN apt-get install -y  linux-headers-`uname -r`

RUN cd openairinterface5g/cmake_targets && ./build_oai --eNB -t ETHERNET -c
COPY nf_api_complement.conf /openairinterface5g/ci-scripts/conf_files/rcc.band7.tm1.nfapi.conf

COPY docker-entrypoint.sh /root/

RUN chmod +x /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]
