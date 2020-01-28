From ubuntu:18.04

COPY webui /free5gc/webui
RUN apt-get update && apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install -y nodejs

WORKDIR /free5gc/webui

RUN npm install

CMD npm run dev
