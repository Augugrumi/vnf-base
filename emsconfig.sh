#!/bin/sh

# Author: Polonio Davide <poloniodavide@gmail.com>
# License: GPLv3+

# Loading lib
. /usr/lib/libconfig.sh

set_dbg "true"

set_config_path "/etc/openbaton/openbaton-ems.properties"

msg info "Configurating ems agent"

if [ "$GEN_CONFIG_FILE" = "true" ]
then
    reset_config
    cat <<EOF | tee $(get_config_path)
[ems]
#ip of the rabbitmq host
broker_ip=$RABBIT_MQ_BROKER_IP
#port of communication with rabbitmq
broker_port=$RABBIT_MQ_BROKER_PORT
#hostname, should be the same as in NFVO database
hostname=$NFVO_HOSTNAME_NAME
#type of the vnfm, generic by default
type=$OPENBATON_VNFM_TYPE
#rabbitmq username
username=$RABBITMQ_USERNAME
#rabbitmq password
password=$RABBITMQ_PASSWORD
autodelete=$EMS_AUTODELETE
exchange=$EMS_EXCHANGE
heartbeat=$EMS_HEARTBEAT
virtual_host=$RABBIT_MQ_VIRTUALHOST
EOF

    check $? "Impossible to create configuration file!"
    msg info "Configuration file create successfully"
else
    msg info "File generation skipped. GEN_CONFIG_FILE is set to: $GEN_CONFIG_FILE"
fi
exit 0

