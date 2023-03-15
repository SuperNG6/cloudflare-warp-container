FROM debian:11-slim
LABEL maintainer="NG6"
ENV WARP_PROXY_PORT=40001

RUN apt-get update && apt-get install -y curl socat \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

RUN curl https://pkg.cloudflareclient.com/pubkey.gpg | apt-key add -       \
    && echo 'deb http://pkg.cloudflareclient.com/'                         \
            "$(grep VERSION_CODENAME /etc/os-release | sed 's/^[^=]*=//')" \
            'main' | tee /etc/apt/sources.list.d/cloudflare-client.list

RUN apt-get update && apt-get install -y \
  cloudflare-warp;                       \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/lib/cloudflare-warp
RUN echo '{"always_on": true, "operation_mode": "WarpProxy"}' > /var/lib/cloudflare-warp/settings.json

COPY warp-init.sh /

ENTRYPOINT ["/warp-init.sh"]
