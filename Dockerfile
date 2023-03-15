FROM debian:11-slim
LABEL maintainer="NG6"
ENV WARP_PROXY_PORT=40001

RUN apt-get update && apt-get install -y curl gnupg lsb-release socat && \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

RUN curl https://pkg.cloudflareclient.com/pubkey.gpg | gpg --yes --dearmor --output /usr/share/keyrings/cloudflare-warp-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/cloudflare-warp-archive-keyring.gpg] https://pkg.cloudflareclient.com/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/cloudflare-client.list

RUN apt-get update && apt-get install -y cloudflare-warp && \
    echo "**** cleanup ****" && \
    apt-get clean && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/*

RUN mkdir -p /var/lib/cloudflare-warp
RUN echo '{"always_on": true, "operation_mode": "WarpProxy"}' > /var/lib/cloudflare-warp/settings.json

COPY warp-init.sh /

ENTRYPOINT ["/warp-init.sh"]
