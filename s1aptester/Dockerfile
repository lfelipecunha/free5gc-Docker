FROM ubuntu:18.04

RUN apt-get update && apt-get install -y git vim iputils-ping make gcc rsync net-tools

RUN git clone https://github.com/facebookexperimental/S1APTester.git s1aptester

# resolvendo problema de compilação.
COPY ts_utls.c /s1aptester/TestCntlrStub/src/ts_utls.c

RUN cd /s1aptester/TestCntlrApp/build && make cleanall
RUN cd /s1aptester/TestCntlrApp/build && make 
RUN cp /s1aptester/TestCntlrApp/lib/*  /usr/lib

RUN cd /s1aptester/Trfgen/build && make clean
RUN cd /s1aptester/Trfgen/build && make 
RUN cp /s1aptester/Trfgen/lib/*  /usr/lib

RUN cd /s1aptester/TestCntlrStub/build/ && make clean
RUN cd /s1aptester/TestCntlrStub/build/ && make
COPY nbAppCfg.txt /s1aptester/TestCntlrStub/bin/nbAppCfg.txt

#COPY exec.sh /exec.sh
#RUN chmod +x /exec.sh
#ENTRYPOINT ["/exec.sh"]






