FROM ubuntu:18.04

RUN apt-get update && apt-get install -y python3-pip libsctp-dev vim iputils-ping git net-tools
RUN git clone https://github.com/P1sec/pycrate.git pycrate
RUN cd pycrate && python3 setup.py install

RUN git clone https://github.com/P1sec/pysctp.git pysctp
RUN cd pysctp && python3 setup.py install

RUN mkdir /s1aptester

COPY tester.py /s1aptester

WORKDIR /s1aptester

CMD python3 tester.py
