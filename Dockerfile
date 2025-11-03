ARG UID=200019
ARG GID=200019

FROM meyay/languagetool:latest

ARG UID
ARG GID

LABEL maintainer="Thien Tran contact@tommytran.io"

RUN apk -U upgrade \
    && apk add libstdc++ \
    && apk del su-exec \
    && rm -rf /var/cache/apk/*

RUN --network=none \
    usermod -u ${UID} languagetool \
    && groupmod -g ${GID} languagetool \
    && find / -user 783 -exec chown -h languagetool {} \; \
    && find / -group 783 -exec chgrp -h languagetool {} \;

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

USER languagetool
