FROM alpine:3.7

LABEL Base image for VNF launched from Openbaton

LABEL maintainer="poloniodavide@gmail.com"
LABEL license="MIT"

# TODO create ems config file
ENV  LANG=en_US.UTF-8 \
     LANGUAGE=en_US.UTF-8 \
     LC_COLLATE=C \
     LC_CTYPE=en_US.UTF-8 \
     ZABBIX_SERVER_PORT=10050 \
     TIMEZONE=GMT

RUN adduser -S vnf && \
    mkdir -p /var/log/supervisord && \
    mkdir -p /var/log/zabbix/ && \
    chown vnf -R /var/log/supervisord && \
    chown vnf -R /var/log/zabbix

RUN apk add --no-cache --virtual py2-pip && \
    pip install --upgrade pip && \
    pip install pika && \
    pip install gitpython && \
    pip install supervisor && \
    mkdir -p /opt/openbaton && \
    pip install openbaton-ems && \
    mkdir -p /etc/supervisor/conf.d && \
    mkdir -p /var/log/supervisord/ && \
    apk add --no-cache git zabbix-agent net-snmp

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY zabbixconfig.sh /usr/bin/zabbixconfig

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]
