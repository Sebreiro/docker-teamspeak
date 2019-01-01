FROM  debian:stretch-slim

ENV   TS_VERSION=3.5.0  \
      TS_SHA256SUM="9bd56e115afea19351a6238a670dc93e365fe88f8a6c28b5b542ef6ae2ca677e" \
      TS_FILENAME=teamspeak3-server_linux_amd64 \
      TS_HOME=/teamspeak
	  TS3SERVER_LICENSE=accept

RUN   apt-get update && apt-get install curl mysql-common bzip2 locales locales-all -y \
      && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR ${TS_HOME}

RUN     curl -sSLo "/tmp/$TS_FILENAME.tar.gz" "http://dl.4players.de/ts/releases/${TS_VERSION}/${TS_FILENAME}-${TS_VERSION}.tar.bz2" \
        && echo "${TS_SHA256SUM}  /tmp/$TS_FILENAME.tar.gz" | sha256sum -c \
        && tar -xjf "/tmp/$TS_FILENAME.tar.gz" \
        && rm /tmp/$TS_FILENAME.tar.gz \
        && mv ${TS_FILENAME}/* ${TS_HOME} \
        && rm -r ${TS_HOME}/tsdns \
        && rm -r ${TS_FILENAME}

RUN  cp "$(pwd)/redist/libmariadb.so.2" $(pwd)

ADD entrypoint.sh ${TS_HOME}/entrypoint.sh

RUN chmod +x entrypoint.sh

EXPOSE 9987/udp
EXPOSE 10011
EXPOSE 30033

ENTRYPOINT ["./entrypoint.sh"]
