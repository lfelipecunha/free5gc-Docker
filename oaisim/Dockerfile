FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y  git vim net-tools cmake g++ kmod linux-headers-`uname -r` sudo

#RUN git clone --branch v1.0.0 https://gitlab.eurecom.fr/oai/openairinterface5g.git
RUN git clone --branch develop https://gitlab.eurecom.fr/oai/openairinterface5g.git

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

# workaround to solve problem when build oai dependencies
RUN adduser oaisim
RUN adduser oaisim sudo
RUN echo "oaisim      ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER oaisim

RUN cd openairinterface5g/cmake_targets && sudo ./build_oai -I

USER root
