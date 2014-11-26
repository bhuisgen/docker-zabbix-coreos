#!/bin/sh

HOSTNAME="$1"
SERVER="$2"

if [ -z "$HOSTNAME" ]; then
    echo "Hostname is missing"
    exit 1
fi

if [ -z "$SERVER" ]; then
    echo "Server is missing"
    exit 1
fi

mkdir -p /coreos/{proc,dev,sys}
mkdir -p /coreos/var/run/

sed -i "s/^Hostname\=.*/Hostname\=$HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Server\=.*/Server\=$SERVER/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive\=.*/ServerActive\=$SERVER/" /etc/zabbix/zabbix_agentd.conf

exec /usr/bin/supervisord
