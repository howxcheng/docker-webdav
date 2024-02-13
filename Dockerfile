FROM ubuntu:noble-20240127.1

ARG http_proxy
ARG https_proxy
RUN apt-get update \
    && apt-get full-upgrade -y \
    && apt-get install -yq --no-install-recommends nginx nginx-extras gosu apache2-utils libnginx-mod-http-dav-ext libnginx-mod-http-auth-pam \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /dev/stderr /var/log/nginx/error.log
RUN chmod go+rwX -R /var /run
VOLUME /media

COPY entrypoint.sh /
COPY nginx.conf /etc/nginx/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
