# Build Dynamic DNS Container For NoIP.com
ARG IMAGE_USER=geoffh1977
ARG IMAGE_NAME=alpine
ARG IMAGE_VERSION=latest

# Build NoIP Executable
FROM geoffh1977/alpine:latest as builder
USER root

RUN apk add -U ca-certificates curl make gcc libc-dev && \
  curl -o /tmp/noip-duc-linux.tar.gz  https://www.noip.com/client/linux/noip-duc-linux.tar.gz && \
  tar zxf /tmp/noip-duc-linux.tar.gz -C /tmp && \
  cd /tmp/noip-* && \
  make && \
  cp noip2 /tmp/noip2

# Final NoIp Container
FROM ${IMAGE_USER}/${IMAGE_NAME}:${IMAGE_VERSION}
LABEL maintainer="geoffh1977 <geoffh1977@gmail.com>"
USER root

COPY --from=builder /tmp/noip2 /usr/bin/
COPY scripts/* /usr/local/bin/

RUN apk add -U --no-cache expect bash curl jq && \
  mkdir /config && \
  chown ${ALPINE_USER}:${ALPINE_USER} -R /config && \
  chmod +x /usr/local/bin/start.sh /usr/local/bin/healthcheck.sh && \
  rm -rf /var/cache/apk/*

USER ${ALPINE_USER}
CMD ["/usr/local/bin/start.sh"]

HEALTHCHECK --interval=60s --timeout=5s CMD /usr/local/bin/healthcheck.sh > /dev/null
