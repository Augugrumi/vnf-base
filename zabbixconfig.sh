#!/bin/sh

readonly ZABBIX_CONFIG_FILE_PATH="/etc/zabbix/zabbix_agentd.conf"

function check () {
    if [ "$1" -ne 0 ]
    then
        msg err "$2"
        exit 1
    fi
}

function msg () {
    # 3 type of messages:
    # - info
    # - warn
    # - err
    local color=""
    local readonly default="\033[m" #reset
    if [ "$1" = "info" ]
    then
        color="\033[0;32m" #green
    elif [ "$1" = "warn" ]
    then
        color="\033[1;33m" #yellow
    elif [ "$1" = "err" ]
    then
        color="\033[0;31m" #red
    fi

    echo -e "$color==> $2$default"
}

msg info "Configurating zabbix agent"

if [ -a "$ZABBIX_CONFIG_FILE_PATH" ]
then
    msg info "File already existing, deleting it..."
    rm $ZABBI_CONFIG_FILE_PATH
else
    msg info "Creating a new config file..."
fi

cat <<EOF | tee $ZABBIX_CONFIG_FILE_PATH
Server=$ZABBIX_SERVER_IP
Hostname=$(awk 'END{print $1}' /etc/hosts)
ListenPort=$ZABBIX_SERVER_PORT
EOF

check $? "Impossible to create configuration file!"
msg info "Configuration file created successfully"
exit 0
