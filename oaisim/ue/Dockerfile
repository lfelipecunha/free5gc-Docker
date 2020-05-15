FROM oai-base

RUN cd openairinterface5g/cmake_targets && sudo ./build_oai --UE -c --musim

RUN apt-get update && apt-get install -y curl
COPY ue_eurecom_test_sfr.conf /openairinterface5g/openair3/NAS/TOOLS/

COPY register_ues /bin

RUN chmod +x /bin/register_ues

COPY docker-entrypoint.sh /root/

RUN chmod +x /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]
