FROM alpine:3.7

LABEL Base image for VNF launched from Openbaton

LABEL maintainer="poloniodavide@gmail.com"
LABEL license="MIT"

# List of all possible environment variables:
# EMS:
# - RABBIT_MQ_BROKER_IP
# - NFVO_HOSTNAME_NAME
# - OPENBATON_VNFM_TYPE
# - OPENBATON_VNFM_TYPE
# - RABBITMQ_USERNAME
# - RABBITMQ_PASSWORD
# - EMS_AUTODELETE
# - EMS_EXCHANGE
# - EMS_HEARTBEAT
# - RABBIT_MQ_VIRTUALHOST
# ZABBIX:
# - ZABBIX_SERVER_IP
# - ZABBIX_SERVER_PORT
# MISC:
# - LANG
# - LANGUAGE
# - LC_COLLATE
# - LC_CTYPE
# - TIMEZONE
# - GEN_CONFIG_FILE


ENV  LANG=en_US.UTF-8 \
     LANGUAGE=en_US.UTF-8 \
     LC_COLLATE=C \
     LC_CTYPE=en_US.UTF-8 \
     ZABBIX_SERVER_PORT=10050 \
     TIMEZONE=GMT \
     GEN_CONFIG_FILE=true \
     RABBIT_MQ_BROKER_PORT=5672 \
     OPENBATON_VNFM_TYPE=generic \
     EMS_AUTODELETE=true \
     EMS_EXCHANGE=openbaton-exchange \
     EMS_HEARTBEAT=120 \
     RABBIT_MQ_VIRTUALHOST=/

RUN adduser -S vnf && \
    mkdir -p /var/log/supervisord && \
    mkdir -p /var/log/zabbix/ && \
    mkdir -p /etc/openbaton/ems && \
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

# TODO bad hack, to fix in the future
RUN echo '' >> /usr/lib/python2.7/site-packages/ems/ems.py && \
    echo 'if __name__ == "__main__":' >> /usr/lib/python2.7/site-packages/ems/ems.py && \
    echo '    main()' >> /usr/lib/python2.7/site-packages/ems/ems.py

COPY libconfig.sh /usr/lib/libconfig.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY zabbixconfig.sh /usr/bin/zabbixconfig
COPY emsconfig.sh /usr/bin/emsconfig

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisor/conf.d/supervisord.conf"]
