FROM alpine:3.7

LABEL Base image for VNF launched from Openbaton

LABEL maintainer="poloniodavide@gmail.com"
LABEL license="MIT"

# TODO: create env variable with predefined values.
ENV  LANG=en_US.UTF-8 \
     LANGUAGE=en_US.UTF-8 \
     LC_COLLATE=C \
     LC_CTYPE=en_US.UTF-8 \
     ZABBIX_SERVER_PORT=10050 \

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY zabbixconfig.sh /usr/bin/zabbixconfig

RUN apk add --no-cache --virtual py2-pip git zabbix-agent net-snmp && \
    pip install --upgrade pip && \
    pip install pika && \
    pip install gitpython && \
    pip install supervisor && \
    cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime && \
    mkdir /opt/openbaton && \
    pip install openbaton-ems && \

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]