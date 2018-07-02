FROM alpine:3.7

LABEL Base image for VNF launched from Openbaton

LABEL maintainer="poloniodavide@gmail.com"

ENV  LANG=en_US.UTF-8 \
     LANGUAGE=en_US.UTF-8 \
     LC_COLLATE=C \
     LC_CTYPE=en_US.UTF-8

# TODO: create supervisord config to launch ems anf zabbit client
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apk add --no-cache --virtual py2-pip git && \
    pip install --upgrade pip && \
    pip install pika && \
    pip install gitpython && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    mkdir /opt/openbaton && \
    pip install openbaton-ems && \
    # TODO: install zabbix client