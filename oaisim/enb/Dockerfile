FROM oai-base

RUN cd openairinterface5g/cmake_targets && sudo ./build_oai --eNB -c --mu

COPY docker-entrypoint.sh /root/

RUN chmod +x /root/docker-entrypoint.sh

ENTRYPOINT ["/root/docker-entrypoint.sh"]
