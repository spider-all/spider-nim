FROM nimlang/nim:onbuild AS build

RUN nimble -d:ssl -d:release build && \
    cp spider config.json /tmp

FROM ubuntu:bionic

WORKDIR /app

COPY --from=build /tmp/spider /app
COPY --from=build /tmp/config.json /app

RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list && \
    sed -i "s/security.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends libssl-dev libsqlite3-dev && \
    rm -rf /var/lib/apt/lists/*

CMD [ "./spider" ]
