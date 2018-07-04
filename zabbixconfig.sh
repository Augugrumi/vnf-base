#!/bin/sh

# Author: Polonio Davide <poloniodavide@gmail.com>
# License: GPLv3+

# Loading lib
. /usr/lib/libconfig.sh

set_dbg "true"

set_config_path "/etc/zabbix/zabbix_agentd.conf"

msg info "Configurating zabbix agent"

if [ "$GEN_CONFIG_FILE" = "true" ]
then
    reset_config
    cat <<EOF | tee $(get_config_path)
Server=$ZABBIX_SERVER_IP
Hostname=$(awk 'END{print $1}' /etc/hosts)
ListenPort=$ZABBIX_SERVER_PORT
LogType=file
LogFile=/var/log/zabbix/zabbixagent.log
EOF

    check $? "Impossible to create configuration file!"
    msg info "Configuration file created successfully"
else
    msg info "File generation skipped. GEN_CONFIG_FILE is set to: $GEN_CONFIG_FILE"
fi
exit 0
